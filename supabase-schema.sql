-- El Tekniko · Supabase Schema
-- Run this in your Supabase SQL Editor

-- Products
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text unique not null,
  category text,
  tagline text,
  description text,
  long_desc text,
  specs jsonb default '{}',
  images text[] default '{}',
  treatments text[] default '{}',
  price_range text,
  badge text,
  is_featured boolean default false,
  created_at timestamptz default now()
);

-- Leads (all inquiries and form submissions)
create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  email text,
  phone text,
  clinic_name text,
  machine_interest text,
  budget text,
  status text default 'new' check (status in ('new', 'contacted', 'demo_booked', 'negotiating', 'closed_won', 'closed_lost')),
  source text,
  notes text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Bookings (linked to Google Calendar)
create table if not exists bookings (
  id uuid primary key default gen_random_uuid(),
  client_name text not null,
  email text,
  phone text,
  clinic_name text,
  machine_interest text,
  demo_type text default 'In-person',
  demo_datetime timestamptz,
  notes text,
  gcal_event_id text,
  meet_link text,
  status text default 'confirmed' check (status in ('confirmed', 'rescheduled', 'cancelled', 'completed', 'no_show')),
  created_at timestamptz default now()
);

-- Chat sessions
create table if not exists chat_sessions (
  id uuid primary key default gen_random_uuid(),
  session_id text unique not null,
  messages jsonb default '[]',
  resolved boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Call logs (AI call agent)
create table if not exists call_logs (
  id uuid primary key default gen_random_uuid(),
  phone text,
  transcript text,
  intent text,
  duration_seconds int,
  caller_name text,
  machine_interest text,
  created_at timestamptz default now()
);

-- Enable Row Level Security (RLS)
alter table leads enable row level security;
alter table bookings enable row level security;
alter table chat_sessions enable row level security;
alter table call_logs enable row level security;
alter table products enable row level security;

-- Products: public read
create policy "Products are publicly readable" on products for select using (true);

-- Leads/Bookings: only service role can read/write (no public access)
create policy "Service role full access - leads" on leads using (auth.role() = 'service_role');
create policy "Service role full access - bookings" on bookings using (auth.role() = 'service_role');
create policy "Service role full access - chat" on chat_sessions using (auth.role() = 'service_role');
create policy "Service role full access - calls" on call_logs using (auth.role() = 'service_role');

-- Helpful indexes
create index if not exists idx_leads_status on leads(status);
create index if not exists idx_leads_created on leads(created_at desc);
create index if not exists idx_bookings_datetime on bookings(demo_datetime);
create index if not exists idx_bookings_status on bookings(status);
create index if not exists idx_products_slug on products(slug);

-- Trigger: auto-update updated_at on leads
create or replace function update_updated_at()
returns trigger as $$
begin new.updated_at = now(); return new; end;
$$ language plpgsql;

create trigger leads_updated_at before update on leads
  for each row execute function update_updated_at();
