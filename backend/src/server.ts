import Fastify from "fastify";

import { log } from "./logger.js";
import { eta } from "./templates.js";
import { get, set, incremnet, del, bulkGet, bulkSet } from "./database.js";
import { requireBearer } from "./handlers.js";

const fastify = Fastify({
  loggerInstance: log,
});

fastify.get<{ Querystring: { key: string } }>("/badge", async (req, reply) => {
  const key = req.query.key;
  if (!key) {
    return reply.code(400).send({ error: "missing `key` parameter" });
  }
  const value = await get(key);
  const html = eta.render("badge", { key, value });
  return reply.code(200).type("text/html").send(html);
});

fastify.post<{ Querystring: { key: string } }>("/badge", async (req, reply) => {
  const key = req.query.key;
  if (!key) {
    return reply.code(400).send({ error: "missing `key` parameter" });
  }
  const value = await incremnet(key);
  return reply.code(200).type("text/plain").send(value);
});

fastify.put<{
  Params: { key: string; count: string };
}>(
  "/admin/:key/:count",
  { preHandler: [requireBearer] },
  async (req, reply) => {
    const { key, count: countStr } = req.params;
    const count = parseInt(countStr);
    if (isNaN(count)) {
      return reply.code(400).send({ error: "count must be an integer" });
    }
    const countPrevious = await get(key);
    await set(key, count);
    return reply.code(200).send({ key, countPrevious, count });
  },
);

fastify.delete<{
  Params: { key: string };
}>("/admin/:key", { preHandler: [requireBearer] }, async (req, reply) => {
  const { key } = req.params;
  const countPrevious = await get(key);
  await del(key);
  return reply.code(200).send({ key, countPrevious });
});

fastify.get(
  "/admin/export",
  { preHandler: [requireBearer] },
  async (req, reply) => {
    const entries = await bulkGet();
    return reply.code(200).send(entries);
  },
);

fastify.post<{
  Body: Record<string, number>;
}>("/admin/import", { preHandler: [requireBearer] }, async (req, reply) => {
  const entries = req.body;
  if (!entries) {
    return reply.code(400).send({ error: "missing json body" });
  }
  await bulkSet(entries);
  return reply.code(200).send({ imported: Object.keys(entries).length });
});

export default async function run() {
  try {
    await fastify.listen({ port: parseInt(process.env.SERVER_PORT!) });
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
}
