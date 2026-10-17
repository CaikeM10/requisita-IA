import type { GetServerSideProps } from "next";
import Head from "next/head";
import type { Session } from "next-auth";
import { getServerSession } from "next-auth/next";
import { signOut } from "next-auth/react";
import { getAuthOptions } from "../lib/auth";

type Props = { session: Session };

export const getServerSideProps: GetServerSideProps<Props> = async ({ req, res }) => {
  res.setHeader("Cache-Control", "private, no-store");
  const session = await getServerSession(req, res, getAuthOptions());

  if (!session) {
    return { redirect: { destination: "/", permanent: false } };
  }
  return { props: { session } };
};

export default function ProtectedPage({ session }: Props) {
  return (
    <>
      <Head><title>Área protegida | RequisitaIA</title></Head>
      <main>
        <h1>Área protegida</h1>
        <p>Olá, {session.user?.name ?? "usuário"}.</p>
        <p>Você está autenticado no RequisitaIA.</p>
        <button type="button" onClick={() => void signOut({ callbackUrl: "/" })}>
          Sair
        </button>
      </main>
    </>
  );
}
