-- MAZA Admin: require Supabase MFA assurance level AAL2 for admin-only reads/writes.
-- IMPORTANT: staged migration only. Review and test the MFA login flow before applying
-- to production; applying it before the admin UI supports MFA can block admin access.
-- Existing permissive policies still enforce the admin email. These RESTRICTIVE policies
-- add AAL2 as a second requirement without weakening existing email checks or public reads.

-- Orders: private customer/order data and status updates.
drop policy if exists "MAZA require AAL2 to read orders" on public.orders;
create policy "MAZA require AAL2 to read orders"
  on public.orders as restrictive for select to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to update orders" on public.orders;
create policy "MAZA require AAL2 to update orders"
  on public.orders as restrictive for update to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2')
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

-- Order line items contain private purchase details.
drop policy if exists "MAZA require AAL2 to read order items" on public.order_items;
create policy "MAZA require AAL2 to read order items"
  on public.order_items as restrictive for select to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');

-- Customers waiting for a product restock.
drop policy if exists "MAZA require AAL2 to read product interests" on public.product_interests;
create policy "MAZA require AAL2 to read product interests"
  on public.product_interests as restrictive for select to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to update product interests" on public.product_interests;
create policy "MAZA require AAL2 to update product interests"
  on public.product_interests as restrictive for update to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2')
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

-- Product writes are admin-only. Public SELECT remains governed by the existing public policy.
drop policy if exists "MAZA require AAL2 to insert products" on public.products;
create policy "MAZA require AAL2 to insert products"
  on public.products as restrictive for insert to authenticated
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to update products" on public.products;
create policy "MAZA require AAL2 to update products"
  on public.products as restrictive for update to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2')
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to delete products" on public.products;
create policy "MAZA require AAL2 to delete products"
  on public.products as restrictive for delete to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');

-- Category writes are admin-only. Public SELECT remains available.
drop policy if exists "MAZA require AAL2 to insert categories" on public.categories;
create policy "MAZA require AAL2 to insert categories"
  on public.categories as restrictive for insert to authenticated
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to update categories" on public.categories;
create policy "MAZA require AAL2 to update categories"
  on public.categories as restrictive for update to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2')
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to delete categories" on public.categories;
create policy "MAZA require AAL2 to delete categories"
  on public.categories as restrictive for delete to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');

-- Media: keep public image delivery unchanged, but require AAL2 for object writes.
drop policy if exists "MAZA require AAL2 to upload media" on storage.objects;
create policy "MAZA require AAL2 to upload media"
  on storage.objects as restrictive for insert to authenticated
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to update media" on storage.objects;
create policy "MAZA require AAL2 to update media"
  on storage.objects as restrictive for update to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2')
  with check ((select auth.jwt() ->> 'aal') = 'aal2');

drop policy if exists "MAZA require AAL2 to delete media" on storage.objects;
create policy "MAZA require AAL2 to delete media"
  on storage.objects as restrictive for delete to authenticated
  using ((select auth.jwt() ->> 'aal') = 'aal2');
