# LearnWay Web — Engineering Build Plan

Handover doc for building a web version of LearnWay that mirrors the Flutter app's course/lesson/assignment/AI-tutor experience, with the blockchain/wallet layer removed. Based on tracing the actual code paths in `learnway-backend`, `learnway-ai-service`, and `lib/` — not the module list, the real data flow.

---

## 1. The one real decision: what replaces "minting"

Today, `CertificateService.triggerCertificateMint()` hard-fails if the user has no `walletAddress`:

```ts
if (!user.walletAddress) {
  throw new BadRequestException('User does not have a wallet address — cannot mint certificate');
}
```

Everything after that check — generating the certificate image (SVG template → ImageKit), building metadata, uploading to IPFS, calling `CertificateNFTService.mintCertificate()` on the `LearnWayCertificateAbi` contract — is an actual NFT mint. There is no wallet-less path through this code today.

**For web, there can't be a literal "mint" (that requires a wallet to hold the NFT).** The replacement is: issue the same certificate — same image, same human-readable certificate number, same public verification URL — as a database-backed record with no on-chain step. This is not a workaround, it's what most course platforms (Coursera, Udemy) actually do; on-chain was LearnWay's differentiator for the crypto-native mobile product, not a requirement of "having a certificate."

Concretely, in `certificate.service.ts`:
- Keep: certificate number generation (`lw_cert_seq`), `CertificateImageService.generateCertificateImage()`, `ImageKitService.uploadFile()`, `verifyCertificate()` public lookup by certificate number.
- Remove from the web path: the `walletAddress` guard, `IpfsService.uploadJson()` (metadata is only meaningful for an NFT), and the call into `CertificateNFTService`.
- Add: a `mintStatus` value of `'issued'` (alongside existing `'pending' | 'minted' | 'failed'`) that's set immediately once the image is generated — no async wait, no queue, no chain confirmation. `UserCertificate.tokenId`/`txHash`/`onChainVerified` stay null for these rows.
- `GET /api/v2/certificates/verify/:certificateNumber` already works for both cases — it's mint-status-aware and will just report `mintStatus: 'issued'`, `onChain: { exists: false }` for web certs.

This is a ~1-day change, isolated to `CertificateService`, gated on `!user.walletAddress` (mobile users with wallets keep minting NFTs exactly as today; web users get instant DB-backed certificates). No migration needed beyond widening the `mint_status` column's allowed values.

**Flag for your call:** if by "minting" you actually meant you want web users to eventually get real NFT certificates too (e.g., via a custodial wallet created behind the scenes), that's a materially different and bigger project — say so and I'll scope that path separately. Everything below assumes web certificates are DB-backed, not on-chain.

---

## 2. What's already reusable as-is (no backend changes)

Traced the actual controllers — these API surfaces have zero wallet/blockchain coupling and can be called by a web client today, unmodified:

| Domain | Controller | Key endpoints |
|---|---|---|
| Course catalog | `course.controller.ts` | `GET /courses`, `GET /courses/:id`, `GET /courses/:id/info`, `GET /courses/:id/enrolled-users-count` |
| Course registration/enrollment | `user_course.controller.ts` | `POST /user-course/enroll/:courseId`, `GET /user-course/my-courses`, `GET /user-course/progress/:courseId`, `GET /user-course/progress` |
| Lessons | `lesson.controller.ts`, `lesson_slide.controller.ts` | `GET /lessons`, `GET /lessons/:lessonId`, `GET /lesson-slide/lesson/:lessonId` |
| Lesson progress/completion | `user_lesson.controller.ts` | `POST /user-lesson/start/:lessonId`, `POST /user-lesson/complete/:lessonId`, `GET /user-lesson/daily-remaining`, `GET/PUT /user-lesson/progress/:lessonId` |
| Quizzes | `user_quiz.controller.ts` | `POST /user-quiz/take/:lessonId`, `GET /user-quiz/history/:lessonId`, `GET /user-quiz/latest/:lessonId` |
| Assignments/projects | `project.controller.ts` | `GET /project`, `GET /project/submissions`, `POST /project/draft`, `POST /project/submit` |
| Badges, streaks, leaderboard, contests, battles | respective controllers | all read/write directly against Postgres columns on `User`/`Badge`/`Leaderboard*` — no wallet involved |
| AI tutor chat | `learnway-ai-service` → `ai-mentor.controller.ts` | `POST /chat`, `GET /dashboard/:userId`, `GET /recommendations/:userId`, career path + discovery flow |
| AI quiz generation (admin/content) | `ai-quiz-studio.controller.ts` | `POST /generate`, question review/approve endpoints |
| AI translation | `ai-translation.controller.ts` | `POST /lesson`, `POST /tutor`, `GET /languages` |
| Auth | `auth.controller.ts` | JWT-based, email/password + OTP + social login — works identically over HTTP for a browser |

