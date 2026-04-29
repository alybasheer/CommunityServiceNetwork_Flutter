# CERD — Lead Architect Technical Brief
## Backend Architecture Review & Implementation Plan
**Project:** Community Emergency Response & Disaster Support App (CERD)  
**Stack:** NestJS · MongoDB (Mongoose) · Flutter Client  
**Prepared for:** Senior Developer Handoff  
**Version:** 1.0 | April 2026

---

## 1. CODE AUDIT — Findings & Required Refactors

### 1.1 Critical Issues (Must Fix Before Next Iteration)

#### ❌ `HelpsService` — In-Memory Mock Data (No Database)
**File:** `src/helps/helps.service.ts`  
**Problem:** The entire Help Request system — the core feature of the app — stores data in a plain TypeScript array. Every server restart wipes all requests. There is no MongoDB schema, no persistence, no geolocation, no status tracking.  
**Fix:** Replace completely with a `HelpRequest` Mongoose schema and repository pattern (see Section 2).

#### ❌ `UserService` — In-Memory Mock Data
**File:** `src/user/user.service.ts`  
**Problem:** Hardcoded array of 3 users. Completely disconnected from the real `Signup` collection in MongoDB.  
**Fix:** Inject `@InjectModel('Signup')` and delegate all queries to the database.

#### ❌ `HelpsController.getAllHelps()` — Returns Service Instance, Not Data
**File:** `src/helps/helps.controller.ts`  
**Problem:** `return this.helpServices` returns the entire service class object, not the data. This is a JavaScript reference leak.  
**Fix:**
```typescript
// WRONG
return this.helpServices;

// CORRECT
return this.helpServices.getAllHelps();
```

#### ❌ Admin Credentials Hard-Coded in Application Code
**File:** `src/authentication/authentication.service.ts`  
**Problem:** Admin email/password are stored as fallback constants (`'admin@example.com'`, `'adminpass123'`). If the `.env` file is absent in any environment, hardcoded credentials become active. This is a critical security vulnerability.  
**Fix:** Remove the admin shortcut from `AuthenticationService` entirely. Admin users should be a seeded MongoDB document with a `role: 'admin'` field, authenticated through the same flow as all other users.

#### ❌ JWT Verification Inside Controller
**File:** `src/authentication/authentication.controller.ts` — `updateLocation()`  
**Problem:** A fresh `new JwtService({})` is instantiated inside a controller method to verify a token. This bypasses NestJS's DI system, ignores the configured secret from `JwtModule`, and duplicates auth logic that belongs in a Guard.  
**Fix:** Create a global `JwtAuthGuard` and use `@Req()` with the decoded user from the guard's context. Delete the manual `jwtService.verify()` call from the controller.

#### ❌ No Route-Level Authorization Guards
**File:** `src/admin/admin.controller.ts`, `src/volunteer/volunteer.controller.ts`  
**Problem:** Admin endpoints (approve/reject volunteer) have no guards. Any authenticated or even unauthenticated user can call them.  
**Fix:** Apply `@UseGuards(JwtAuthGuard, RolesGuard)` with `@Roles('admin')` on all admin routes.

#### ❌ `CORS` Set to `origin: '*'` with `credentials: true`
**File:** `src/main.ts`  
**Problem:** `Access-Control-Allow-Origin: *` combined with `credentials: true` is rejected by all browsers (CORS spec violation) and is also a security risk in production.  
**Fix:** Use an environment-driven whitelist:
```typescript
origin: process.env.ALLOWED_ORIGINS?.split(',') ?? ['http://localhost:3000'],
credentials: true,
```

#### ❌ Chat is Open — No Request Context Enforcement
**File:** `src/chat/chat.service.ts`, `chat.gateway.ts`  
**Problem:** The SRS explicitly requires chat to be "lightweight, text-only, and only allowed for In-Progress requests." The current chat is a general-purpose open messaging system with no link to a `HelpRequest`. Any two users can chat about anything.  
**Fix:** Add `requestId` to the `Message` schema. Validate in `handleSendMessage` that the referenced request exists and is `in-progress`.

