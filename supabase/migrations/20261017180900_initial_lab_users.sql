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

