create table if not exists public.user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  consultant_name text default '',
  consultant_level text default 'junior',
  early_bonus integer default 25000,
  productivity_bonus integer default 200000,
  productivity_min integer default 6,
  updated_at timestamptz default now()
);

create table if not exists public.processes (
  user_id uuid not null references auth.users(id) on delete cascade,
  ref_id text not null,
  month_label text,
  search_name text,
  client_name text,
  process_type text,
  invoice_number text,
  invoice_date date,
  search_start_date date,
  salary_amount integer default 0,
  positions integer default 1,
  imported_at timestamptz default now(),
  updated_at timestamptz default now(),
  primary key (user_id, ref_id)
);

create table if not exists public.process_adjustments (
  user_id uuid not null references auth.users(id) on delete cascade,
  ref_id text not null,
  scale_amount integer,
  grid_sent_date date,
  candidate_start_date date,
  is_warranty_process boolean default false,
  pay_closing boolean default true,
  pay_guarantee boolean default true,
  updated_at timestamptz default now(),
  primary key (user_id, ref_id)
);

create table if not exists public.paid_guarantees (
  user_id uuid not null references auth.users(id) on delete cascade,
  ref_id text not null,
  liquidation_month text not null,
  liquidation_date date,
  paid_at timestamptz default now(),
  primary key (user_id, ref_id)
);

create table if not exists public.liquidations (
  user_id uuid not null references auth.users(id) on delete cascade,
  consultant_name text not null,
  month_label text not null,
  liquidation_date date,
  closed_count integer default 0,
  closing_total integer default 0,
  grid_total integer default 0,
  guarantee_total integer default 0,
  bonus_total integer default 0,
  total_amount integer default 0,
  saved_at timestamptz default now(),
  primary key (user_id, consultant_name, month_label)
);

create table if not exists public.import_batches (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  filename text,
  row_count integer default 0,
  imported_at timestamptz default now()
);

alter table public.user_settings enable row level security;
alter table public.processes enable row level security;
alter table public.process_adjustments enable row level security;
alter table public.paid_guarantees enable row level security;
alter table public.liquidations enable row level security;
alter table public.import_batches enable row level security;

create policy "own settings" on public.user_settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own processes" on public.processes
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own process adjustments" on public.process_adjustments
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own paid guarantees" on public.paid_guarantees
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own liquidations" on public.liquidations
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "own import batches" on public.import_batches
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create index if not exists idx_processes_user_month
  on public.processes(user_id, month_label);

create index if not exists idx_paid_guarantees_user
  on public.paid_guarantees(user_id);
