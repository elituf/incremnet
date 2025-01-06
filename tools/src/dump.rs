use crate::Error;

use std::{collections::BTreeMap, fs::File, io::Write, path::Path};

use redb::{Database, ReadOnlyTable, ReadableTable, TableDefinition};

const TABLE: TableDefinition<&str, u64> = TableDefinition::new("users");

fn table_to_map(tb: &ReadOnlyTable<&str, u64>) -> BTreeMap<String, u64> {
    let mut map: BTreeMap<String, u64> = BTreeMap::new();
    if let Ok(range) = tb.iter() {
        for entry in range.flatten() {
            println!("{:?}: {}", entry.0.value().to_string(), entry.1.value());
            map.insert(entry.0.value().to_string(), entry.1.value());
        }
    }
    map
}

pub fn dump(from: &Path, to: &Path) -> Result<(), Error> {
    let db = Database::open(from)?;
    let mut file = File::create(to)?;
    let tx = db.begin_read()?;
    let tb = tx.open_table(TABLE)?;
    let map = table_to_map(&tb);
    let json = serde_json::to_string_pretty(&map)?;
    file.write_all(json.as_bytes())?;
    Ok(())
}
