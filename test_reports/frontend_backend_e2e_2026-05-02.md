# Frontend/Backend E2E QA Report

Date: 2026-05-02

Frontend workspace: `C:\BSE\FYP\fyp_source_code`

Backend workspace: `C:\backend\CERD Backend`

Deployed API tested by the Flutter app: `https://backendforwehelp.onrender.com/`

Live probe run id: `codex-1777718543510-ijlct`

## Verification Commands

| Check | Result |
|---|---|
| Backend Jest: `npm test -- --runInBand` in `C:\backend\CERD Backend` | Pass: 8 suites, 13 tests |
| Flutter analyzer: `dart analyze --no-fatal-warnings` | Pass with info-level lints only: 213 infos |
| Flutter widget tests: `flutter test` | Did not complete within 120s; default counter test does not match this app |
| Live disposable API probe | 51 scenarios, 49 pass, 2 fail |

## Live Scenario Records

| Scenario | Account(s) | Screen/action | Endpoint(s) | Expected backend result | Actual frontend/backend behavior | Result | Issue type |
|---|---|---|---|---|---|---|---|
| Signup normal requester | requester | Signup form submit | `POST /authentication/signup` | token, `role=user` | `201`, role `user`, token present | Pass |  |
| Admin login | admin | Admin login submit | `POST /authentication/login` | token, `role=admin` | `201`, role `admin`, token present | Pass |  |
| Invalid token | invalid token | Protected screen with expired/invalid token | `GET /help-requests/my/active` | `401` | `401`, `Invalid or expired token` | Pass | frontend still needs global login redirect |
| Volunteer application before approval | volunteer1 | Verification submit | `POST /volunteer/apply` | pending application | `201`, pending | Pass |  |
| Volunteer application before approval | volunteer2 | Verification submit | `POST /volunteer/apply` | pending application | `201`, pending | Pass |  |
| Volunteer application before approval | volunteer3 | Verification submit | `POST /volunteer/apply` | pending application | `201`, pending | Pass |  |
| Rejected application submit | rejectedUser | Verification submit | `POST /volunteer/apply` | pending application | `201`, pending | Pass |  |
| Admin pending list | admin | Admin panel opens list | `GET /admin/volunteer-applications` | list pending apps | `200`, list returned | Pass |  |
| Approve volunteer | admin/volunteer1 | Admin taps Approve | `POST /admin/volunteer-applications/:id/approve` | approved app; user can re-login as volunteer | `201`, approved | Pass |  |
| Approve volunteer | admin/volunteer2 | Admin taps Approve | `POST /admin/volunteer-applications/:id/approve` | approved app | `201`, approved | Pass |  |
| Approve volunteer | admin/volunteer3 | Admin taps Approve | `POST /admin/volunteer-applications/:id/approve` | approved app | `201`, approved | Pass |  |
| Reject volunteer | admin/rejectedUser | Admin taps Reject | `POST /admin/volunteer-applications/:id/reject` | rejected; role remains user | `201`, rejected | Pass |  |
| Role after re-login | volunteer1 | Logout/login | `POST /authentication/login` | `role=volunteer` | `201`, role `volunteer` | Pass |  |
| Role after re-login | volunteer2 | Logout/login | `POST /authentication/login` | `role=volunteer` | `201`, role `volunteer` | Pass |  |
| Role after re-login | volunteer3 | Logout/login | `POST /authentication/login` | `role=volunteer` | `201`, role `volunteer` | Pass |  |
| Rejected role after re-login | rejectedUser | Logout/login | `POST /authentication/login` | `role=user` | `201`, role `user` | Pass |  |
| Requester role after re-login | requester | Logout/login | `POST /authentication/login` | `role=user` | `201`, role `user` | Pass | frontend routing issue noted below |
| Normal user role after re-login | unrelatedUser | Logout/login | `POST /authentication/login` | `role=user` | `201`, role `user` | Pass | frontend routing issue noted below |
| Create normal help request | requester | Request Help sheet Send | `POST /help-requests` | open request | `201`, status `open` | Pass |  |
| Create SOS request | requester | SOS FAB | `POST /help-requests/sos` | open SOS | `201`, status `open`, `isSos=true` | Pass |  |
| Volunteer creates help request | volunteer1 | Request Help as volunteer | `POST /help-requests`, `POST /authentication/login` | request opens; role remains volunteer | create `201`, re-login role `volunteer` | Pass |  |
| Volunteer self-accept blocked | volunteer1 | Tap Accept on own request | `PATCH /help-requests/:id/accept` | blocked | `400`, `You cannot accept your own request` | Pass |  |
| Requester accept blocked | requester | Requester attempts Accept | `PATCH /help-requests/:id/accept` | blocked | `400`, `Only verified volunteers can accept help requests` | Pass |  |
| Non-admin admin access | requester | Direct admin endpoint | `GET /admin/volunteer-applications` | blocked | `400`, `Admin credentials required` | Pass |  |
| Volunteer accepts requester request | volunteer1 | Tap Accept | `PATCH /help-requests/:id/accept` | accepted | `200`, status `accepted` | Pass |  |
| Accepted request removed from open list | volunteer1 | Dashboard refresh | `GET /help-requests` | accepted request absent | `200`, open list did not include accepted request | Pass |  |
| Coordination contacts after accept | requester/volunteer1 | Contacts screen | `GET /chat/coordination/contacts` | requester sees volunteer; volunteer sees requester | both returned expected contact IDs | Pass |  |
| Concurrent accept | volunteer1/volunteer2 | Two tabs Accept same request | `PATCH /help-requests/:id/accept` twice | one success, one failure | `200 accepted` and `400 no longer open` | Pass |  |
| Unrelated resolve blocked | unrelatedUser | Tap Done on unrelated request | `PATCH /help-requests/:id/resolve` | blocked | `400`, permission message | Pass |  |
| Concurrent resolve | requester/volunteer1 | Two tabs Done same request | `PATCH /help-requests/:id/resolve` twice | one final resolved state, no duplicate success | both returned `200`, status `resolved` | Fail | backend race/duplicate notification risk |
| Rate after resolved | requester | Submit rating dialog | `POST /help-requests/:id/rating` | rating saved | `201`, score `5` | Pass |  |
| Volunteer cannot rate as acceptor | volunteer1 | Volunteer calls rating | `POST /help-requests/:id/rating` | blocked | `400`, only requester can rate | Pass |  |
| Duplicate rating from two tabs | requester | Two rating submits | `POST /help-requests/:id/rating` twice | one success, duplicate blocked | `201` and `400 already rated` | Pass |  |
| Volunteer create plus accept in parallel | volunteer1 | Create own request and accept another | `POST /help-requests`, `PATCH /help-requests/:id/accept`, login | both succeed; role remains volunteer | create `201`, accept `200`, re-login role `volunteer` | Pass |  |
| My requests / active requests | requester/volunteer1 | My/active dashboard | `GET /help-requests/my`, `GET /help-requests/my/active` | owner scoped; active open/accepted only | expected owner and active statuses returned | Pass | frontend lacks full "my requests" UI beyond active list |
| Map filters and marker roles | requester/volunteers | Map/list filters | `GET /map/users?role=...` | volunteers by account role; requestee filter maps users | expected markers returned | Pass | frontend lacks filter UI |
| Invalid map coordinates | requester | Bad lat/lng | `GET /map/users?lat=bad&lng=bad` | clean `400` | `400`, `lat and lng must be valid numbers` | Pass |  |
| Chat REST fallback | requester/volunteer1 | Send/open/mark-read | `POST /chat/send-message`, `GET /chat/conversation/:id`, `GET /chat/unread-count`, `GET /chat/mark-read/:id` | message saved, unread clears | send `201`, history count `1`, unread `1 -> 0` | Pass | WebSocket reconnect not fully UI-tested |
| Delete message permissions | volunteer2/requester | Delete message | `DELETE /chat/message/:id` | non-sender blocked; sender can delete | non-sender `400`, sender `200` | Pass |  |
| Parallel chat messages | requester/volunteer1 | Two tabs send | `POST /chat/send-message` twice, history | both present once | both `201`, both contents present once | Pass |  |
| Normal user create community blocked | requester | Publish community | `POST /communities` | blocked | `400`, volunteers only | Pass |  |
| Volunteer create community | volunteer1 | Publish community | `POST /communities` | creator auto-member | `201`, creator in `members` | Pass |  |
| Community read as normal user | requester | List/detail page | `GET /communities`, `GET /communities/:id` | authenticated normal user can read | both `200` | Pass | frontend incorrectly hides list |
| Normal user join blocked | requester | Join community | `POST /communities/:id/join` | blocked | `400`, volunteers only | Pass |  |
| Non-member chat blocked | volunteer2 before join | Read/send chat | `GET/POST /communities/:id/messages` | blocked | both `400`, join required | Pass |  |
| Member community chat | volunteer2 | Join/send/read chat | `POST /join`, `POST/GET /messages` | message visible | join `201`, send `201`, read `200` | Pass |  |
| Non-owner manage blocked | volunteer2 | Start/delete | `PATCH /start`, `DELETE /communities/:id` | blocked | both `400`, owner/admin only | Pass |  |
| Concurrent joins | volunteer2/volunteer3 | Two volunteers Join | `POST /communities/:id/join` twice | both members once | both `201`, members unique | Pass |  |
| Creator start community | volunteer1 | Start | `PATCH /communities/:id/start` | status started | `200`, status `started` | Pass |  |
| Delete while sending message | volunteer1/volunteer2 | Delete in one tab, send in another | `DELETE /communities/:id`, `POST /communities/:id/messages` | delete succeeds; send fails cleanly | delete `200`, send `201 Message sent` | Fail | backend race/ghost message risk |
| Admin delete community | admin | Admin delete | `DELETE /communities/:id` | deleted | `200`, deleted response | Pass |  |

