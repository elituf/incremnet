import { Eta } from "eta";
import path from "node:path";

export const eta = new Eta({
  views: path.join("templates"),
  defaultExtension: ".html",
  useWith: true,
  cache: true,
});
