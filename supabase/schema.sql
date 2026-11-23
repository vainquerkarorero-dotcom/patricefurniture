-- PATRICE FURNITURE AND DESIGN
-- Apply in Supabase SQL Editor. Review RLS policies and business rules before production.
create extension if not exists pgcrypto;

create type public.app_role as enum ('customer','staff','designer','admin');
create type public.record_status as enum ('draft','pending','approved','in_progress','completed','cancelled');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  phone text,
  role public.app_role not null default 'customer',
  preferred_language text not null default 'en' check (preferred_language in ('en','rw')),
  preferred_currency text not null default 'RWF' check (preferred_currency in ('RWF','USD')),
  created_at timestamptz not null default now()
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  slug text not null unique,
  description text,
  created_at timestamptz not null default now()
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  name text not null,
  slug text not null unique,
  description text,
  material text,
  price_rwf numeric(14,2),
  price_usd numeric(14,2),
  stock_quantity integer not null default 0 check (stock_quantity >= 0),
  is_customizable boolean not null default false,
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.product_images (
  id uuid primary key default gen_random_uuid(),
  product_id uuid not null references public.products(id) on delete cascade,
  storage_path text not null,
  alt_text text,
  sort_order integer not null default 0
);

create table public.orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id),
  order_number bigint generated always as identity unique,
  currency text not null check (currency in ('RWF','USD')),
  subtotal numeric(14,2) not null default 0,
  delivery_fee numeric(14,2) not null default 0,
  total numeric(14,2) not null default 0,
  status public.record_status not null default 'pending',
  delivery_address text,
  notes text,
  created_at timestamptz not null default now()
);

create table public.order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  product_id uuid references public.products(id) on delete set null,
  product_name_snapshot text not null,
  quantity integer not null check (quantity > 0),
  unit_price numeric(14,2) not null,
  line_total numeric(14,2) not null
);

create table public.quotations (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.profiles(id),
  title text not null,
  description text,
  currency text not null check (currency in ('RWF','USD')),
  estimated_total numeric(14,2),
  status public.record_status not null default 'pending',
  valid_until date,
  created_at timestamptz not null default now()
);

create table public.custom_requests (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.profiles(id),
  category text not null,
  material text,
  width_cm numeric(8,2),
  height_cm numeric(8,2),
  depth_cm numeric(8,2),
  finish text,
  quantity integer not null default 1,
  description text,
  reference_file_path text,
  status public.record_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  category text not null,
  description text,
  location text,
  published boolean not null default false,
  completed_at date,
  created_at timestamptz not null default now()
);

create table public.appointments (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references public.profiles(id),
  customer_name text not null,
  contact text not null,
  appointment_at timestamptz not null,
  service_type text not null,
  message text,
  status public.record_status not null default 'pending',
  created_at timestamptz not null default now()
);

create table public.materials (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  unit text not null default 'piece',
  quantity_on_hand numeric(14,2) not null default 0,
  reorder_level numeric(14,2) not null default 0,
  unit_cost_rwf numeric(14,2),
  unit_cost_usd numeric(14,2),
  updated_at timestamptz not null default now()
);

create table public.enquiries (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null,
  contact text not null,
  subject text,
  message text not null,
  status public.record_status not null default 'pending',
  created_at timestamptz not null default now()
);

-- Create a profile automatically when a user signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'full_name',''));
  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- Role lookup must be controlled by trusted profile records.
create or replace function public.current_app_role()
returns public.app_role language sql stable security definer set search_path = public
as $$
  select role from public.profiles where id = auth.uid()
$$;

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.product_images enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.quotations enable row level security;
alter table public.custom_requests enable row level security;
alter table public.projects enable row level security;
alter table public.appointments enable row level security;
alter table public.materials enable row level security;
alter table public.enquiries enable row level security;

create policy "profiles read own or staff" on public.profiles for select
using (id = auth.uid() or public.current_app_role() in ('staff','designer','admin'));
create policy "profiles update own" on public.profiles for update
using (id = auth.uid()) with check (id = auth.uid());
create policy "public read categories" on public.categories for select using (true);
create policy "public read published products" on public.products for select using (published or public.current_app_role() in ('staff','designer','admin'));
create policy "public read product images" on public.product_images for select using (true);
create policy "public read published projects" on public.projects for select using (published or public.current_app_role() in ('staff','designer','admin'));
create policy "customer read own orders" on public.orders for select using (customer_id = auth.uid() or public.current_app_role() in ('staff','admin'));
create policy "customer read own order items" on public.order_items for select using (
  exists(select 1 from public.orders o where o.id = order_id and (o.customer_id = auth.uid() or public.current_app_role() in ('staff','admin')))
);
create policy "customer read own quotations" on public.quotations for select using (customer_id = auth.uid() or public.current_app_role() in ('staff','admin'));
create policy "customer read own custom requests" on public.custom_requests for select using (customer_id = auth.uid() or public.current_app_role() in ('staff','designer','admin'));
create policy "customer read own appointments" on public.appointments for select using (customer_id = auth.uid() or public.current_app_role() in ('staff','designer','admin'));
create policy "staff read materials" on public.materials for select using (public.current_app_role() in ('staff','admin'));
create policy "staff manage enquiries" on public.enquiries for select using (public.current_app_role() in ('staff','admin'));

-- IMPORTANT:
-- Add narrowly scoped INSERT/UPDATE/DELETE policies for each workflow before launch.
-- Never expose the Supabase service-role key in browser code.
-- Assign the first admin role manually through a trusted SQL/admin process.