This means: **course browsing, enrollment, lesson consumption, quiz-taking, assignment submission, badges/streaks/leaderboard, and the AI tutor chat can be built against the existing backend with zero backend changes.** The web app is a new frontend consuming the same REST surface the Flutter app already uses.

## 3. What needs backend changes (scoped)

| Item | Why | Effort |
|---|---|---|
| Certificate issuance without wallet (§1) | Hard `walletAddress` guard blocks the only certificate endpoint today | ~1 day |
| Skip blockchain job enqueueing for web users | `registerUser`/`completeQuiz` jobs get queued on signup/quiz-complete regardless of platform; harmless but wasteful once web traffic exists | ~0.5 day — add `platform` enum or reuse `!walletAddress` as the gate in `AuthService`/`UserLessonService` before calling `BlockchainJobService` |
| Web payment rail | `api/payment` is Fonbnk/Kotani crypto on/off-ramp; subscriptions run through RevenueCat (mobile IAP) — neither works in a browser | New work, not a strip-out — see §6 |
| CORS config | Mobile app doesn't need it; browser does | ~1 hour, `main.ts` |
| KYC requirement | `kyc_service`/DidIt exists for wallet compliance — decide if web needs identity verification at all | Decision, not code, unless you keep it |

Everything else — content, gamification, AI — needs **no backend changes**.

---

## 4. Recommended stack

