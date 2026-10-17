\set ON_ERROR_STOP on
begin;
set local lock_timeout = '5s';
set local statement_timeout = '30s';
lock table lab.users in access exclusive mode;

-- Dados completos anteriores, incluindo created_at.
create temporary table before_users on commit drop as
select id, name, email, created_at from lab.users;

-- Estado que a migration deve preservar.
create function pg_temp.security_state() returns jsonb
language sql as $fn$
  select jsonb_build_object(
    'table', (
      select jsonb_build_array(
        relrowsecurity, relforcerowsecurity, relowner, relacl::text
      ) from pg_class where oid = 'lab.users'::regclass
    ),
    'schema_acl', (
      select nspacl::text from pg_namespace where nspname = 'lab'
    ),
    'policies', (
      select coalesce(jsonb_agg(to_jsonb(p) order by policyname), '[]')
      from pg_policies p
      where schemaname = 'lab' and tablename = 'users'
    ),
    'constraints', (
      select jsonb_agg(
        jsonb_build_array(conname, pg_get_constraintdef(oid))
        order by conname
      )
      from pg_constraint where conrelid = 'lab.users'::regclass
    )
  );
$fn$;

create temporary table before_security on commit drop as
select pg_temp.security_state() as state;

do $test$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'lab' and table_name = 'users'
      and column_name = 'phone'
  ) then
    raise exception 'Pré-condição: phone já existe';
  end if;
  if (select count(*) from before_users) <> 2 then
    raise exception 'Pré-condição: esperados dois usuários fictícios';
  end if;
end
$test$;

-- Caminho do arquivo real fornecido pelo executor.
\i :migration

do $test$
declare
  r text;
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema = 'lab' and table_name = 'users'
      and column_name = 'phone' and data_type = 'text'
      and is_nullable = 'YES' and column_default is null
      and is_identity = 'NO' and is_generated = 'NEVER'
  ) then
    raise exception 'phone deve ser text opcional, sem default ou geração';
  end if;

  if exists (
    (select id, name, email, created_at from before_users
     except
     select id, name, email, created_at from lab.users)
    union all
    (select id, name, email, created_at from lab.users
     except
     select id, name, email, created_at from before_users)
  ) or exists (select 1 from lab.users where phone is not null) then
    raise exception 'Dados anteriores alterados ou phone não é NULL';
  end if;

  if pg_temp.security_state() is distinct from
     (select state from before_security) then
    raise exception 'RLS, policies, proprietário, ACLs ou constraints alterados';
  end if;

  if exists (
    select 1
    from pg_index i
    join pg_attribute a on a.attrelid = i.indrelid
    where i.indrelid = 'lab.users'::regclass
      and i.indisunique and a.attname = 'phone'
      and a.attnum = any(i.indkey)
  ) then
    raise exception 'phone participa de índice único';
  end if;

  foreach r in array array['anon', 'authenticated', 'service_role']
  loop
    if has_schema_privilege(r, 'lab', 'USAGE')
       or has_table_privilege(
         r, 'lab.users',
         'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER'
       )
       or has_any_column_privilege(
         r, 'lab.users', 'SELECT,INSERT,UPDATE,REFERENCES'
       ) then
      raise exception 'Privilégio inesperado para %', r;
    end if;
  end loop;

  -- Mesmo telefone nos dois registros: duplicidade deve ser permitida.
  update lab.users set phone = '+550012345678';
  if (select count(*) from lab.users
      where phone = '+550012345678') <> 2 then
    raise exception 'Prefixo, zeros ou duplicidade não foram preservados';
  end if;

  -- Inserção sem telefone deve funcionar e resultar em NULL.
  insert into lab.users (id, name, email)
  values (
    '00000000-0000-4000-8000-000000000099',
    'Teste temporário KAN-4', 'kan4@example.invalid'
  );
  if not exists (
    select 1 from lab.users
    where email = 'kan4@example.invalid' and phone is null
  ) then
    raise exception 'Inserção sem telefone não resultou em NULL';
  end if;

  update lab.users set phone = null;
  if exists (select 1 from lab.users where phone is not null) then
    raise exception 'phone não aceitou NULL';
  end if;
end
$test$;

rollback;
