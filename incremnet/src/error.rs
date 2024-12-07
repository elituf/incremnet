use axum::{http::StatusCode, response::IntoResponse};

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

impl<E> From<E> for AppError
where
    E: Into<Error>,
{
    fn from(value: E) -> Self {
        Self(value.into())
    }
}