#### ❌ `Signup` Schema Name Collision
**File:** `src/authentication/signup.schema.ts`  
**Problem:** The Mongoose model is registered as `'Signup'` which creates a collection named `signups`. The `chat.service.ts` aggregate pipeline references `from: 'signups'` — this works, but naming the model `'User'` is the NestJS/Mongoose convention and reduces confusion.  
**Fix:** Rename class to `User`, schema to `UserSchema`, collection to `users`. Update all `@InjectModel('Signup')` references.

---

### 1.2 Moderate Issues (Fix in Current Iteration)

| File | Issue | Fix |
|------|-------|-----|
| `authentication.controller.ts` | No `class-validator` DTOs on signup/login `@Body()` | Create `SignupDto`, `LoginDto` with decorators |
| `volunteer.schema.ts` | `location` is a plain `string` field | Change to `GeoJSON Point` type for map queries |
| `app.module.ts` | `ConfigModule.forRoot()` called without `isGlobal: true` | Add `isGlobal: true` or all child modules lose access |
| `main.ts` | Manual logging middleware duplicates NestJS Logger | Use `app.useLogger(new Logger())` or a `LoggingInterceptor` |
| `authentication.module.ts` | `JwtModule.register()` with hardcoded fallback secret | Use `JwtModule.registerAsync()` with `ConfigService` |
| `chat.gateway.ts` | `connectedUsers` is an in-process `Map` | Breaks with multiple instances; replace with Redis adapter |

---

## 2. DATABASE SCHEMA DESIGN

### Design Principles
- **Embed** data that is always accessed together and has bounded size (e.g., location coordinates inside a document).
- **Reference** data that is large, shared, or queried independently (e.g., `userId` references in requests).
- **GeoJSON `2dsphere` indexes** on all location fields for geospatial queries (map feature, proximity-based volunteer dispatch).
- **Enum strings** encoded as TypeScript `enum` values — never raw strings — to prevent dirty data.

---

### Schema 1: User (`users` collection)

```typescript
// src/users/schemas/user.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export enum UserRole {
  HELP_SEEKER = 'help_seeker',
  VOLUNTEER   = 'volunteer',
  ADMIN       = 'admin',
}

export type UserDocument = User & Document;

@Schema({ timestamps: true, collection: 'users' })
export class User {
  @Prop({ required: true, trim: true })
  username: string;

  @Prop({ required: true, unique: true, lowercase: true, trim: true, index: true })
  email: string;

  @Prop({ required: true, select: false }) // Never returned in queries by default
  password: string;

  @Prop({ enum: UserRole, default: UserRole.HELP_SEEKER })
  role: UserRole;

  @Prop({ default: false })
  isVerifiedVolunteer: boolean;

  @Prop()
  phoneNumber?: string;

  @Prop()
  profilePictureUrl?: string;

  @Prop()
  city?: string;

  // Medical info for help seekers
  @Prop({ type: Object })
  medicalInfo?: {
    bloodGroup?: string;
    allergies?: string;
    conditions?: string;
  };

  // Skills for volunteers
  @Prop([String])
  skills?: string[];

  // GeoJSON for map queries — INDEXED
  @Prop({
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number] }, // [longitude, latitude]
  })
  location?: {
    type: 'Point';
    coordinates: [number, number];
  };

  @Prop({ default: false })
  isLocationVisible: boolean; // Volunteer can toggle this

  @Prop({ default: null })
  fcmToken?: string; // Firebase Cloud Messaging token for push notifications

  @Prop()
  googleId?: string;

  @Prop({ default: 0 })
  failedLoginAttempts: number;

  @Prop({ default: null })
  lockUntil?: Date;
}

export const UserSchema = SchemaFactory.createForClass(User);

// INDEXES
UserSchema.index({ location: '2dsphere' }); // Geospatial queries
UserSchema.index({ role: 1 });
UserSchema.index({ isVerifiedVolunteer: 1, role: 1 }); // Compound: find verified volunteers
```

---

### Schema 2: HelpRequest (`help_requests` collection)

