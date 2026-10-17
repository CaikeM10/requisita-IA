-- KAN-4: executar somente após aplicação definitiva. Não reaplica ALTER TABLE.
begin;
set transaction read only;
do $test$
declare r text;
begin
  if not exists (
    select 1 from information_schema.columns
    where table_schema='lab' and table_name='users' and column_name='phone'
      and data_type='text' and is_nullable='YES' and column_default is null
      and is_identity='NO' and is_generated='NEVER'
  ) then raise exception 'Definição de phone inválida'; end if;

  if (select count(*) from lab.users) <> 2 or exists (
    select 1 from lab.users u full join (values
      ('00000000-0000-4000-8000-000000000001'::uuid,
       'Pessoa Fictícia Um', 'pessoa1@example.invalid'),
      ('00000000-0000-4000-8000-000000000002'::uuid,
       'Pessoa Fictícia Dois', 'pessoa2@example.invalid')
    ) e(id,name,email) using(id)
    where u.id is null or e.id is null
      or u.name is distinct from e.name or u.email is distinct from e.email
      or u.created_at is distinct from '2026-10-17 18:09:00.33707+00'::timestamptz
      or u.phone is not null
  ) then raise exception 'Dados originais ou phone NULL não preservados'; end if;

  if not exists (
    select 1 from pg_class where oid='lab.users'::regclass
      and relrowsecurity and not relforcerowsecurity
      and pg_get_userbyid(relowner)='postgres'
      and relacl::text='{postgres=arwdDxtm/postgres}'
  ) or (select nspacl::text from pg_namespace where nspname='lab')
       is distinct from '{postgres=UC/postgres}'
    or exists (select 1 from pg_policies
               where schemaname='lab' and tablename='users')
  then raise exception 'RLS, proprietário, ACLs ou policies alterados'; end if;

  if exists (
    select 1 from pg_index i join pg_attribute a on a.attrelid=i.indrelid
    where i.indrelid='lab.users'::regclass and i.indisunique
      and a.attname='phone' and a.attnum=any(i.indkey)
  ) then raise exception 'Unicidade indevida em phone'; end if;

  if (select jsonb_agg(jsonb_build_object(
        'name',conname,'definition',pg_get_constraintdef(oid)) order by conname)
      from pg_constraint where conrelid='lab.users'::regclass)
     is distinct from '[{"name":"users_email_key","definition":"UNIQUE (email)"},{"name":"users_name_check","definition":"CHECK ((length(btrim(name)) > 0))"},{"name":"users_pkey","definition":"PRIMARY KEY (id)"}]'::jsonb
  then raise exception 'Constraints originais alteradas'; end if;

  foreach r in array array['anon','authenticated','service_role'] loop
    if has_schema_privilege(r,'lab','USAGE')
      or has_table_privilege(r,'lab.users',
        'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER')
      or has_any_column_privilege(r,'lab.users','SELECT,INSERT,UPDATE,REFERENCES')
    then raise exception 'Permissão inesperada: %',r; end if;
  end loop;
end
$test$;
rollback;
