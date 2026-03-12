import { createClient } from "@libsql/client";

const database = createClient({
  url: process.env.DATABASE_URL!,
});

export async function initDb() {
  await database.execute({
    sql: `CREATE TABLE IF NOT EXISTS users (
            key TEXT PRIMARY KEY,
            value INTEGER NOT NULL DEFAULT 0
          )`,
  });
}

export async function get(key: string): Promise<number> {
  const result = await database.execute({
    sql: `SELECT value
          FROM users
          WHERE key = ?`,
    args: [key],
  });
  return (result.rows[0]?.value as number) ?? 0;
}

export async function set(key: string, value: number): Promise<number> {
  const result = await database.execute({
    sql: `INSERT INTO users(key, value) VALUES (?, ?)
          ON CONFLICT(key) DO UPDATE SET value = excluded.value
          RETURNING value`,
    args: [key, value],
  });
  return result.rows[0]!.value as number;
}

export async function incremnet(key: string): Promise<number> {
  const result = await database.execute({
    sql: `INSERT INTO users(key, value) VALUES (?, 1)
          ON CONFLICT(key) DO UPDATE SET value = value + 1
          RETURNING value`,
    args: [key],
  });
  return result.rows[0]!.value as number;
}

export async function del(key: string): Promise<void> {
  await database.execute({
    sql: `DELETE FROM users WHERE key = ?`,
    args: [key],
  });
}

export async function bulkGet(): Promise<Record<string, number>> {
  const result = await database.execute({
    sql: `SELECT key, value FROM users`,
  });
  const entries: Record<string, number> = {};
  for (const row of result.rows) {
    entries[row.key as string] = row.value as number;
  }
  return entries;
}

export async function bulkSet(entries: Record<string, number>): Promise<void> {
  for (const [key, value] of Object.entries(entries)) {
    await set(key, value);
  }
}