## Frontend State/UI Findings From Code Inspection

1. Normal backend `role=user` is not treated as the requester/request-home role during login. `AuthController` only routes legacy `requestee`, `request_help`, and `requesthelp` to request home, so a real backend `user` falls to splash.

   Code: `lib/auth/presentation/controller/auth_contrl.dart:181`

2. Splash status parsing can misroute a normal user into volunteer UI. `SplashController` does not recognize `role=user`, calls `volunteer/status`, reads the top-level `status: success` as verification status, then sends unknown statuses to `RouteNames.startPoint`.

   Code: `lib/splash_onboardings/presentation/controller/splash_controller.dart:35`, `:89`, `:111`

3. Role selection writes `request_help` into local storage even though the backend account role remains `user`. This creates stale local role state that is overwritten on real login and can mask routing bugs.

   Code: `lib/auth/presentation/controller/role_selection_controller.dart:9`

4. Community list/detail is backend-readable by any authenticated user, but the Flutter screen blocks the entire screen for non-volunteers. This fails the "community list/detail as backend allows" scenario.

   Code: `lib/communities/presentation/view/communities_screen.dart:27`

5. Map backend role filters pass, and `MapRepo.getMapUsers` supports `role`, but `MapCntrl.fetchMapUsers` never passes a role and the screen has no filter controls.

   Code: `lib/volunteer_side/map/data/map_repo.dart:19`, `lib/volunteer_side/map/presentation/controller/map_controller.dart:229`

