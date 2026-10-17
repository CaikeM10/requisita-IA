# Preparação do exercício 2 — proposta para revisão

## Passos observados

- Git inicialmente limpo em `feat/google-auth`.
- Criada `feat/user-phone` a partir de `feat/google-auth`, preservando o commit
  `33b25dd603f8358ca05c4ccd02fa364e04215e04`.
- Base prevista do futuro PR: `feat/google-auth`. Nenhum merge do PR #1.
- Atlassian oferecido para instalação/conexão neste ambiente; a sugestão não
  instala nem autentica. Conexão e acesso ao Jira ainda não confirmados.
- MCP Supabase: `list_organizations`, `get_organization` e `list_projects`
  responderam. A única organização retornada foi `fakejp27-4811's projects`,
  com plano `free` e identificador `vercel_icfg_AwthokXFF02HjaIIo9OLGj9B`.
- Os dois projetos existentes retornaram `INACTIVE`; nenhum foi modificado.
- Documentação consultada via Context7: `resolve_library_id` para Supabase,
  seguido de `query_docs` com `/supabase/supabase` sobre schema privado,
  privilégios e RLS. Consultadas também páginas oficiais de preços e changelog.
- O endpoint Markdown do changelog não foi aceito pela ferramenta de leitura
  (`Unsupported content-type: text/markdown`); a página HTML foi consultada.

## Gratuidade: condição ainda não confirmada para criação

A página https://supabase.com/pricing informa plano Free de US$ 0/mês,
limite de dois projetos ativos e pausa após uma semana sem atividade.
O plano da organização acessível foi confirmado como Free, mas isso não é uma
cotação nem uma garantia de elegibilidade para criar um terceiro projeto.
Projetos inativos não foram excluídos nem reativados.

Antes de cotar pelo MCP, o usuário precisa escolher explicitamente a organização.
A ferramenta `get_cost` exige essa escolha; nenhuma cotação foi solicitada por
inferência e nenhum recurso foi criado. A ferramenta de criação ainda não foi
usada para verificar se permite selecionar explicitamente o plano Free.
Sem confirmação de custo zero e ausência de cobrança, usar o painel Supabase:
selecionar organização Free, nome sugerido `requisitaia-lab-dev`, conferir o
resumo de criação e interromper se houver upgrade ou valor pago. Não fornecer
senha de banco nem tokens no chat.

## Atlassian

Instalar o plugin Atlassian pela opção disponível neste ambiente e concluir a
conexão no navegador com a conta que possui acesso ao Jira. Escolher o site
correto e autorizar os acessos necessários para consultar/criar/atualizar tickets.
Se o cliente solicitar recarga da sessão, recarregar e confirmar a conexão.
Depois, validar o acesso por uma leitura e informar projeto Jira e ticket, se
já existir. Não foi criado nem atualizado ticket; nenhuma mensagem enviada.

## Estrutura inicial NOVA — não consultada no banco

Este SQL é somente proposta, ainda não aplicada nem validada em um banco.
Cria usuários fictícios de laboratório, sem telefone e sem vínculo com
`auth.users`, NextAuth ou contas Google. Não é a migration posterior de telefone.

Executar futuramente apenas no novo projeto dedicado e como administrador.
Schema `lab` deve permanecer fora dos schemas expostos pela Data API.

```sql
begin;

create schema lab;
revoke all on schema lab from public, anon, authenticated, service_role;

create table lab.users (
  id uuid primary key,
  name text not null check (length(btrim(name)) > 0),
  email text not null unique,
  created_at timestamptz not null default now()
);

revoke all on table lab.users
  from public, anon, authenticated, service_role;
alter table lab.users enable row level security;

insert into lab.users (id, name, email) values
  ('00000000-0000-4000-8000-000000000001',
   'Pessoa Fictícia Um', 'pessoa1@example.invalid'),
  ('00000000-0000-4000-8000-000000000002',
   'Pessoa Fictícia Dois', 'pessoa2@example.invalid');

commit;
```

Política proposta: nenhum acesso via API, inclusive para usuários autenticados.
Sem policies permissivas de RLS. Grants e USAGE revogados explicitamente dos
papéis da API e de PUBLIC. Administradores, o proprietário da tabela e papéis
com BYPASSRLS continuam sendo acessos privilegiados; RLS não os impede por si só.
Não criar funções RPC nem adicionar o schema à lista de exposição da Data API.
O SQL falha se os objetos já existirem, evitando mascarar um estado inesperado.

Fontes:
- https://supabase.com/docs/guides/database/tables
- https://supabase.com/docs/guides/database/postgres/row-level-security
- https://supabase.com/docs/guides/api/securing-your-api
- https://supabase.com/changelog

## Sequência posterior, após revisão e criação inicial

1. Confirmar o identificador do projeto novo e que é o laboratório dedicado.
2. Aplicar a estrutura inicial aprovada e verificar a criação e os privilégios.
3. Consultar via MCP o schema real, colunas, constraints, RLS e grants.
4. Vincular o ticket Jira e só então propor a migration que adiciona telefone.
5. Definir validação automatizada de SQL/schema/permissões; tipos e build do
   aplicativo, isoladamente, não validam o laboratório.

