# LearnWay Web — Feasibility & Plan

## Repo map

Three codebases in `ai_mentor/`:

- **`lib/`** — Flutter client (iOS/Android, no `web/` folder currently — not Flutter-web-enabled). Features under `lib/features/`: auth, account_setup, home, learn_and_earn, quiz, battles, contest, leader_board, badges, streak, statistics, ai_tutor, subscription, notifications, bookmarks, explore_paths, promotions, invite_friends, vocabulary — plus **wallet**, and blockchain-specific services under `lib/services/`: `eip_4337` (account abstraction), `secret_sharing_service` (Shamir key splitting), `defi_service` (Kotani Pay on/off-ramp), `kyc_service` (DidIt). Two internal packages: `packages/core` (DI, network, storage, theme — reusable) and `packages/ai_mentor` (Lenny chat, learning path, discovery flow, dashboard, career/weekly goals — reusable, UI-agnostic logic).
- **`learnway-backend/`** — NestJS + TypeORM/Postgres + Redis/Bull. ~40 `api/*` modules covering content (course, lesson, quiz, question, learning-path), gamification (badge, leaderboard, streak via user entity, reward, contest, battle, quiz-battle), monetization (subscription via RevenueCat, payment via Fonbnk/Kotani crypto on-ramp), and blockchain (`api/blockchain`, `api/paymaster`, `common/services/blockchain/*`, `queue/blockchain.processor.ts`, `cron/blockchain-transaction-batch.service.ts`).
- **`learnway-ai-service/`** — separate NestJS microservice. Modules: `ai-mentor`, `ai-quiz-studio`, `ai-analytics`, `ai-translation`. Own JWT auth strategy (same pattern/secret as main backend). **Zero blockchain references** — it's already a clean service.

## Can you drop blockchain without backend changes? Short answer: architecturally yes, practically no — a few small, well-isolated changes are needed.

Here's what I found tracing the actual data flow, not just the module list:

**Blockchain is already an additive sync layer, not the source of truth.** The `User` entity stores `totalXP`, `totalGems`, `totalBadges`, `badgesList`, `currentStreak` etc. directly in Postgres. `BlockchainService.getUserBalance()` tries a contract read and **falls back to these DB columns** if the chain call fails. So core gamification (XP, gems, badges, streaks, leaderboards) works fully on Postgres alone today.

**Blockchain writes are fire-and-forget, non-blocking.** `registerUser`, `completeQuiz`, `updateUserProfile`, and `syncUserData` are pushed onto a Bull queue (`BlockchainJobService`) with 1 retry and short backoff. The HTTP response to the client doesn't wait on these. Registration's `RegisterUserDto` has **no wallet fields at all** — signup already works without a wallet.

**Wallet fields on `User` are all nullable**: `walletAddress`, `walletPin`, `walletPinSalt`, `halfPrivateKey`, `lastBlockchainSync`, `pendingTransactions`. Nothing in the DB schema forces a wallet to exist.

So for a web client that simply **never calls** `/blockchain/*`, `/paymaster/*`, or wallet-linking endpoints, the rest of the API (auth, lessons, quizzes, courses, badges, leaderboard, battles, streaks, ai-tutor) works today, unmodified.

### Where you do need backend changes

1. **Payment/monetization.** `api/payment` (Fonbnk, Kotani) is a crypto fiat on/off-ramp — meaningless without a wallet. Subscriptions already run through RevenueCat (IAP), which has no web equivalent. For web you'll need a genuinely new payment rail — Stripe Checkout/Billing is the natural choice — which is new backend work, not a strip-out.
2. **KYC.** `kyc_service` (DidIt) exists for wallet/compliance reasons. Decide whether web (no custody, no crypto) still needs identity verification — if not, this whole flow is skippable; if you keep any cash-value rewards, revisit.
3. **Wasted queue work.** Web signups will still be eligible to enqueue `registerUser`/`completeQuiz` blockchain jobs unless gated — they'll just fail harmlessly after retries, but it's wasted Redis/queue load. Cheap fix: add a `platform` or `hasWallet` flag on `User` (or check `walletAddress == null`) and skip enqueueing for those accounts. Small, isolated change.
4. **Onboarding flow.** The wallet PIN / recovery-phrase / secret-sharing steps are client-side UX (`pass_phrase_screen.dart`, `account_setup`), not backend requirements — for web you just build a different onboarding screen sequence, no backend involvement.

Net: you will **not** need to touch the core content/gamification/quiz/lesson APIs at all. You will need **new** payment integration work (Stripe) and a small opt-out flag for the job queue. That's it on the backend side.

## Recommended architecture for web

**Do not try to get the existing Flutter app running on Flutter Web.** It's not currently web-enabled (no `web/` dir), and it's saturated with mobile-only concerns (biometrics, native secure storage, iCloud/Google Drive key shard storage, camera sheets, native IAP). Retrofitting it would fight you more than a fresh client.

**Build a new web frontend** (Next.js/React or SvelteKit — whichever your team knows) that talks to the *same* `learnway-backend` and `learnway-ai-service` REST APIs the mobile app already uses. This is the standard "shared backend, native mobile + web frontend" split, and it's cleanly supported here because:

- Auth is already JWT-based and stateless — works identically over HTTP for web.
- Content/quiz/course/lesson/leaderboard/badge/streak APIs are already wallet-agnostic reads/writes.
- `learnway-ai-service` (tutor chat, quiz generation, analytics, translation) is already a standalone HTTP service with its own JWT guard — reusable as-is.
- `packages/ai_mentor`'s *business logic* (learning path, discovery flow, weekly/career goals) is UI-agnostic Dart — not directly portable to a JS web client, but useful as a reference spec for porting the same logic to TypeScript.

### Phase plan

1. **Backend prep (small, isolated)**
   - Add a `platform`/`hasWallet` gate so web users skip blockchain job enqueueing.
   - Stand up a Stripe integration in `learnway-backend` (or a new `payment-web` module) parallel to the existing crypto payment module — don't touch the existing one.
   - Decide on KYC requirement for web; likely skip it initially.
   - Confirm CORS + rate limiting config allows a browser origin (mobile app doesn't need CORS; web will).

2. **New web client**
   - Auth: email/password + OTP + social login (reuse existing endpoints).
   - Onboarding: username, avatar, preferences — skip wallet PIN/passphrase screens entirely.
   - Core loop: lessons, quizzes, streaks, badges, leaderboard, battles, contests — straight REST consumption, no wallet awareness needed in the UI at all.
   - AI tutor: call `learnway-ai-service` directly (mentor chat, quiz studio, analytics, translation).
   - Monetization: Stripe-based subscription UI, replacing the RevenueCat/crypto flows.
   - Drop entirely: wallet screens, deposit/withdraw, KYC screens (pending the decision above), pass-phrase/secret-sharing setup.

3. **Verification**
   - Smoke-test the full non-blockchain API surface from the new client against a staging backend.
   - Confirm blockchain queue jobs for web accounts either don't fire or fail silently without side effects (no user-facing errors, no retry storms).
   - Load-test Stripe webhook handling analogous to the existing `revenuecat-webhook.controller.ts` pattern.

## Bottom line

The blockchain layer was built as a bolt-on (async queue + fallback-to-DB reads), which is exactly why this is tractable: you can build a full-featured web app against the existing backend with no changes to core content/gamification code. The real work is replacing the two genuinely blockchain-coupled pieces — the crypto payment rail and (possibly) KYC — with web-appropriate equivalents, plus a small gating flag to stop wasted queue jobs. That's a scoped, low-risk backend addition, not a rearchitecture.