```typescript
// src/help-requests/schemas/help-request.schema.ts
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose';

export enum RequestCategory {
  MEDICAL   = 'medical',
  DISASTER  = 'disaster',
  BLOOD     = 'blood_donation',
  ROADBLOCK = 'roadblock',
  FOOD      = 'food',
  RESCUE    = 'rescue',
  LOST      = 'lost_found',
  OTHER     = 'other',
}

export enum RequestStatus {
  OPEN        = 'open',
  IN_PROGRESS = 'in_progress',
  RESOLVED    = 'resolved',
  EXPIRED     = 'expired',
  CANCELLED   = 'cancelled',
}

export enum UrgencyLevel {
  LOW      = 'low',
  MEDIUM   = 'medium',
  HIGH     = 'high',
  CRITICAL = 'critical', // Equivalent to SOS
}

export type HelpRequestDocument = HelpRequest & Document;

@Schema({ timestamps: true, collection: 'help_requests' })
export class HelpRequest {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, index: true })
  seekerId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', default: null, index: true })
  responderId?: Types.ObjectId; // The volunteer who accepted

  @Prop({ enum: RequestCategory, required: true })
  category: RequestCategory;

  @Prop({ required: true, maxlength: 500 })
  description: string;

  @Prop({ enum: UrgencyLevel, default: UrgencyLevel.MEDIUM })
  urgency: UrgencyLevel;

  @Prop({ enum: RequestStatus, default: RequestStatus.OPEN, index: true })
  status: RequestStatus;

  // GeoJSON — REQUIRED for map display and geospatial proximity queries
  @Prop({
    type: { type: String, enum: ['Point'], required: true, default: 'Point' },
    coordinates: { type: [Number], required: true }, // [longitude, latitude]
  })
  location: {
    type: 'Point';
    coordinates: [number, number];
  };

  @Prop({ default: null })
  locationLabel?: string; // Human-readable address (reverse geocoded)

  @Prop([String])
  mediaUrls?: string[]; // Cloudinary URLs

  @Prop({ default: false })
  isSOS: boolean;

  @Prop({ default: true })
  isVisible: boolean; // Admin can hide malicious requests

  // Auto-expire open requests after 24 hours
  @Prop({ default: () => new Date(Date.now() + 24 * 60 * 60 * 1000), index: true })
  expiresAt: Date;

  @Prop({ default: null })
  resolvedAt?: Date;
}

export const HelpRequestSchema = SchemaFactory.createForClass(HelpRequest);

// INDEXES
HelpRequestSchema.index({ location: '2dsphere' });
HelpRequestSchema.index({ status: 1, isSOS: -1, createdAt: -1 }); // Dashboard queries
HelpRequestSchema.index({ seekerId: 1 });
HelpRequestSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 }); // TTL index — MongoDB auto-deletes
```

---

### Schema 3: VolunteerApplication (`volunteer_applications` collection)

```typescript
// src/volunteers/schemas/volunteer-application.schema.ts
export enum ApplicationStatus {
  PENDING  = 'pending',
  APPROVED = 'approved',
  REJECTED = 'rejected',
}

@Schema({ timestamps: true, collection: 'volunteer_applications' })
export class VolunteerApplication {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true, unique: true }) // One app per user
  userId: Types.ObjectId;

  @Prop({ required: true })
  cnic: string; // CNIC number (encrypted at rest recommended)

  @Prop([String])
  documentUrls: string[]; // Cloudinary URLs for uploaded ID/certificates

  @Prop({ required: true })
  expertise: string;

  @Prop({ required: true, maxlength: 1000 })
  reason: string;

  @Prop({ enum: ApplicationStatus, default: ApplicationStatus.PENDING, index: true })
  status: ApplicationStatus;

  @Prop({ type: Types.ObjectId, ref: 'User', default: null })
  reviewedBy?: Types.ObjectId; // Admin who approved/rejected

  @Prop({ default: null })
  rejectionReason?: string;
}
```

---

### Schema 4: Message (`messages` collection) — Updated

