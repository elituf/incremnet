mod args;
mod dump;
mod set;

use args::{Args, Cmd};

use clap::Parser;

type Error = Box<dyn std::error::Error>;

fn main() -> Result<(), Error> {
    let args = Args::parse();
    if let Some(cmd) = args.cmd {
        match cmd {
            Cmd::Dump { from, to } => dump::dump(&from, &to)?,
            Cmd::Set { db, user, amount } => set::set(&db, &user, amount)?,
        }
    }
    Ok(())
}
