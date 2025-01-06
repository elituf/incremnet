use std::path::PathBuf;

use clap::{Parser, Subcommand};

#[derive(Subcommand)]
pub enum Cmd {
    Dump {
        from: PathBuf,
        to: PathBuf,
    },
    Set {
        db: PathBuf,
        user: String,
        amount: u64,
    },
}

#[derive(Parser)]
pub struct Args {
    #[command(subcommand)]
    pub cmd: Option<Cmd>,
}
