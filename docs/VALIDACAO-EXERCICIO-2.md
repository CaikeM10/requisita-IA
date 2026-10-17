# KAN-4 — revisão, aplicação e validação

Ticket: https://motasaldanhadefreitasjoaopedro.atlassian.net/browse/KAN-4

## Revisão humana

Em 17/10/2026, o usuário aprovou o SQL e o teste propostos. Posteriormente
dispensou expressamente o ensaio prévio de DDL com rollback e autorizou a
aplicação definitiva somente em requisitaia-lab-dev pelo MCP apply_migration.
Não autorizou commit, push, PR, atualização do Jira ou mensagens nesta etapa.

## Ensaio prévio — não executado

psql e CLI Supabase não foram encontrados no PATH. As variáveis PGHOST,
PGPORT, PGDATABASE, PGUSER, PGPASSWORD, PGSERVICE, PGSERVICEFILE, DATABASE_URL
e SUPABASE_DB_URL e o arquivo pgpass.conf não estavam configurados nos locais
verificados. Nenhuma ferramenta foi instalada ou credencial solicitada.
O arquivo supabase/tests/user_phone.sql permanece apenas preparado, não executado.
Ele contém ALTER TABLE e não deve ser usado no banco já migrado.

O ensaio não ocorreu por indisponibilidade da conexão local; depois foi
dispensado pelo usuário. Não foi registrada migration de teste.

## Referência anterior à aplicação — consultas executadas

Projeto confirmado por supabase_get_project: hwoaupfzfkwzzeoxkoop,
requisitaia-lab-dev, sa-east-1, ACTIVE_HEALTHY.
KAN-4 relido via getJiraIssue sem atualização.
supabase_list_migrations retornou somente 20261017180900_initial_lab_users.

supabase_execute_sql consultou e registrou os dois registros completos
(incluindo created_at), todas as colunas, constraints, RLS, proprietário,
ACLs de tabela/schema, policies e permissões efetivas de anon, authenticated
e service_role. phone não existia e não houve divergências.

Consultas e respostas reais: docs/evidencias/exercicio-2-kan4-antes.json.
Essa evidência foi gravada antes da chamada de aplicação.

## Aplicação definitiva — executada

Ferramenta: supabase_apply_migration.
Projeto: hwoaupfzfkwzzeoxkoop. Nome: add_user_phone.
O parâmetro query foi carregado diretamente do arquivo local aprovado:

```sql
-- KAN-4: telefone opcional dos usuários fictícios do laboratório.
alter table lab.users add column phone text;
```

Resposta real: {"success":true}.
Nenhum outro SQL foi aplicado como migration nesta etapa.

Nova consulta supabase_list_migrations retornou:
- 20261017180900 / initial_lab_users
- 20261017184706 / add_user_phone

O arquivo provisório 20261017184316_add_user_phone.sql foi renomeado para
supabase/migrations/20261017184706_add_user_phone.sql, sem alterar o conteúdo
nem reaplicar a migration. A migration inicial foi preservada.
A CLI não foi instalada nem utilizada.

## Validação posterior — executada e aprovada

Arquivo reutilizável: supabase/tests/user_phone_final.sql.
Seu conteúdo foi lido do disco e enviado integralmente a supabase_execute_sql:
BEGIN, SET TRANSACTION READ ONLY, bloco DO com RAISE EXCEPTION e ROLLBACK.
Sem comandos exclusivos do psql, sem ALTER TABLE e sem INSERT/UPDATE.
A ausência de exceção significa aprovação; qualquer divergência gera erro.
Resposta real: isError=false, result contendo [] (o bloco não retorna linhas).

Asserções executadas:
- phone text, nullable, sem default, identidade ou geração;
- ausência de índice único com phone como coluna;
- exatamente os dois registros anteriores, com id/name/email/created_at
  preservados e phone NULL;
- constraints originais comparadas por nome e definição;
- RLS ativa e não forçada, proprietário postgres, ACLs preservadas, zero policies;
- anon/authenticated/service_role continuam sem USAGE e sem privilégios
  de tabela ou coluna.

Nova consulta do snapshot via MCP e comparação automática antes/depois:
constraints=true, table=true, schema_acl=true, policies=true,
permissions=true, rows=true, oldColumns=true.
Os dados completos foram comparados removendo somente a nova chave phone.
O histórico remoto foi confirmado com exatamente as duas migrations acima.

Consultas, SQL efetivamente aplicado, teste efetivamente executado, respostas
reais e resultados da comparação: docs/evidencias/exercicio-2-kan4-depois.json.

## Testes de escrita — não executados

O contrato de execute_sql não garante explicitamente o tratamento transacional
necessário para ensaios INSERT/UPDATE com rollback. Conforme a instrução do
usuário, essas escritas não foram executadas. Não há alegação de teste funcional
de prefixos, zeros ou duplicidade por escrita. A definição text e a ausência
de unicidade foram verificadas por metadados. Nenhum dado de teste persistido.

## Check do aplicativo — executado e aprovado

Comando real: npm.cmd run check.
Executado com a permissão de execução necessária após a restrição local
anteriormente observada (EPERM de Node no diretório do usuário).
Código de saída 0: next typegen, tsc --noEmit e next build passaram.
Nenhuma dependência instalada. Build não substitui a validação SQL executada.

## Escopo encerrado nesta etapa

Aplicação e validação posterior concluídas. Sem commit, push, PR, atualização
do Jira ou mensagens. NextAuth continua sem integração ao laboratório.
