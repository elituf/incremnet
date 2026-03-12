import "dotenv/config";

import { initDb } from "./database.js";
import run from "./server.js";

initDb();
run();
