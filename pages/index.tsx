import Head from "next/head";
import Link from "next/link";
import { signIn, signOut, useSession } from "next-auth/react";

export default function Home() {
  const { data: session, status } = useSession();

  return (
    <>
      <Head>
        <title>RequisitaIA</title>
        <meta name="description" content="Assistente para levantamento inicial de requisitos." />
      </Head>
      <main>
        <h1>RequisitaIA</h1>
        <p>Um escopo inicial mais claro para o seu projeto.</p>
        {status === "loading" ? (
          <p role="status">Verificando sessão...</p>
        ) : session ? (
          <>
            <p>Conectado como {session.user?.email ?? "usuário"}.</p>
            <nav aria-label="Conta">
              <Link href="/protegida">Acessar página protegida</Link>
              <button type="button" onClick={() => void signOut({ callbackUrl: "/" })}>
                Sair
              </button>
            </nav>
          </>
        ) : (
          <button type="button" onClick={() => void signIn("google", { callbackUrl: "/protegida" })}>
            Entrar com Google
          </button>
        )}
      </main>
    </>
  );
}
