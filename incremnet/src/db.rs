use crate::error::Error;

use redb::{Database, TableDefinition};

pub struct AppState<'a> {
    pub db: Database,
    pub table: TableDefinition<'a, &'static str, u64>,
    pub image: String,
}

impl AppState<'_> {
    pub fn init(&self) -> Result<(), Error> {
        let tx = self.db.begin_write()?;
        {
            let mut table = tx.open_table(self.table)?;
            table.insert("", 0)?;
        }
        tx.commit()?;
        Ok(())
    }

    pub fn set(&self, key: &str, amt: u64) -> Result<(), Error> {
        let tx = self.db.begin_write()?;
        {
            let mut table = tx.open_table(self.table)?;
            table.insert(key, amt)?;
        }
        tx.commit()?;
        Ok(())
    }

    pub fn get(&self, key: &str) -> Result<u64, Error> {
        let tx = self.db.begin_read()?;
        let table = tx.open_table(self.table)?;
        if let Some(value) = table.get(key)? {
            Ok(value.value())
        } else {
            Self::set(self, key, 0)?;
            Ok(0)
        }
    }
}