```typescript
// src/chat/schemas/message.schema.ts
// Key change: tie every message to a HelpRequest to enforce SRS constraint

@Schema({ timestamps: true, collection: 'messages' })
export class Message {
  @Prop({ type: Types.ObjectId, ref: 'HelpRequest', required: true, index: true })
  requestId: Types.ObjectId; // ENFORCES: chat only exists within a request

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  senderId: Types.ObjectId;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  receiverId: Types.ObjectId;

  @Prop({ required: true, maxlength: 1000 })
  content: string;

  @Prop({ default: false })
  isPredefined: boolean; // true = from guided message template

  @Prop({ default: false })
  isRead: boolean;
}

// INDEXES
MessageSchema.index({ requestId: 1, createdAt: -1 });
MessageSchema.index({ senderId: 1, receiverId: 1, requestId: 1 });
```

---

### Schema 5: PrecautionAlert (`precaution_alerts` collection)

```typescript
@Schema({ timestamps: true, collection: 'precaution_alerts' })
export class PrecautionAlert {
  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  issuedBy: Types.ObjectId; // Must be verified volunteer

  @Prop({ required: true })
  alertType: string; // 'flood' | 'fire' | 'earthquake' | 'road_blockage' | 'other'

  @Prop({ required: true, maxlength: 500 })
  message: string;

  // Broadcast radius center
  @Prop({
    type: { type: String, enum: ['Point'], default: 'Point' },
    coordinates: { type: [Number], required: true },
  })
  location: { type: 'Point'; coordinates: [number, number] };

  @Prop({ required: true, default: 5000 }) // meters
  radiusMeters: number;

  @Prop({ default: true })
  isActive: boolean;
}

PrecautionAlertSchema.index({ location: '2dsphere' });
```

---

### Schema 6: Community Group (`community_groups` collection)

```typescript
@Schema({ timestamps: true, collection: 'community_groups' })
export class CommunityGroup {
  @Prop({ required: true, trim: true })
  name: string;

  @Prop({ maxlength: 500 })
  description?: string;

  @Prop({ type: Types.ObjectId, ref: 'User', required: true })
  createdBy: Types.ObjectId; // Must be verified volunteer

  @Prop([{ type: Types.ObjectId, ref: 'User' }])
  members: Types.ObjectId[];

  @Prop({ default: 50 })
  maxMembers: number;

  @Prop({ default: true })
  isActive: boolean;
}
```

---

## 3. EXECUTION PIPELINE — NestJS Request Lifecycle

### 3.1 Global Pipeline Configuration (`main.ts`)

```typescript
async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // 1. Global Exception Filter
  app.useGlobalFilters(new GlobalExceptionFilter());

  // 2. Global Interceptors
  app.useGlobalInterceptors(
    new LoggingInterceptor(),
    new ResponseTransformInterceptor(),
  );

  // 3. Global Validation Pipe
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,                    // Auto-transform payloads to DTO class instances
    transformOptions: { enableImplicitConversion: true },
  }));

  // 4. CORS (environment-controlled)
  app.enableCors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') ?? ['http://localhost:3000'],
    credentials: true,
  });

  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
}
```

---

### 3.2 Guards — Authentication & Authorization

**Guard 1: `JwtAuthGuard` (Authentication)**
```typescript
// src/common/guards/jwt-auth.guard.ts
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }
  handleRequest(err, user) {
    if (err || !user) throw err ?? new UnauthorizedException('Invalid or expired token');
    return user;
  }
}
```

**Guard 2: `RolesGuard` (Authorization)**
```typescript
// src/common/guards/roles.guard.ts
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}
  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<UserRole[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ]);
    if (!requiredRoles) return true;
    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.includes(user.role);
  }
}
```

**Usage on any controller:**
```typescript
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN)
@Delete('users/:id')
async banUser(@Param('id') id: string) { ... }
```

---

### 3.3 Interceptors

**Response Transform Interceptor** — Standardizes all API responses:
```typescript
// src/common/interceptors/response-transform.interceptor.ts
@Injectable()
export class ResponseTransformInterceptor<T> implements NestInterceptor<T, ApiResponse<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<ApiResponse<T>> {
    return next.handle().pipe(
      map((data) => ({
        success: true,
        statusCode: context.switchToHttp().getResponse().statusCode,
        data,
        timestamp: new Date().toISOString(),
      })),
    );
  }
}
```

**Logging Interceptor** — Replaces the manual `app.use()` logger:
```typescript
@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const req = context.switchToHttp().getRequest();
    const { method, url } = req;
    const start = Date.now();
    return next.handle().pipe(
      tap(() => this.logger.log(`${method} ${url} — ${Date.now() - start}ms`)),
    );
  }
}
```

