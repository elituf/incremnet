mod db;
mod error;

use db::DbWrapper;
use error::{AppError, Error};

use std::sync::Arc;

use axum::{
    extract::{Query, State},
    http::StatusCode,
    response::{Html, Json},
    routing::get,
    Router,
};
use base64::prelude::{Engine, BASE64_STANDARD};
use handlebars::Handlebars;
use redb::{Database, TableDefinition};
use serde::Deserialize;
use serde_json::json;

struct AppState<'a> {
    db: DbWrapper,
    image: String,
    handlebars: Handlebars<'a>,
    minify_cfg: minify_html::Cfg,
}

#[derive(Deserialize)]
struct Params {
    key: String,
}

async fn get_badge(
    State(state): State<Arc<AppState<'_>>>,
    Query(params): Query<Params>,
) -> Result<(StatusCode, Html<String>), AppError> {
    let value = state.db.get(&params.key)?;
    let html = state.handlebars.render(
        "badge",
        &json!({"key": &params.key, "value": value, "image": state.image}),
    )?;
    let html = minify_html::minify(html.as_bytes(), &state.minify_cfg);
    let html = String::from_utf8_lossy(&html).to_string();
    Ok((StatusCode::OK, Html(html)))
}

async fn post_badge(
    State(state): State<Arc<AppState<'_>>>,
    Query(params): Query<Params>,
) -> Result<(StatusCode, Json<serde_json::Value>), AppError> {
    let value = state.db.get(&params.key)?;
    state.db.set(&params.key, value + 1)?;
    let value = state.db.get(&params.key)?;
    Ok((StatusCode::OK, json!({ "value": value }).into()))
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let image = BASE64_STANDARD.encode(include_bytes!("../static/bg.png"));
    let mut handlebars = Handlebars::new();
    handlebars.register_template_file("badge", "incremnet/templates/badge.handlebars")?;
    let state = Arc::new(AppState {
        db: DbWrapper {
            db: Database::create("users.redb")?,
            table: TableDefinition::new("users"),
        },
        image,
        handlebars,
        minify_cfg: minify_html::Cfg {
            minify_css: true,
            minify_js: true,
            ..Default::default()
        },
    });
    state.db.init()?;
    let app = Router::new()
        .route("/badge", get(get_badge).post(post_badge))
        .with_state(state);
    let listener = tokio::net::TcpListener::bind("0.0.0.0:1337").await?;
    axum::serve(listener, app).await?;
    Ok(())
}
