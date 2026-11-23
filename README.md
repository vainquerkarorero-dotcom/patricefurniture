# PATRICE FURNITURE AND DESIGN

A React + TypeScript starter for the Patrice Furniture and Design digital business platform.

## Included in this first build

- Responsive luxury-inspired public website
- English / Kinyarwanda language switch (initial interface translations)
- RWF / USD display switch
- Furniture catalogue with search and category filters
- Interior and exterior service pages
- Project portfolio, custom request entry point and contact page
- Customer sign-in integration foundation
- Admin dashboard foundation
- Supabase schema for profiles, products, orders, quotations, projects, appointments, materials and enquiries

**Important:** This is a working frontend foundation, not a production-ready commerce system. Sample products, prices, portfolio imagery and contact details are placeholders. The contact form is currently a local demo. Checkout, payment processing, registration, file uploads, admin CRUD and live business reports must be connected and tested before accepting real customers or payments.

## Requirements

- Node.js 20+
- npm
- Supabase project

## Run locally

```bash
npm install
cp .env.example .env
npm run dev
```

Open the local URL printed by Vite.

## Configure Supabase

1. Create a Supabase project.
2. Copy the project URL and anon/public key into `.env`.
3. Run `supabase/schema.sql` in Supabase SQL Editor.
4. Configure email authentication and redirect URLs.
5. Review and complete the row-level security policies for each write workflow.
6. Create storage buckets for product images, project photos and customer reference files. Keep private customer files in a private bucket.
7. Assign administrator roles only through a trusted process. Do not allow public users to set their own role.

## Deploy

- Push the project to a private Git repository.
- Import it into Vercel.
- Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` as environment variables.
- Deploy and configure the production URL in Supabase Auth redirect settings.
- Add a custom domain and enable HTTPS.

## Before production

- Replace placeholder prices and imagery with approved company information.
- Add actual phone, email, address and WhatsApp number.
- Complete Kinyarwanda translations and review them with a fluent speaker.
- Implement server-side order and quotation calculations.
- Integrate a verified payment provider.
- Add inventory transaction history and accounting controls.
- Add staff roles and least-privilege policies.
- Test authentication, access control, file uploads, backups and restore procedures.
- Add privacy policy, terms, delivery, returns and warranty information.
