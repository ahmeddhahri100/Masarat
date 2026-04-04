-- ============================================
-- Clerk + Supabase RLS Policies
-- ============================================
-- This script sets up Row Level Security policies
-- for tables to work with Clerk authentication.
--
-- Clerk JWT tokens include the user ID in the 'sub' claim.
-- Supabase can access this via auth.jwt()->>'sub'
--
-- Run these queries in your Supabase SQL Editor.
-- ============================================

-- ============================================
-- 1. PROFILES TABLE
-- ============================================

-- Enable RLS on profiles
alter table "public"."profiles" enable row level security;

-- Users can view their own profile
create policy "Users can view own profile"
on "public"."profiles"
for select
to authenticated
using (
  (select auth.jwt()->>'sub') = (id)::text
);

-- Users can insert their own profile (on signup)
create policy "Users can insert own profile"
on "public"."profiles"
for insert
to authenticated
with check (
  (select auth.jwt()->>'sub') = (id)::text
);

-- Users can update their own profile
create policy "Users can update own profile"
on "public"."profiles"
for update
to authenticated
using (
  (select auth.jwt()->>'sub') = (id)::text
);

-- ============================================
-- 2. TRIPS TABLE
-- ============================================

-- Add user_id column if it doesn't exist
-- This column stores the Clerk user ID
alter table "public"."trips"
  add column if not exists user_id text not null default auth.jwt()->>'sub';

-- Enable RLS on trips
alter table "public"."trips" enable row level security;

-- Everyone can view trips (public listing)
create policy "Anyone can view trips"
on "public"."trips"
for select
to authenticated
using (true);

-- Users can only insert their own trips
create policy "Users can insert own trips"
on "public"."trips"
for insert
to authenticated
with check (
  (select auth.jwt()->>'sub') = (user_id)::text
);

-- Users can only update their own trips
create policy "Users can update own trips"
on "public"."trips"
for update
to authenticated
using (
  (select auth.jwt()->>'sub') = (user_id)::text
);

-- Users can only delete their own trips
create policy "Users can delete own trips"
on "public"."trips"
for delete
to authenticated
using (
  (select auth.jwt()->>'sub') = (user_id)::text
);

-- ============================================
-- 3. MESSAGES TABLE
-- ============================================

-- Add user_id column if it doesn't exist
alter table "public"."messages"
  add column if not exists user_id text not null default auth.jwt()->>'sub';

-- Enable RLS on messages
alter table "public"."messages" enable row level security;

-- Users can view messages where they are sender or receiver
create policy "Users can view own messages"
on "public"."messages"
for select
to authenticated
using (
  (select auth.jwt()->>'sub') = (sender_id)::text
  or
  (select auth.jwt()->>'sub') = (receiver_id)::text
);

-- Users can only send messages as themselves
create policy "Users can insert own messages"
on "public"."messages"
for insert
to authenticated
with check (
  (select auth.jwt()->>'sub') = (sender_id)::text
);

-- ============================================
-- 4. SUPABASE CONFIGURATION
-- ============================================
-- You must also configure Supabase to accept Clerk JWT tokens:
--
-- 1. In Clerk Dashboard, go to:
--    https://dashboard.clerk.com/setup/supabase
-- 2. Activate the Supabase integration
-- 3. Copy the Clerk domain
-- 4. In Supabase Dashboard, go to:
--    Authentication > Sign In / Up > Third Party Providers
-- 5. Add "Clerk" as a provider and paste the Clerk domain
--
-- This allows Supabase to validate Clerk-signed JWT tokens.
