mod db;

use std::sync::Arc;

use axum::{
    extract::{Query, State},
    http::StatusCode,
    response::Html,
    routing::get,
    Json, Router,
};
use base64::prelude::*;
use db::AppState;
use handlebars::Handlebars;
use minify_html::Cfg;
use redb::{Database, TableDefinition};
use serde::Deserialize;
use serde_json::json;

type Error = Box<dyn std::error::Error>;

#[derive(Deserialize)]
struct Params {
    key: String,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let image = include_bytes!("../static/bg.png");
    let image = BASE64_STANDARD.encode(image);
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
) -> (StatusCode, Html<String>) {
    let reg = Handlebars::new();
    let value = state.get(&params.key).unwrap();
    let html = reg
        .render_template(
            include_str!("../templates/badge.html"),
            &json!({"key": &params.key, "value": value, "image": state.image}),
        )
        .unwrap();
    let cfg = Cfg {
        minify_css: true,
        minify_js: true,
        ..Default::default()
    };
    let html = minify_html::minify(html.as_bytes(), &cfg);
    let html = String::from_utf8_lossy(&html).to_string();
    (StatusCode::OK, Html(html))
}

async fn post_badge(
    State(state): State<Arc<AppState<'_>>>,
    Query(params): Query<Params>,
) -> (StatusCode, Json<serde_json::Value>) {
    let value = state.get(&params.key).unwrap();
    state.set(&params.key, value + 1).unwrap();
    let value = state.get(&params.key).unwrap();
    (StatusCode::OK, json!({ "value": value }).into())
}
