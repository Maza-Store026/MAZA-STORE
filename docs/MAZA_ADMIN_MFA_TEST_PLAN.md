# MAZA Admin MFA rollout test plan

> This checklist is for the `secure-maza-admin-mfa` branch. Do not apply the staged SQL migration to production until the MFA flow passes.

## Before testing
- Use the intended administrator account only.
- Keep a separate working browser/session for the existing production admin until rollout is complete.
- Confirm the storefront `index.html` and production admin on `main` are unchanged.
- Do not paste TOTP secrets, passwords, access tokens, or recovery codes into issues or chat.

## MFA enrollment
- [ ] Sign in with the configured admin email and password when no verified TOTP factor exists.
- [ ] Confirm only the MFA setup panel is visible; orders, interests, products, and categories are hidden.
- [ ] Start enrollment and scan the QR code with an authenticator app.
- [ ] Enter a valid six-digit TOTP code and confirm enrollment succeeds.
- [ ] Confirm the setup panel hides and admin sections load only after the session reaches AAL2.
- [ ] Try an invalid code and confirm enrollment does not complete or reveal admin data.

## MFA sign-in
- [ ] Sign out and sign in again with the admin email/password.
- [ ] Confirm the app asks for a TOTP code before loading admin data.
- [ ] Enter a valid code and confirm orders, interests, products, categories, and media actions load.
- [ ] Enter an invalid code and confirm protected sections stay unavailable.
- [ ] Refresh after successful MFA; confirm the app restores correctly for an AAL2 session.
- [ ] Restore an AAL1 session; confirm it asks for the MFA challenge instead of showing protected sections.
- [ ] Sign in with a non-admin account if one is available; confirm the UI rejects it and signs it out.

## Admin operations after AAL2
- [ ] Read orders and order items.
- [ ] Change an order status and confirm it persists.
- [ ] Read and update product-interest status.
- [ ] Add/edit/delete a test product and verify data persists.
- [ ] Add/edit/delete a test category and verify data persists.
- [ ] Upload up to 12 test images; verify the 13th image is rejected and each image above 15 MB is rejected.
- [ ] Verify public storefront product/category reads and public image URLs still work.
- [ ] Confirm the 12-image limit and product variant stock behavior remain intact.

## Database policy verification
After the migration is reviewed and applied to a test environment:
- [ ] An AAL1 authenticated token cannot read orders/order items/product interests.
- [ ] An AAL1 authenticated token cannot update orders or product interests.
- [ ] An AAL1 authenticated token cannot insert/update/delete products or categories.
- [ ] An AAL1 authenticated token cannot upload/update/delete objects in `maza-media`.
- [ ] An AAL2 session for the configured admin account can perform the intended admin operations.
- [ ] Anonymous storefront customers can still read public products/categories and submit valid orders/restock interests.
- [ ] Re-run Supabase Security Advisors and investigate every finding.

## Rollback readiness
- [ ] Keep the prior policy definitions recorded before applying the migration.
- [ ] Confirm a tested recovery path to restore admin access if the MFA challenge fails.
- [ ] Do not merge or deploy until all applicable checks pass.