---

### 3.4 Pipes — DTO Validation Examples

**`CreateHelpRequestDto`**
```typescript
// src/help-requests/dto/create-help-request.dto.ts
import { IsEnum, IsString, IsNumber, IsOptional, MaxLength, IsBoolean } from 'class-validator';

export class CreateHelpRequestDto {
  @IsEnum(RequestCategory)
  category: RequestCategory;

  @IsString()
  @MaxLength(500)
  description: string;

  @IsEnum(UrgencyLevel)
  @IsOptional()
  urgency?: UrgencyLevel;

  @IsNumber()
  latitude: number;

  @IsNumber()
  longitude: number;

  @IsString()
  @IsOptional()
  locationLabel?: string;

  @IsBoolean()
  @IsOptional()
  isSOS?: boolean;
}
```

**`LoginDto`** (fixes the current missing validation)
```typescript
export class LoginDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;
}
```

---

### 3.5 Services — Business Logic with Repository Pattern

The service layer should NEVER contain raw Mongoose queries scattered inline. Instead, abstract database access:

```typescript
// src/help-requests/repositories/help-request.repository.ts
@Injectable()
export class HelpRequestRepository {
  constructor(@InjectModel(HelpRequest.name) private model: Model<HelpRequestDocument>) {}

  async findNearby(lng: number, lat: number, radiusMeters: number, status = RequestStatus.OPEN) {
    return this.model.find({
      location: {
        $near: {
          $geometry: { type: 'Point', coordinates: [lng, lat] },
          $maxDistance: radiusMeters,
        },
      },
      status,
      isVisible: true,
    }).populate('seekerId', 'username profilePictureUrl').exec();
  }

  async create(dto: CreateHelpRequestDto & { seekerId: string }): Promise<HelpRequestDocument> {
    return this.model.create({
      ...dto,
      location: { type: 'Point', coordinates: [dto.longitude, dto.latitude] },
    });
  }
}
```

```typescript
// src/help-requests/help-requests.service.ts
@Injectable()
export class HelpRequestsService {
  constructor(
    private readonly repo: HelpRequestRepository,
    private readonly firebaseService: FirebaseService,
    private readonly usersService: UsersService,
  ) {}

  async createRequest(seekerId: string, dto: CreateHelpRequestDto) {
    const request = await this.repo.create({ ...dto, seekerId });

    // Notify nearby volunteers (non-blocking)
    this.notifyNearbyVolunteers(request).catch(() => {});

    return request;
  }

  private async notifyNearbyVolunteers(request: HelpRequestDocument) {
    const [lng, lat] = request.location.coordinates;
    const volunteers = await this.usersService.findNearbyVerifiedVolunteers(lng, lat, 10000);
    const tokens = volunteers.map(v => v.fcmToken).filter(Boolean);
    if (tokens.length) {
      await this.firebaseService.sendMulticast(tokens, {
        title: request.isSOS ? '🚨 SOS ALERT' : `New ${request.category} Request`,
        body: request.description.slice(0, 100),
        data: { requestId: request._id.toString(), type: 'help_request' },
      });
    }
  }
}
```

---

### 3.6 Exception Filter — Global Error Handling