- **Frontend:** Next.js (App Router) + TypeScript + Tailwind. Reasoning: SSR for course/lesson SEO pages, React ecosystem parity with `learnway-ai-service`'s existing TS types (can share DTO types via a small shared package), large hiring pool.
- **State/data:** TanStack Query for server state (matches the request/response shape of the existing REST APIs directly — no GraphQL layer needed since one doesn't exist today). Zustand or React Context for local UI state (quiz-in-progress, lesson player state).
- **Auth:** same JWT bearer tokens as mobile — store in an httpOnly cookie (not localStorage, to reduce XSS token theft risk) issued via a thin Next.js API route that proxies `POST /auth/login` and sets the cookie.
- **Don't attempt Flutter Web.** No `web/` directory exists in this repo, and the app is saturated with mobile-only concerns (biometrics, native secure storage, iCloud/Google Drive key-shard storage for the wallet, camera sheets, native IAP). Retrofitting costs more than a fresh Next.js client.

---

## 5. Frontend build plan — feature parity with the Flutter client

The instruction was "the web should work the same way as the Flutter client, minus blockchain." Mapping each Flutter feature to its web equivalent and backend source:

### Auth & onboarding
- Login/register/OTP/social auth → `auth.controller.ts` (reuse as-is).
- Skip entirely: `pass_phrase_screen.dart` (wallet recovery phrase), wallet PIN setup, secret-sharing key backup — these have no web equivalent and no backend requirement forcing them.
- New: username + avatar selection screen (mirrors `account_setup/view/user_name_screen.dart`, `select_avatar_screen.dart` — same API calls, new UI).

### Course catalog & registration
- Course list/detail pages → `GET /courses`, `GET /courses/:id/info`.
- "Enroll" button → `POST /user-course/enroll/:courseId`.
- "My courses" / progress dashboard → `GET /user-course/my-courses`, `GET /user-course/progress`.

### Lessons
- Lesson player (slides, video, interactive content) → `GET /lesson-slide/lesson/:lessonId`.
- Start/complete tracking → `POST /user-lesson/start/:lessonId`, `POST /user-lesson/complete/:lessonId`.
- Daily lesson cap UI (mirrors `LessonBuilder._getLockState()` in `lesson_screen.dart`) → `GET /user-lesson/daily-remaining`. Port the same lock logic: free users capped per day, retakes bypass the check.

### Quizzes
- Quiz flow → `POST /user-quiz/take/:lessonId`; history/latest score → `GET /user-quiz/history/:lessonId`, `/latest/:lessonId`.

### Assignments (course projects)
- Assignment brief + submission → `GET /project`, `POST /project/draft` (autosave draft), `POST /project/submit`.
- Submission history/review → `GET /project/submissions`, `GET /project/submissions/:submissionId`.

### Certificates
- "My certificates" page → `GET /certificates/my`.
- "Claim certificate" button on course completion → `POST /certificates/claim` (once §1's backend change ships, this returns an issued DB certificate instead of erroring on missing wallet).
- Public verification page (`/verify/[certificateNumber]`) → `GET /certificates/verify/:certificateNumber` — already public, no auth, works today for the display/lookup half.

### AI chat / tutor
- Chat UI → `learnway-ai-service` `POST /chat` (note: separate service, separate base URL, same JWT).
- Dashboard/recommendations → `GET /dashboard/:userId`, `GET /recommendations/:userId`.
- Career path generation, discovery flow, weekly/career goals → same service's respective endpoints. The Dart business logic in `packages/ai_mentor/lib/src/{learning_path,discovery_flow,dashboard,career_goal,weekly_goal}` is UI-agnostic and a good spec reference for porting the same client-side sequencing logic to TypeScript, even though it can't be imported directly into a JS client.

### Badges, streaks, leaderboard, battles, contests
- All read/write directly against existing endpoints, same as mobile. No blockchain involvement in any of these today (confirmed by grep — `badge`, `leaderboard`, `streak`-related columns are pure Postgres on `User`/`Badge*`/`Leaderboard*` entities).

### Explicitly dropped (no web equivalent)
- Wallet screens (`lib/features/wallet/*`) — balance, deposit, withdraw.
- KYC flow (pending your decision in §3).
- Crypto on/off-ramp (Kotani Pay / Fonbnk) screens.

---

## 6. Monetization — the piece that needs new backend work

Mobile subscriptions run through RevenueCat (native IAP), which doesn't exist on web. Recommend: **Stripe Checkout + Billing**, built as a new module in `learnway-backend` (e.g. `api/payment-web/`) parallel to the existing crypto payment module — don't touch `api/payment` or `api/subscription`, add alongside.

- `POST /payment-web/checkout-session` — create a Stripe Checkout session for a plan.
- `POST /payment-web/webhook` — Stripe webhook handler, same pattern as the existing `revenuecat-webhook.controller.ts` (signature verification guard, idempotent event handling).
- Both should write to the existing `UserSubscription`/`user-subscription.entity.ts` so that `isPremium`/subscription-gated features (daily lesson cap, etc.) work identically regardless of which platform the user subscribed from.

This is genuinely new work, not a modification — budget it as its own workstream (~1–2 weeks incl. webhook reliability, plan sync, cancellation/refund handling).

---

## 7. Suggested milestone breakdown

1. **Backend prep (3–5 days):** certificate-without-wallet path, blockchain-job gating, CORS, decide KYC scope.
2. **Frontend skeleton (1 week):** Next.js app, auth (login/register/OTP/social), JWT cookie handling, base layout/nav.
3. **Core learning loop (2–3 weeks):** course catalog, enrollment, lesson player, quiz flow, daily-cap logic, progress dashboard.
4. **Assignments (1 week):** project brief, draft autosave, submission, review history.
5. **Gamification (1 week):** badges, streaks, leaderboard.
6. **AI tutor (1 week):** chat UI against `learnway-ai-service`, dashboard/recommendations, career path.
7. **Certificates (3–4 days):** claim flow, my-certificates page, public verification page.
8. **Payments (1–2 weeks, can run in parallel with 3–6):** Stripe integration, plan gating.
9. **QA/hardening:** cross-check every screen against the Flutter app for parity, load-test Stripe webhooks, confirm certificate issuance doesn't silently depend on any blockchain service being up.

Steps 3–7 can mostly run in parallel across engineers once step 1 and 2 land, since each domain's API is already independent and none of them (except certificates) touch the blockchain-coupled code at all.
