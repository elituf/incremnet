use crate::Error;

use std::path::Path;

use redb::{Database, TableDefinition};

pub fn set(db_path: &Path, user: &str, amount: u64) -> Result<(), Error> {
    let db = redb_wrapper::Db {
        db: Database::create(db_path)?,
        table: TableDefinition::new("users"),
    };
    db.set(user, amount)?;
    Ok(())
}
