# El Tekniko — Website

Premium aesthetic salon machine supplier website built with Next.js 14, Supabase, Google Calendar API, and Gemini AI.

---

## Features

- Homepage with animated stats, machine grid, testimonials, CTAs
- Product listing with category filter
- Product detail pages with specs, FAQ, quick inquiry form
- 3-step booking form → auto-creates Google Calendar event
- Real-time slot availability from Google Calendar
- AI chatbot (Gemini 1.5 Flash via Google AI Studio)
- Confirmation emails (Resend)
- Lead capture → Supabase database
- WhatsApp floating button
- Admin-ready Supabase tables with RLS

---

## Setup

### 1. Install dependencies
```bash
npm install
```

### 2. Set up environment variables
```bash
cp .env.local.example .env.local
# Fill in all values — see below
```

### 3. Set up Supabase
1. Create a project at supabase.com (choose Singapore region)
2. Go to SQL Editor → paste contents of `supabase-schema.sql` → Run
3. Copy your Project URL and keys to `.env.local`

### 4. Set up Google Calendar API
1. Go to console.cloud.google.com → New project
2. Enable "Google Calendar API"
3. Create a Service Account → download JSON credentials
4. Open your Google Calendar → Settings → Share with service account email → "Make changes to events"
5. Copy your Calendar ID from Calendar Settings → Integrate Calendar
6. Add `GOOGLE_CLIENT_EMAIL`, `GOOGLE_PRIVATE_KEY`, `GOOGLE_CALENDAR_ID` to `.env.local`

### 5. Set up Google AI Studio (Gemini)
1. Go to aistudio.google.com
2. Get API Key
3. Add as `GEMINI_API_KEY` in `.env.local`

### 6. Set up Resend (email)
1. Go to resend.com → create account
2. Add your domain (or use their sandbox for testing)
3. Get API key → add as `RESEND_API_KEY`

### 7. Run locally
```bash
npm run dev
# Open http://localhost:3000
```

---

## Deploy to Vercel

```bash
# 1. Push to GitHub
git init
git add .
git commit -m "initial commit"
git remote add origin https://github.com/YOUR_USERNAME/el-tekniko.git
git push -u origin main

# 2. Go to vercel.com → Import Project → Select repo
# 3. Add all environment variables from .env.local
# 4. Click Deploy
```

Every `git push` after this auto-deploys to production.

---

## Environment Variables

| Variable | Description |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anon/public key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key (server-side only) |
| `GOOGLE_CLIENT_EMAIL` | Service account email |
| `GOOGLE_PRIVATE_KEY` | Service account private key |
| `GOOGLE_CALENDAR_ID` | Google Calendar ID |
| `RESEND_API_KEY` | Resend email API key |
| `SALES_EMAIL` | Email to receive lead notifications |
| `GEMINI_API_KEY` | Google AI Studio API key |
| `NEXT_PUBLIC_WHATSAPP_NUMBER` | WhatsApp number (e.g. 639XXXXXXXXX) |
| `NEXT_PUBLIC_SITE_URL` | Your domain (https://eltekniko.com) |

---

## File Structure

```
src/
├── app/
│   ├── page.tsx              # Homepage
│   ├── layout.tsx            # Root layout + metadata
│   ├── globals.css           # Global styles + design tokens
│   ├── about/page.tsx        # About page
│   ├── contact/page.tsx      # Contact + inquiry form
│   ├── products/
│   │   ├── page.tsx          # Products listing
│   │   └── [slug]/page.tsx   # Product detail
│   └── api/
│       ├── bookings/route.ts # Create booking + Google Calendar event
│       ├── availability/route.ts # Check available slots
│       ├── chat/route.ts     # AI chatbot (Gemini)
│       └── leads/route.ts    # Lead capture
├── components/
│   ├── Navbar.tsx
│   ├── Footer.tsx
│   ├── BookingModal.tsx      # 3-step booking form
│   ├── ChatWidget.tsx        # AI chat bubble
│   └── WhatsAppButton.tsx
└── lib/
    ├── supabase.ts           # Supabase client
    ├── googleCalendar.ts     # Calendar event CRUD
    └── email.ts              # Confirmation emails
```

---

## Customization

- **Colors**: Edit `src/app/globals.css` — change `--gold` to your brand color
- **Phone number**: Replace `+63 9XX XXX XXXX` across components
- **WhatsApp**: Update `NEXT_PUBLIC_WHATSAPP_NUMBER` in `.env.local`
- **Products**: Edit the `PRODUCTS` array in `src/app/products/page.tsx`
- **AI persona**: Edit `SYSTEM_PROMPT` in `src/app/api/chat/route.ts`
- **Machine images**: Replace `<Zap>` placeholder in product cards with `<Image>` from Next.js