6. Invalid/expired tokens are converted into `UnauthorizedException`, but there is no global interceptor that clears token/role/cache and routes to login. Most controllers only show a toast.

   Code: `lib/network/api_service.dart:22`

7. Volunteer Accept has no per-request busy/disabled state, so double taps can dispatch duplicate accept calls. The backend handled the tested concurrent accept, but the UI can still flicker/show duplicate errors.

   Code: `lib/volunteer_side/home/presentation/view/widgets/req_card.dart:156`

8. WebSocket reconnect only flips connection state; it does not refresh conversations/history after reconnect. REST endpoints passed, but the UI does not automatically use that REST fallback after reconnect.

   Code: `lib/chat/data/services/socket_service.dart:80`, `lib/chat/presentation/provider/chat_provider.dart:43`

9. Admin panel uses `res.isEmpty` as loading, so a real empty pending list is displayed as endless shimmer instead of an empty state.

   Code: `lib/admin/presentation/view/admin_panel_screen.dart:23`

## Failure Logs

### Concurrent Resolve

Account: requester + volunteer1

Screen/action: two tabs/devices tap Done on the same accepted request.

Endpoint: `PATCH /help-requests/:id/resolve` twice in parallel.

Expected: one final resolved state with one success and one clean duplicate failure, so the frontend does not receive duplicate success notifications.

Actual:

```json
[
  { "status": 200, "requestStatus": "resolved", "message": "Help request resolved" },
  { "status": 200, "requestStatus": "resolved", "message": "Help request resolved" }
]
```

Classification: backend concurrency/race behavior with frontend duplicate-notification risk.

Relevant backend code: `src/help-requests/help-requests.service.ts:286`.

### Community Delete While Sending

Account: volunteer1 + volunteer2

Screen/action: creator deletes a community while another member sends a message.

Endpoint: `DELETE /communities/:id` and `POST /communities/:id/messages` in parallel.

Expected: delete succeeds and send fails cleanly, or UI refreshes from a failed mutation.

Actual:

```json
{
  "deleteStatus": 200,
  "sendStatus": 201,
  "sendMessage": "Message sent"
}
```

Classification: backend concurrency/race behavior; possible orphan/ghost message state.

Relevant backend code: `src/communities/communities.service.ts:104`, `src/communities/communities.service.ts:124`.

