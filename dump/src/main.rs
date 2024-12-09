use std::{collections::BTreeMap, fs::File, io::Write};

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

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let db = Database::open("backups/users.bak.redb")?;
    let tx = db.begin_read()?;
    let tb = tx.open_table(TABLE)?;
    let map = table_to_map(&tb);
    let json = serde_json::to_string_pretty(&map)?;
    let mut file = File::create("backups/users.json")?;
    file.write_all(json.as_bytes())?;
    Ok(())
}
