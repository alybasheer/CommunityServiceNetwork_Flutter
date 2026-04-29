# CERD — Developer Overview
## Community Emergency Response & Disaster Support App
**Stack:** NestJS · MongoDB (Mongoose) · Flutter · Firebase · Socket.io  
**Version:** 1.0 | April 2026  
**Audience:** New/Onboarding Developers

---

## 🧭 What Is CERD?

**CERD** is a mobile-first emergency response platform that connects **people in crisis** with **nearby verified volunteers** in real time.

When a disaster, medical emergency, road accident, or any community crisis happens, users can post a **Help Request** from their phone. The system immediately notifies verified volunteers in the area via push notification. A volunteer accepts the request, a private chat opens between them, and the situation is tracked until resolved.

The platform also allows verified volunteers to **broadcast precaution alerts** (floods, fire, road blockages) to everyone in a geographic radius, and to form **community groups** for coordinated preparedness.

---

## 👥 Who Uses This App?

| Actor | Description | Key Capabilities |
|-------|-------------|-----------------|
| **Help Seeker** | Anyone in need of emergency help | Post help requests, trigger SOS, chat with responder, view nearby alerts |
| **Volunteer** | Verified community responder | Accept requests, broadcast alerts, create community groups, share live location |
| **Admin** | Platform moderator/operator | Verify volunteers, moderate requests, view analytics dashboard, manage users |

---

## 🗺️ High-Level Application Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        FLUTTER CLIENT (Mobile App)              │
│                                                                 │
│  ┌──────────┐   ┌──────────────┐   ┌──────────┐  ┌─────────┐  │
│  │  Auth    │   │  Help Request│   │   Chat   │  │  Map /  │  │
│  │  Screen  │   │  Screen      │   │  Screen  │  │ Alerts  │  │
│  └────┬─────┘   └──────┬───────┘   └────┬─────┘  └────┬────┘  │
└───────┼────────────────┼────────────────┼──────────────┼───────┘
        │  HTTPS REST    │  HTTPS REST    │  WebSocket   │ HTTPS
        ▼                ▼                ▼              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      NestJS API SERVER                          │
│                                                                 │
│  ┌──────────┐  ┌─────────────┐  ┌──────────┐  ┌────────────┐  │
│  │   Auth   │  │HelpRequests │  │   Chat   │  │  Alerts /  │  │
│  │  Module  │  │   Module    │  │  Module  │  │ Community  │  │
│  └──────────┘  └─────────────┘  └──────────┘  └────────────┘  │
│  ┌──────────┐  ┌─────────────┐  ┌──────────┐  ┌────────────┐  │
│  │  Users   │  │ Volunteers  │  │  Admin   │  │  Firebase  │  │
│  │  Module  │  │   Module    │  │  Module  │  │  Module    │  │
│  └──────────┘  └─────────────┘  └──────────┘  └────────────┘  │
│                                                                 │
│  ─── Global Pipeline: Guards → Interceptors → Pipes → Filter ──│
└────────────────────────┬────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
  ┌──────────┐    ┌──────────┐    ┌──────────────┐
  │ MongoDB  │    │ Firebase │    │  Cloudinary  │
  │  Atlas   │    │   FCM    │    │ (Media files)│
  └──────────┘    └──────────┘    └──────────────┘
```

---

## 🔄 Core Feature Flows

### Flow 1 — User Registration & Login

```
User opens app
      │
      ▼
POST /auth/signup
  ─ Validates SignupDto (email, password, username)
  ─ Hashes password (bcrypt)
  ─ Saves User doc (role: 'help_seeker' by default)
  ─ Returns JWT token
      │
      ▼
      OR
      │
POST /auth/login
  ─ Validates LoginDto
  ─ Checks failed attempts / lockout
  ─ Verifies password hash
  ─ Returns JWT token
      │
      ▼
All subsequent requests include:
  Authorization: Bearer <jwt>
  → JwtAuthGuard decodes & attaches user to request
```

---

### Flow 2 — Posting a Help Request (Core Feature)

```
Help Seeker opens app
        │
        ▼
Fills in: category, description, urgency, location (GPS)
        │
        ▼
POST /help-requests
  ─ JwtAuthGuard verifies token
  ─ ValidationPipe validates CreateHelpRequestDto
  ─ HelpRequestsService.createRequest()
        │
        ├── Saves HelpRequest to MongoDB
        │     location stored as GeoJSON { type:'Point', coordinates:[lng,lat] }
        │     status: 'open' | TTL index auto-expires after 24 hours
        │
        └── (async) Notifies nearby volunteers
              ─ Queries users WHERE role='volunteer' AND isVerifiedVolunteer=true
                AND location within 10km radius ($near geospatial query)
              ─ Collects FCM tokens
              ─ Firebase.sendMulticast() → push notification to volunteers' phones
        │
        ▼
