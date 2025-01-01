use axum::{extract::Request, routing::get, Router};
use clap::Parser;

#[tokio::main]
async fn main() {
    let args = Args::parse();

    let app = Router::new().route("/", get(handler));

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", args.port))
        .await
        .unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn handler(request: Request) -> String {
    let (parts, _) = request.into_parts();

    let response_text = format!("{parts:#?}");

    println!("{response_text}");

    response_text
}

#[derive(clap::Parser, Debug)]
#[command(version)]
struct Args {
    /// Port to bind to
    #[arg(default_value_t = 8080)]
    port: u16,
}
