use axum::{http::StatusCode, response::IntoResponse};
use handlebars::RenderError;

pub type Error = Box<dyn std::error::Error>;

#[allow(clippy::module_name_repetitions)]
pub struct AppError(Error);

impl IntoResponse for AppError {
    fn into_response(self) -> axum::response::Response {
        (
            StatusCode::INTERNAL_SERVER_ERROR,
            format!("something went wrong: {}", self.0),
        )
            .into_response()
    }
}

impl From<Error> for AppError {
    fn from(value: Error) -> Self {
        Self(value)
    }
}

impl From<RenderError> for AppError {
    fn from(value: RenderError) -> Self {
        Self(Box::new(value))
    }
}