Bloqueios atuais: conexão Atlassian, escolha explícita de organização e
confirmação de gratuidade, revisão do SQL inicial e criação do laboratório.
NextAuth continua sem integração ao banco. Nenhuma migration de telefone,
commit, push ou comunicação com a equipe foi realizada nesta etapa.

## Cotação após aprovação do SQL e escolha da organização

O usuário aprovou o SQL inicial acima e confirmou a organização
`fakejp27-4811's projects` para consultar o novo projeto `requisitaia-lab-dev`.

Ferramenta MCP chamada: `mcp__codex_apps__supabase_get_cost`.
Parâmetros: `organization_id=vercel_icfg_AwthokXFF02HjaIIo9OLGj9B`,
`type=project`.
Retorno real:

```json
{"type":"project","recurrence":"monthly","amount":0}
```

Cotação apresentada: US$ 0 por mês. A descrição de `get_cost` exige apresentar
o custo e confirmar o entendimento do usuário antes de prosseguir. Portanto,
a criação foi interrompida nesse ponto para obter o aceite específico da
cotação. `confirm_cost` e `create_project` não foram chamados; disponibilidade
efetiva de provisionamento ainda não testada. Nenhum projeto existente alterado.

Sem projeto novo, não houve aplicação de SQL, consulta ao schema real ou ao
histórico de migrations. Nenhum arquivo de migration foi criado nesta etapa.

Atlassian: nova busca retornou `installed=false`; acionada novamente a opção
de instalação/conexão pelo fluxo disponível, a pedido do usuário. Essa ação
somente oferece a instalação/conexão e não conclui o OAuth. Ainda não há
ferramentas Jira acessíveis nesta sessão; sites e projetos não foram listados.
O usuário precisa concluir a autorização no navegador antes da leitura do Jira.

## Laboratório criado e estrutura inicial aplicada

O usuário aceitou explicitamente US$ 0/mês. A primeira chamada
`mcp__codex_apps__supabase_create_project`, sem identificador de confirmação,
retornou erro exigindo esse identificador. Foi chamado `supabase_confirm_cost`
com `amount=0`, `recurrence=monthly`, `type=project`, usando o aceite existente;
em seguida, a criação foi repetida com o identificador retornado (não incluído
nesta documentação).

Projeto novo: `requisitaia-lab-dev`, ID `hwoaupfzfkwzzeoxkoop`, região
`sa-east-1`, estado retornado `ACTIVE_HEALTHY`. `supabase_get_project`
confirmou o nome, organização e estado; PostgreSQL retornado: `17.11.0.003`.
Nenhuma cobrança diferente foi informada durante essas chamadas.
Nenhuma operação foi dirigida aos projetos existentes.

Aplicação remota: `mcp__codex_apps__supabase_apply_migration`, com
`project_id=hwoaupfzfkwzzeoxkoop`, `name=initial_lab_users` e o SQL aprovado
acima. Retorno real: `{"success":true}`.

Histórico consultado por `mcp__codex_apps__supabase_list_migrations`:

```json
{"migrations":[{"version":"20261017180900","name":"initial_lab_users"}]}
```

Cópia local do SQL aplicado:
`supabase/migrations/20261017180900_initial_lab_users.sql`.
O nome usa a versão efetivamente retornada pelo histórico remoto; não é um
timestamp presumido. A tentativa `cmd /c npx --yes supabase --help` ficou
pendente sem produzir saída e foi encerrada, somente no processo npx da CLI.
Não foi possível usar `migration new` nesta etapa; foi preservada a migration
remota já existente com sua versão real. Nenhuma dependência foi adicionada
ao package.json e o servidor de desenvolvimento não foi encerrado.

### Consultas reais via MCP após aplicar

Ferramentas: `mcp__codex_apps__supabase_list_tables` com `schemas=["lab"]`
e `verbose=true`; `mcp__codex_apps__supabase_execute_sql` para consultar
`information_schema.columns`, `pg_constraint`, RLS/policies e privilégios.
Parâmetros e retornos integrais dessas leituras foram salvos em
`docs/evidencias/exercicio-2-schema-inicial.json`. Esses retornos são resultados
do banco, distintos do SQL de criação proposto.

| Coluna consultada | Tipo retornado | Aceita NULL | Default |
|---|---|---|---|
| id | uuid | NO | nenhum |
| name | text | NO | nenhum |
| email | text | NO | nenhum |
| created_at | timestamp with time zone | NO | now() |

Restrições retornadas: `users_pkey` PRIMARY KEY (id), `users_email_key`
UNIQUE (email), `users_name_check` CHECK ((length(btrim(name)) > 0)).

RLS: `rls_enabled=true`, `rls_forced=false`, `policy_count=0`.
Linhas fictícias: `fixture_count=2`. Não existe coluna de telefone no retorno.
`has_schema_privilege` e `has_table_privilege` retornaram `false` para USAGE,
SELECT, INSERT, UPDATE e DELETE nos papéis `anon`, `authenticated` e
`service_role`. Administradores continuam privilegiados.

`current_setting('pgrst.db_schemas', true)` retornou `null`: essa consulta
não comprovou a configuração efetiva dos schemas expostos pela Data API.
Não se afirma essa configuração como consultada; a revogação dos privilégios
dos papéis da API foi verificada diretamente no banco.

Próximo bloqueio: conexão Atlassian/Jira. Sem telefone, integração NextAuth,
commit, push, PR ou mensagens à equipe nesta etapa.
