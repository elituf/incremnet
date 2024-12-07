mod db;
mod error;

use db::AppState;
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
use redb::{Database, TableDefinition};
use serde::Deserialize;
use serde_json::json;

#[derive(Deserialize)]
struct Params {
    key: String,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let image = BASE64_STANDARD.encode(include_bytes!("../../static/bg.png"));
    let state = Arc::new(AppState {
        db: Database::create("users.redb")?,
        table: TableDefinition::new("users"),
        image,
    });
    state.init()?;
    let app = Router::new()
        .route("/badge", get(get_badge).post(post_badge))
        .with_state(state);
    let listener = tokio::net::TcpListener::bind("0.0.0.0:1337").await?;
    axum::serve(listener, app).await?;
    Ok(())
}

async fn get_badge(
    State(state): State<Arc<AppState<'_>>>,
    Query(params): Query<Params>,
) -> Result<(StatusCode, Html<String>), AppError> {
    let reg = handlebars::Handlebars::new();
    let value = state.get(&params.key)?;
    let html = reg.render_template(
        include_str!("../templates/badge.handlebars"),
        &json!({"key": &params.key, "value": value, "image": state.image}),
    )?;
    let cfg = minify_html::Cfg {
        minify_css: true,
        minify_js: true,
        ..Default::default()
    };
    let html = minify_html::minify(html.as_bytes(), &cfg);
    let html = String::from_utf8_lossy(&html).to_string();
    Ok((StatusCode::OK, Html(html)))
}

async fn post_badge(
    State(state): State<Arc<AppState<'_>>>,
    Query(params): Query<Params>,
) -> Result<(StatusCode, Json<serde_json::Value>), AppError> {
    let value = state.get(&params.key)?;
    state.set(&params.key, value + 1)?;
    let value = state.get(&params.key)?;
    Ok((StatusCode::OK, json!({ "value": value }).into()))
}