Volunteer receives push notification on their phone
```

---

### Flow 3 — Volunteer Accepts a Request

```
Volunteer sees request on map or notification
        │
        ▼
PATCH /help-requests/:id/accept
  ─ JwtAuthGuard (must be volunteer role)
  ─ Sets responderId = volunteer's userId
  ─ Sets status = 'in_progress'
  ─ Notifies help seeker via FCM ("Your request was accepted")
        │
        ▼
Chat becomes available
  ─ WebSocket connection to ChatGateway
  ─ Messages tied to requestId (enforced in schema)
  ─ Only works while request status = 'in_progress'
        │
        ▼
PATCH /help-requests/:id/resolve
  ─ Sets status = 'resolved'
  ─ Sets resolvedAt timestamp
  ─ Chat is closed
```

---

### Flow 4 — Volunteer Application & Admin Approval

```
Logged-in user (help_seeker role)
        │
        ▼
POST /volunteers/apply
  ─ Submits: CNIC, expertise, reason, document uploads (Cloudinary URLs)
  ─ Creates VolunteerApplication (status: 'pending')
        │
        ▼
Admin Dashboard
        │
GET /admin/volunteer-applications?status=pending
  ─ RolesGuard enforces role: 'admin'
        │
        ▼
PATCH /admin/volunteer-applications/:id/approve  OR  /reject
  ─ Sets application.status = 'approved' / 'rejected'
  ─ If approved: sets user.isVerifiedVolunteer = true, user.role = 'volunteer'
  ─ Notifies user via FCM
```

---

### Flow 5 — SOS Alert

```
User presses SOS button
        │
        ▼
POST /help-requests  { isSOS: true, urgency: 'critical' }
  ─ Same flow as Flow 2 but:
    ─ FCM notification title: "🚨 SOS ALERT"
    ─ Sorted to top of volunteer dashboard (isSOS: -1 index)
    ─ Visible on map with SOS marker
```

---

### Flow 6 — Precaution Alert Broadcast

```
Verified Volunteer
        │
        ▼
POST /alerts
  { alertType: 'flood', message: '...', latitude, longitude, radiusMeters: 5000 }
  ─ JwtAuthGuard + RolesGuard (role: volunteer)
  ─ Saves PrecautionAlert to MongoDB with GeoJSON location
  ─ Queries all users within radiusMeters ($geoWithin)
  ─ Sends FCM broadcast to all users in affected area
        │
        ▼
All users in radius see alert on their map / receive push notification
```

---

### Flow 7 — Real-Time Chat (WebSocket)

```
After request is accepted (status: in_progress)
        │
        ▼
Flutter client connects:
  ws://api.cerd.app/chat?token=<jwt>
        │
        ▼
ChatGateway.handleConnection()
  ─ Verifies JWT on connect
  ─ Adds user to connectedUsers map (userId → socketId)
        │
        ▼
Client emits: { event: 'send_message', data: { requestId, content } }
        │
        ▼
ChatGateway.handleSendMessage()
  ─ Validates: request exists AND status === 'in_progress'
  ─ Saves Message to MongoDB
  ─ Emits message back to receiverId's socket
        │
        ▼
Other party receives message in real time
```

---

## 🏗️ Module Architecture

```
src/
├── main.ts                    ← Bootstrap, global middleware
├── app.module.ts              ← Root module, imports all below
│
├── common/                    ← Shared utilities (no business logic)
│   ├── guards/
│   │   ├── jwt-auth.guard.ts  ← Verifies JWT on every protected route
│   │   └── roles.guard.ts     ← Checks user.role against @Roles() decorator
│   ├── interceptors/
│   │   ├── logging.interceptor.ts        ← Logs METHOD /path — Xms
│   │   └── response-transform.interceptor.ts ← Wraps all responses: { success, data, statusCode }
│   ├── filters/
│   │   └── global-exception.filter.ts   ← Catches ALL errors, returns clean JSON
│   └── decorators/
│       ├── current-user.decorator.ts    ← @CurrentUser() pulls user from request
│       └── roles.decorator.ts           ← @Roles('admin') metadata setter
│
├── config/                    ← All .env reading goes here
│   ├── app.config.ts
│   ├── database.config.ts
│   └── jwt.config.ts
│
├── auth/                      ← Signup, Login, JWT strategy, Google OAuth
├── users/                     ← Profile, location update, user queries
├── help-requests/             ← CORE: Create, accept, resolve, nearby map query
├── volunteers/                ← Application submit, document upload
├── admin/                     ← Dashboard, analytics, moderation
├── chat/                      ← WebSocket gateway + message history REST
├── alerts/                    ← Precaution alert create & broadcast
├── community/                 ← Volunteer group create, join, leave
└── firebase/                  ← FCM push notifications + Google token verify
```

---

## 🗄️ Database Collections Overview

| Collection | Purpose | Key Fields |
|-----------|---------|-----------|
| `users` | All platform users | `role`, `isVerifiedVolunteer`, `location (GeoJSON)`, `fcmToken` |
| `help_requests` | Emergency requests | `seekerId`, `responderId`, `status`, `location (GeoJSON)`, `isSOS`, TTL 24h |
| `volunteer_applications` | Verification applications | `userId`, `cnic`, `documentUrls`, `status` |
| `messages` | Chat messages | `requestId` (enforced), `senderId`, `receiverId`, `content` |
| `precaution_alerts` | Area safety alerts | `location (GeoJSON)`, `radiusMeters`, `alertType`, `isActive` |
| `community_groups` | Volunteer coordination groups | `createdBy`, `members[]`, `maxMembers` |

> **All location fields use GeoJSON Point format** with `2dsphere` indexes for geospatial queries (nearby requests, alert radius, volunteer dispatch).

---

## 🔐 Authentication & Authorization Summary

```
Every request flows through:

  HTTP Request
      │
      ▼
  [JwtAuthGuard]         → Verifies Bearer token → attaches user to req
      │
      ▼
  [RolesGuard]           → Checks @Roles() decorator if present
      │
      ▼
  [ValidationPipe]       → Validates & transforms DTO body
      │
      ▼
  Controller Method
      │
      ▼
  [ResponseTransformInterceptor]  → Wraps response: { success, data, statusCode }
      │ (on error)
      ▼
  [GlobalExceptionFilter]  → Returns clean error JSON, never a raw stack trace
