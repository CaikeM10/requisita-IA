import type { NextApiRequest, NextApiResponse } from "next";
import NextAuth from "next-auth";
import { getAuthOptions } from "../../../lib/auth";

export default function handler(req: NextApiRequest, res: NextApiResponse) {
  return NextAuth(req, res, getAuthOptions());
}
