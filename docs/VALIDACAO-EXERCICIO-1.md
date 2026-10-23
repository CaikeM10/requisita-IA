# Validação do exercício 1

Branch: `feat/google-auth`. README existente preservado.

## Dependências

Versões confirmadas com `npm view` antes da instalação e com
`npm ls --depth=0` depois dela:

- Node instalado: 22.16.0; npm: 11.5.2.
- Next.js: 16.4.2; NextAuth: 4.24.15.
- React e React DOM: 19.3.1.
- TypeScript: 7.0.2.
- @types/node: 22.20.5.
- @types/react e @types/react-dom: 19.3.0.

Nenhuma versão precisou ser alterada. A instalação não utilizou `--force`
nem `--legacy-peer-deps`.

## Resultados

- `npm install`: saída 0; 95 pacotes adicionados, 96 auditados,
  nenhuma vulnerabilidade reportada.
- `npm ls --depth=0`: saída 0, versões conforme a lista acima.
- `npm run check`: saída 0, incluindo `next typegen`, `tsc --noEmit`
  e `next build`; nenhuma credencial Google configurada.
- Build: `/` estática; `/protegida` e `/api/auth/[...nextauth]` dinâmicas.
- `npm run hooks:install`: saída 0; `core.hooksPath` igual a `.githooks`.
- `git check-ignore -v -- .env.local`: correspondência com `.env*`.
- `git diff --exit-code -- README.md`: saída 0.

## Falha e correção

A primeira tentativa de criar a branch retornou:

```text
fatal: cannot lock ref 'refs/heads/feat/google-auth': unable to create directory for .git/refs/heads/feat/google-auth
```

O sandbox impediu a escrita em `.git`. A mesma operação foi repetida com
permissão elevada e criou a branch com sucesso. Não foi necessário mudar código
ou dependências para corrigir esse bloqueio.

## Hook

O hook lista e bloqueia arquivos não rastreados e não ignorados. Arquivos do
projeto, incluindo este documento e `package-lock.json`, devem ser adicionados
com `git add -- <caminho>`. Artefatos locais devem ser ignorados; segredos nunca
devem ser adicionados. Também bloqueia alterações rastreadas fora do stage.
Depois executa tipos e build e propaga qualquer falha.

Para ativar em outro clone: `npm ci` e `npm run hooks:install`.
Ao preparar os arquivos para um futuro commit, preservar o modo executável:
`git update-index --chmod=+x .githooks/pre-commit`.

Não foi executado commit nem teste de commit com erro proposital.

## Login Google pendente

1. Criar cliente OAuth Web no Google e configurar uma conta de teste, se exigida.
2. Registrar origem `http://localhost:3000` e callback
   `http://localhost:3000/api/auth/callback/google`.
3. Copiar `.env.example` para `.env.local`, preencher credenciais reais e gerar
   um `NEXTAUTH_SECRET` aleatório; manter todos esses valores fora do Git.
4. Executar `npm run dev` e validar login, acesso à página protegida e logout.
5. Em janela anônima e após logout, confirmar que `/protegida` redireciona para `/`.
6. Repetir com `npm run build` e `npm start` para validar o modo de produção.

O build aprovado não comprova o funcionamento do OAuth; esse fluxo depende
das credenciais e ainda não foi testado.

## Preparação local — 17/10/2026

- Confirmada a branch `feat/google-auth`; alterações existentes preservadas.
- Confirmado que `.env.local` não existia, está ignorado por `.env*` e não
  consta no índice do Git.
- Criado `.env.local` com URL local e segredo gerado por `node:crypto`, usando
  32 bytes aleatórios, gravado diretamente sem exibição do valor.
- Campos Google deixados vazios para preenchimento manual no editor.
- Aguardando confirmação de preenchimento antes de validar as variáveis
  e iniciar o servidor. Login, logout e proteção em execução ainda não testados.

## Inicialização após preenchimento manual

- Usuário confirmou preenchimento das credenciais. Validação local confirmou
  as quatro variáveis obrigatórias presentes, únicas, não vazias e sem os
  marcadores de exemplo verificados; valores não foram exibidos. Essa checagem
  não comprova a aceitação das credenciais pelo Google.
- `.env.local` continua ignorado e não rastreado; branch `feat/google-auth`.
- Porta 3000 livre antes da inicialização; nenhum processo foi encerrado.
- A primeira execução do validador falhou por escape de aspas no PowerShell
  (`SyntaxError: Invalid or unexpected token`). Corrigida a comparação de aspas
  para usar códigos de caracteres; nova execução aprovada para as quatro variáveis.
- A chamada `npm run dev -- --port 3000` pelo PowerShell encaminhou `3000`
  como diretório e falhou com `Invalid project directory provided`.
  Correção: `cmd /c npm run dev -- --port 3000`, preservando argumentos.
- Next.js informou servidor pronto em `http://localhost:3000`, carregando
  `.env.local`. Nenhum segredo registrado.
- Requisição HTTP à página inicial retornou status 200 e conteúdo contendo
  `RequisitaIA`. README permanece sem alterações.
- Login e logout Google aguardam teste e confirmação do usuário.

## Testes manuais confirmados pelo usuário

O usuário confirmou os seguintes resultados no servidor de desenvolvimento:

- Login Google concluído com sucesso.
- Atualização da página (F5) manteve a sessão autenticada.
- Logout retornou à página inicial.
- Acesso a `/protegida` após sair redirecionou para `/`.

São confirmações manuais do usuário, não testes automatizados do agente.
O acesso sem sessão antes do primeiro login e o fluxo em modo de produção
não foram confirmados separadamente.

## Teste autorizado de bloqueio do commit

- Branch conferida: `feat/google-auth`.
- Arquivos do exercício adicionados explicitamente ao stage, incluindo
  `AGENTS.md`, gerado pelo Next.js com instruções para agentes.
- `.env.local`, `node_modules` e `.next` não foram preparados para commit.
- Hook ativo: `core.hooksPath=.githooks`; modo no índice: `100755`.
- Criado temporariamente `lib/commit-hook-check.ts`, incluído no typecheck,
  contendo `export const commitHookTypeCheck: number = "erro intencional";`.
  O arquivo foi adicionado ao stage antes da tentativa.
- Comando executado, sem desativar verificações:

```text
git commit -m "test: comprovar bloqueio do hook por erro de tipo"
```

O hook executou `npm run check`, gerou os tipos e bloqueou por TypeScript:

```text
lib/commit-hook-check.ts(2,14): error TS2322: Type 'string' is not assignable to type 'number'.
```

- Código de saída do commit: **1**. A falha era intencional para este teste.
- HEAD antes e depois: `b87310857355aee5c478bfcb39a3244ad50baffe`.
  Nenhum commit foi criado.
- Correção: removido somente o arquivo temporário e atualizada sua remoção
  no stage com `git add -u -- lib/commit-hook-check.ts`.
- `npm run check` após a correção: **saída 0**, com geração de tipos,
  `tsc --noEmit` e build de produção concluídos com sucesso.
- Nenhum processo de desenvolvimento precisou ser encerrado para o build.
- Auditoria do diff preparado: nenhum arquivo proibido, nenhuma correspondência
  com os valores locais de segredo e credenciais, nem marcadores de segredo real
  verificados. A auditoria não exibiu valores de `.env.local`.
- `git diff --cached --check`: saída 0. README preservado.
- Commit definitivo, push e PR não executados.