```

**Role hierarchy:**
```
help_seeker  →  Can post requests, chat, view map
volunteer    →  All above + accept requests, broadcast alerts, create groups
admin        →  All above + manage users, verify volunteers, view analytics
```

---

## 🔔 Push Notification Triggers

| Event | Recipients | FCM Payload |
|-------|-----------|-------------|
| New help request posted | Nearby verified volunteers (≤10km) | Request category + description |
| SOS triggered | Nearby verified volunteers (≤10km) | 🚨 SOS ALERT |
| Request accepted | Help seeker | Volunteer name + ETA |
| Request resolved | Both parties | Resolved confirmation |
| Volunteer application approved/rejected | Applicant | Status + reason |
| Precaution alert issued | All users in radius | Alert type + message |

---

## 🚀 Quick-Start for New Developers

### 1. Clone & Install
```bash
git clone <repo-url>
cd cerd-backend
npm install
```

### 2. Set Up Environment
```bash
cp .env.example .env
# Fill in: MONGODB_URL, JWT_SECRET, FIREBASE_*, CLOUDINARY_*
```

### 3. Seed Admin User
```bash
npm run seed:admin
# Creates admin@cerd.app with role: 'admin' (password in .env)
```

### 4. Run Development Server
```bash
npm run start:dev
# Server starts on http://localhost:3000
# Swagger docs at http://localhost:3000/api
```

### 5. Verify Setup
```bash
curl -X POST http://localhost:3000/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"username":"test","email":"test@test.com","password":"Test1234!"}'
# Should return: { "success": true, "data": { "token": "..." } }
```

---

## 📋 Sprint Roadmap at a Glance

| Sprint | Focus | Duration |
|--------|-------|---------|
| **Sprint 1** | Foundation, security fixes, global pipeline | Week 1–2 |
| **Sprint 2** | Help Requests module — full rewrite with DB + geo | Week 3–4 |
| **Sprint 3** | Auth hardening, DTOs, profile management | Week 5 |
| **Sprint 4** | Chat refactor — requestId enforcement + Redis adapter | Week 6 |
| **Sprint 5** | Admin dashboard, Alerts, Community modules | Week 7–8 |
| **Sprint 6** | Load testing, index verification, E2E tests | Week 9–10 |

> **Start with Sprint 1** — the security and foundation issues must be resolved before any feature work is reliable.

---

## ⚠️ Critical Issues to Fix First

Before adding any new features, these **must** be addressed (full details in `CERD_Backend_Architecture_Brief.md`):

1. **`HelpsService`** — Replace in-memory array with MongoDB `HelpRequest` schema
2. **`UserService`** — Connect to real `users` MongoDB collection
3. **Hardcoded admin credentials** — Remove from code; seed as DB document
4. **JWT verified inside controller** — Move to `JwtAuthGuard` (Passport)
5. **No guards on admin routes** — Apply `@UseGuards(JwtAuthGuard, RolesGuard)`
6. **CORS wildcard + credentials** — Use env-driven origin whitelist
7. **Chat not tied to requests** — Add `requestId` to `Message` schema

---

*For full schema definitions, guard implementations, interceptor code, and DTO examples — refer to `CERD_Backend_Architecture_Brief.md`.*
