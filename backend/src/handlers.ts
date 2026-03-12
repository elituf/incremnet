import type { FastifyReply, FastifyRequest } from "fastify";

export async function requireBearer(req: FastifyRequest, reply: FastifyReply) {
  const token = req.headers.authorization?.split(" ")[1];
  if (!token || token !== process.env.ADMIN_SECRET!) {
    return reply.code(401).send({ error: "you are not authorized" });
  }
}