```typescript
// src/common/filters/global-exception.filter.ts
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();
      message = typeof exceptionResponse === 'string'
        ? exceptionResponse
        : (exceptionResponse as any).message ?? message;
    } else if (exception instanceof MongooseError) {
      status = HttpStatus.BAD_REQUEST;
      message = 'Database operation failed';
    }

    this.logger.error(`${request.method} ${request.url} — ${status}: ${message}`);

    response.status(status).json({
      success: false,
      statusCode: status,
      message,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

---

## 4. SENIOR DEV HANDOFF

### 4.1 Recommended Folder Structure

```
src/
├── app.module.ts
├── main.ts
│
├── common/                          # Shared across all modules
│   ├── decorators/
│   │   ├── current-user.decorator.ts
│   │   └── roles.decorator.ts
│   ├── filters/
│   │   └── global-exception.filter.ts
│   ├── guards/
│   │   ├── jwt-auth.guard.ts
│   │   └── roles.guard.ts
│   ├── interceptors/
│   │   ├── logging.interceptor.ts
│   │   └── response-transform.interceptor.ts
│   └── pipes/
│       └── parse-objectid.pipe.ts
│
├── config/                          # Environment configuration
│   ├── app.config.ts
│   ├── database.config.ts
│   └── jwt.config.ts
│
├── auth/                            # Renamed from 'authentication'
│   ├── auth.module.ts
│   ├── auth.controller.ts
│   ├── auth.service.ts
│   ├── strategies/
│   │   └── jwt.strategy.ts          # Passport JWT strategy
│   └── dto/
│       ├── signup.dto.ts
│       ├── login.dto.ts
│       └── google-login.dto.ts
│
├── users/                           # Replaces 'user' module
│   ├── users.module.ts
│   ├── users.controller.ts
│   ├── users.service.ts
│   ├── users.repository.ts
│   ├── schemas/
│   │   └── user.schema.ts
│   └── dto/
│       ├── update-profile.dto.ts
│       └── update-location.dto.ts
│
├── help-requests/                   # Replaces 'helps' module — full rewrite
│   ├── help-requests.module.ts
│   ├── help-requests.controller.ts
│   ├── help-requests.service.ts
│   ├── help-requests.repository.ts
│   ├── schemas/
│   │   └── help-request.schema.ts
│   └── dto/
│       ├── create-help-request.dto.ts
│       └── update-request-status.dto.ts
│
├── volunteers/                      # Replaces 'volunteer' module
│   ├── volunteers.module.ts
│   ├── volunteers.controller.ts
│   ├── volunteers.service.ts
│   ├── schemas/
│   │   └── volunteer-application.schema.ts
│   └── dto/
│       └── apply-volunteer.dto.ts
│
├── admin/
│   ├── admin.module.ts
│   ├── admin.controller.ts          # All routes @Roles('admin')
│   ├── admin.service.ts
│   └── dto/
│       └── review-application.dto.ts
│
├── chat/
│   ├── chat.module.ts
│   ├── chat.controller.ts           # REST: get history, mark read
│   ├── chat.gateway.ts              # WebSocket: real-time messaging
│   ├── chat.service.ts
│   ├── schemas/
│   │   └── message.schema.ts
│   └── dto/
│       └── send-message.dto.ts
│
├── alerts/                          # NEW: Precaution alerts module
│   ├── alerts.module.ts
│   ├── alerts.controller.ts
│   ├── alerts.service.ts
│   └── schemas/
│       └── precaution-alert.schema.ts
│
├── community/                       # NEW: Community groups module
│   ├── community.module.ts
│   ├── community.controller.ts
│   ├── community.service.ts
│   └── schemas/
│       └── community-group.schema.ts
│
└── firebase/
    ├── firebase.module.ts
    └── firebase.service.ts
