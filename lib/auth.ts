import type { NextAuthOptions } from "next-auth";
import GoogleProvider from "next-auth/providers/google";

function requiredEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Variável de ambiente obrigatória ausente: ${name}`);
  }
  return value;
}

// Avaliação na requisição: o build não precisa das credenciais Google.
export function getAuthOptions(): NextAuthOptions {
  return {
    secret: requiredEnv("NEXTAUTH_SECRET"),
    session: { strategy: "jwt" },
    providers: [
      GoogleProvider({
        clientId: requiredEnv("GOOGLE_CLIENT_ID"),
        clientSecret: requiredEnv("GOOGLE_CLIENT_SECRET"),
      }),
    ],
  };
}
