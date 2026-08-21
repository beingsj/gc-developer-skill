# GC Core Skills

A shared library of AI coding-agent skills for reviewing GC's MERN SaaS products — architecture, security, functional QA, UI/UX, performance, AWS infrastructure, production readiness, testing, and growth tracking. Each skill is a self-contained `SKILL.md` in the shared skill format now used by **Claude Code, OpenCode, Codex CLI, and Google Antigravity** — write it once, every tool can load it.

## Install

Run the installer from inside this repo:

```bash
./install.sh                 # link skills/ into the current project (run this from inside that project's repo, or pass its path)
./install.sh /path/to/repo   # link into a specific project instead
./install.sh --global        # link into this machine's global tool config, applies to every project
```

This symlinks the one `skills/` directory into whatever folder each tool actually reads — no copies, so there's a single source of truth to update. To remove: `./uninstall.sh` (same arguments). Both scripts only ever touch a symlink they created — they leave anything else at that path alone.

### Where each tool looks

| Tool | Project folder | Global folder | How a skill runs |
|---|---|---|---|
| **Claude Code** | `.claude/skills/` | `~/.claude/skills/` | Auto-matched from your request, or say "use the `<name>` skill" |
| **OpenCode** | `.opencode/skills/` (also reads `.claude/skills/` and `.agents/skills/` directly — already covered by the other two links) | `~/.config/opencode/skills/` | Auto-matched, or reference it by name |
| **Codex CLI** | `.codex/skills/` | `~/.codex/skills/` | Auto-activated, or explicit `$<name>` / the `/skills` menu |
| **Antigravity** | `.agents/skills/` | `~/.gemini/config/skills/` | Auto-matched from your request |

`install.sh` (non-global) creates exactly three links — `.claude/skills`, `.agents/skills`, `.codex/skills` — which is enough to cover all four tools, since OpenCode already reads the first two on its own.

No build step, no plugin manifest — just the folders.

## House Style

Every skill in this set follows the same shape, so the whole library reads as one family:
- Frontmatter `name` (kebab-case, matches its folder) and a `description` starting with "Use this skill when…" so any of the four tools above can auto-select it.
- Opens with a one-line persona ("You are a …") and a `## Goal`.
- A handful of `## <Area> Checklist` sections, each a plain `Check:` bullet list.
- Audit-style skills close with `## Severity Levels` (Critical / High / Medium / Low / Improvement) and an `## Output Format` — a findings table plus a summary block ending in a score out of 10.
- Non-audit skills (mapping, testing, tracking) keep the same frontmatter/persona/Goal/checklist shape but close with whatever output actually fits the job (a flow map, a coverage table, a tracking-event table).

Keep new skills you add to this folder in this shape — it's what makes them predictable to run and easy to read.

## Skill Index

### Phase 1 — Product & Architecture Foundation
| Skill | Use it for |
|---|---|
| `mern-architecture-review` | Folder structure, separation of concerns, scalability, duplicated logic |
| `feature-flow-mapping` | Tracing a feature end-to-end: UI → API → route → middleware → controller → service → DB → response → UI |
| `frontend-backend-sync` | Request/response field, route, method, validation, auth, and pagination mismatches between FE and BE |
| `business-logic-audit` | Pricing, permissions, workflows, statuses, subscriptions, discounts, booking, ownership, credits, commissions |
| `code-quality-maintainability` | Dead code, duplication, oversized files, unused packages, naming, magic values |

### Phase 2 — Security
| Skill | Use it for |
|---|---|
| `feature-security-audit` | Deep security pass on one or two specific features (auth bypass, IDOR, injection, XSS, CSRF) |
| `auth-authorization-audit` | Login, registration, JWT/refresh tokens, sessions, roles, password reset, OTP, admin access |
| `api-security` | API auth, validation, authorization, rate limits, request manipulation, abuse scenarios |
| `mongodb-security` | NoSQL injection, unsafe queries, mass assignment, exposed fields, schema validation, aggregation risks |
| `secrets-config-security` | Hardcoded keys, exposed `.env` values, debug modes, credentials, environment misconfiguration |
| `file-upload-security` | File type/MIME validation, filename sanitization, size limits, storage permissions, path traversal |
| `payment-webhook-security` | Razorpay/Stripe/PayPal flows, webhook signatures, duplicate webhooks, price manipulation |
| `multi-tenant-isolation` | Organization/workspace separation, team access, ownership, tenant leakage, cross-account access |