```

---

### 4.2 Required NestJS Modules Summary

| Module | Purpose | Key Dependencies |
|--------|---------|-----------------|
| `AuthModule` | JWT auth, Google OAuth | `PassportModule`, `JwtModule`, `UsersModule`, `FirebaseModule` |
| `UsersModule` | Profile management, location update | `MongooseModule(User)` |
| `HelpRequestsModule` | Core request CRUD, SOS, map queries | `MongooseModule(HelpRequest)`, `UsersModule`, `FirebaseModule` |
| `VolunteersModule` | Volunteer applications | `MongooseModule(VolunteerApplication)`, `UsersModule` |
| `AdminModule` | Dashboard, moderation, analytics | `VolunteersModule`, `UsersModule`, `HelpRequestsModule` |
| `ChatModule` | WebSocket gateway + message persistence | `MongooseModule(Message)`, `HelpRequestsModule` |
| `AlertsModule` | Precaution alert broadcast | `MongooseModule(PrecautionAlert)`, `FirebaseModule`, `UsersModule` |
| `CommunityModule` | Volunteer community groups | `MongooseModule(CommunityGroup)`, `UsersModule` |
| `FirebaseModule` | FCM push notifications + Google token verify | Firebase Admin SDK |
| `ConfigModule` | Environment config (`isGlobal: true`) | `@nestjs/config` |

---

### 4.3 Step-by-Step Implementation Roadmap

#### Sprint 1 — Foundation & Security Fixes (Week 1–2)
1. Rename `Signup` → `User` schema. Update all `@InjectModel` references.
2. Add `ConfigModule.forRoot({ isGlobal: true })` to `AppModule`.
3. Switch `JwtModule` to `registerAsync` using `ConfigService`.
4. Implement `JwtStrategy` (Passport) and `JwtAuthGuard`.
5. Implement `RolesGuard` + `@Roles()` decorator.
6. Implement `GlobalExceptionFilter`, `LoggingInterceptor`, `ResponseTransformInterceptor`.
7. Register all three globally in `main.ts`.
8. Remove admin hardcoded credentials. Seed admin user via a `DatabaseSeeder` script.
9. Fix CORS to use environment whitelist.

#### Sprint 2 — Core Feature: Help Requests (Week 3–4)
1. Create full `HelpRequest` schema with GeoJSON and TTL index.
2. Build `HelpRequestRepository` with `findNearby()` (geospatial).
3. Build `HelpRequestsService` with `createRequest()`, `acceptRequest()`, `resolveRequest()`.
4. Build `HelpRequestsController` with full DTO validation.
5. Wire FCM notifications into `createRequest()` and `acceptRequest()`.
6. Write unit tests for service methods using `@nestjs/testing`.

#### Sprint 3 — Auth Hardening & Profile (Week 5)
1. Add `failedLoginAttempts` + `lockUntil` lockout logic to `AuthService`.
2. Add `SignupDto` and `LoginDto` with class-validator decorators.
3. Build `UsersController` with `PATCH /users/profile` and `PATCH /users/location`.
4. Remove the manual `new JwtService({}).verify()` from the location endpoint.

#### Sprint 4 — Chat Refactor (Week 6)
1. Add `requestId` to `Message` schema.
2. Add validation in `ChatGateway.handleSendMessage()`: verify request is `in_progress`.
3. Install and configure Socket.io Redis adapter for multi-instance safety.
4. Add `GET /chat/:requestId/history` REST endpoint for message pagination.

#### Sprint 5 — Admin, Alerts & Community (Week 7–8)
1. Build `AlertsModule` (create, broadcast, deactivate precaution alerts).
2. Build `CommunityModule` (CRUD groups, join/leave).
3. Build `AdminModule` analytics endpoints:
   - `GET /admin/stats` → active SOS count, open requests, pending verifications.
   - `GET /admin/heatmap` → GeoJSON aggregate of request locations.
4. Apply `@Roles(UserRole.ADMIN)` + `@UseGuards(JwtAuthGuard, RolesGuard)` to all admin routes.

#### Sprint 6 — Testing & Performance (Week 9–10)
1. Verify all MongoDB indexes exist using `db.collection.getIndexes()`.
2. Load test `GET /help-requests/nearby` with 10,000 documents.
3. Set up Mongoose connection pooling (`maxPoolSize: 10`).
4. Enable MongoDB Atlas Performance Advisor and act on slow query suggestions.
5. End-to-end integration tests for the SOS → Notify → Accept → Resolve flow.

---

### 4.4 Environment Variables Required (`.env`)

```env
# App
NODE_ENV=development
PORT=3000
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:4200

# Database
MONGODB_URL=mongodb+srv://<user>:<pass>@cluster.mongodb.net/cerd

# Auth
JWT_SECRET=<minimum-32-char-random-secret>
JWT_EXPIRES_IN=7d

# Firebase Admin SDK
FIREBASE_PROJECT_ID=...
FIREBASE_CLIENT_EMAIL=...
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n..."

# Media
CLOUDINARY_CLOUD_NAME=...
CLOUDINARY_API_KEY=...
CLOUDINARY_API_SECRET=...

# Redis (for Socket.io adapter — Sprint 4+)
REDIS_URL=redis://localhost:6379
```

---

*Document end. All schemas, guards, interceptors, and filters above are production-ready templates. Adapt naming conventions to your team's preference but maintain the structural patterns.*