### Phase 3 — Functional QA
| Skill | Use it for |
|---|---|
| `functional-qa` | Verifying a feature works correctly start to finish |
| `edge-case-testing` | Invalid input, empty states, duplicate actions, session expiry, unusual user behavior |
| `regression-testing` | Confirming a new feature/fix hasn't broken existing functionality |
| `error-handling-audit` | API/DB/network/third-party failures, timeouts, user-facing error messages |
| `concurrency-race-conditions` | Duplicate submissions, concurrent updates, repeated webhooks, booking/inventory conflicts |
| `data-integrity-audit` | Data correctness across create/update/delete, failed processes, partial transactions, retries |

### Phase 4 — UI/UX + CRO
| Skill | Use it for |
|---|---|
| `cro-modern-uiux` | Clean UI, conversion, hierarchy, decluttering, premium interface feel |
| `product-ux-flow` | Whether the user journey makes sense and can be simplified |
| `responsive-design-audit` | Desktop/tablet/mobile layout, overflow, forms, tables, modals, navigation, touch |
| `accessibility-audit` | Contrast, keyboard nav, focus states, labels, semantic structure, WCAG |
| `form-optimization` | Field order, validation, defaults, autofill, error states, CTA placement, completion friction |
| `dashboard-simplification` | Metric hierarchy, actionable insights, fewer cards, progressive disclosure |

### Phase 5 — Performance
| Skill | Use it for |
|---|---|
| `frontend-performance` | React renders, lazy loading, bundle size, API waterfalls, Core Web Vitals |
| `backend-performance` | Node.js bottlenecks, blocking operations, latency, timeouts, memory usage |
| `mongodb-performance` | Indexes, query plans, aggregations, pagination, projections, schema design |
| `api-performance` | Slow endpoints, oversized payloads, round trips, caching, filtering |
| `caching-strategy` | Where Redis, browser, CDN, API, query, or memoization caching would help |

### Phase 6 — AWS Optimization
| Skill | Use it for |
|---|---|
| `aws-architecture-optimization` | Right-sizing the overall AWS setup (EC2/ECS/Lambda/S3/CloudFront/RDS/etc.) for cost, scale, availability |
| `aws-cost-optimization` | Unnecessary AWS spend: idle/oversized resources, unused volumes, NAT/data-transfer cost, storage classes |
| `aws-performance-optimization` | App latency, CDN usage, DB performance, caching, instance type, region, load balancing |
| `aws-security-hardening` | IAM, root usage, MFA, public S3, open security groups, encryption, GuardDuty, WAF |
| `aws-scalability` | Auto Scaling, stateless backend, shared sessions, caching, queues, DB connection limits |
| `aws-reliability-ha` | Instance/AZ/DB failure scenarios, backup restoration, deployment failure recovery |
| `aws-monitoring-observability` | CloudWatch metrics, logs, alarms, latency, Lambda/queue failures, uptime alerts |
| `aws-backup-disaster-recovery` | Automated backups, restore tests, retention, snapshots, S3 versioning, RPO/RTO |
| `aws-devops-deployment` | CI/CD, Docker, ECS, CodePipeline, blue/green, zero-downtime, rollback |
| `aws-environment-optimization` | Dev/staging/prod separation — no shared secrets, DBs, or infra with production |

### Phase 7 — Production Readiness
| Skill | Use it for |
|---|---|
| `devops-production-readiness` | Docker, Nginx, reverse proxy, env vars, SSL, process managers, deployment/rollback |
| `logging-monitoring` | App logs, error logs, failed cron jobs, background workers, alerts, audit logs |
| `background-jobs-cron-audit` | Scheduled jobs, retry logic, duplicate execution, locking, queue handling, timezones |
| `third-party-integration-audit` | Google APIs, WhatsApp, email/SMS, AI APIs, webhooks, retries, rate limits, fallbacks |
| `production-error-recovery` | What happens when MongoDB/AWS/payment/email/queue/frontend temporarily fails |

### Phase 8 — Testing & Automation
| Skill | Use it for |
|---|---|
| `unit-testing` | Core functions and business logic |
| `api-integration-testing` | Routes, controllers, middleware, DB operations, validation, permissions |
| `frontend-component-testing` | Components, forms, state management, interactions, error states |
| `e2e-testing` | Complete real user flows (Playwright/Cypress style) |
| `automated-regression-suite` | Building reusable tests so future changes are verified automatically |

### Phase 9 — SEO, Analytics & Growth
| Skill | Use it for |
|---|---|
| `technical-seo` | Meta tags, schema, canonical URLs, sitemap, robots.txt, SSR/CSR, indexability |
| `analytics-tracking` | GA4, Meta Pixel, GTM, funnel events, duplicate/missing tracking |
| `cro-tracking` | Making key actions measurable (signup, login, trial, checkout, payment, booking, lead) |
| `funnel-analysis` | Where users drop off between entry and conversion |
