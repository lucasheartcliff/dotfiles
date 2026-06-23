# Global Development Standards

## Behavior
- Read relevant files before answering questions about code — never speculate about unread files
- For non-trivial tasks (3+ steps or architectural decisions): propose a plan and wait for approval
- For trivial/unambiguous tasks: proceed directly
- When requirements are vague, ask one clarifying question before proceeding
- IMPORTANT: Never speculate about code you haven't read

## Code Quality
- Write tests alongside implementation; target 100% coverage across the codebase
- Every new function, class, or module must have corresponding tests before the task is considered done
- Prefer unit tests at the boundary (service/domain layer)
- Prefer composition over inheritance and dependency injection for testability
- Apply SOLID principles; avoid premature abstraction
- Never add speculative features or code not explicitly requested

### UI
- Write E2E tests for every user-facing flow (happy path + key failure paths)
- Add `data-testid` attributes to every interactive and structurally significant component
- `data-testid` naming convention: `kebab-case`, descriptive, scoped to the component (e.g. `login-form-submit-btn`, `user-profile-avatar`)
- Never remove or rename a `data-testid` without updating the corresponding E2E test

### APIs
- Write integration tests for every endpoint covering: success response, validation errors, auth failures, and edge cases
- Integration tests must run against a real (or containerized) instance of the service and its dependencies — no mocks at the HTTP boundary
- Assert on status codes, response body shape, and side effects (e.g. DB state after a POST)

## Security
- Never log sensitive data (passwords, tokens, PII)
- Use environment variables for secrets — never hardcode them
- Validate and sanitize all user inputs at system boundaries
- Flag potential security implications when modifying auth, data access, or config

### Dependency Scanning
- Every project must include a dependency vulnerability scanner appropriate to its ecosystem:
  - **Node.js / TypeScript**: install and configure `npm audit` + [`audit-ci`](https://github.com/IBM/audit-ci) to fail CI on high/critical vulnerabilities; optionally add `snyk` for continuous monitoring
  - **Java / Maven**: add the [`org.owasp:dependency-check-maven`](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/) plugin to `pom.xml`; configure it to fail the build on CVSS score ≥ 7
  - **Java / Gradle**: add the [`org.owasp.dependencycheck`](https://jeremylong.github.io/DependencyCheck/dependency-check-gradle/) plugin to `build.gradle`
  - **Python**: add `pip-audit` to the dev dependencies and run it in CI
- Scanning must run on every CI pipeline execution — not just on release
- Never ignore a vulnerability without a documented justification and a remediation deadline in the Linear issue
- When adding a new dependency, check it against the scanner before committing

## Git & Commits
- Commit messages: imperative mood, ≤72 chars subject line
- Include the Linear issue identifier in the commit message (e.g. `feat: add auth LUC-42`)
- One logical change per commit; no WIP commits to main/master
- Never commit directly to main/master without explicit instruction
- Never push to remote branches without being asked

### Worktrees
- Every non-trivial task must be developed in a dedicated git worktree — never implement directly on the main working tree
- Worktree naming convention: `<issue-id>-<short-slug>` (e.g. `LUC-42-add-auth`)
- Workflow:
  ```bash
  # Create worktree linked to a new branch
  git worktree add ../LUC-42-add-auth -b LUC-42-add-auth

  # Work inside it
  cd ../LUC-42-add-auth

  # Remove after merging
  git worktree remove ../LUC-42-add-auth
  ```
- One worktree per Linear issue; never share a worktree across unrelated tasks
- Always remove the worktree after the branch is merged — do not leave stale worktrees

## Architecture
- Favor explicit over implicit; make dependencies visible
- Prefer reversible decisions; call out irreversible ones explicitly
- When modifying shared infrastructure, note downstream impact

## Documentation
- Documentation is part of the definition of done — a task is not complete without it
- Keep docs close to the code: prefer `README.md` at the module/service root over a centralized wiki
- Update documentation in the same commit as the code change that necessitates it — never leave docs stale

### Code
- Every public function, class, and interface must have a docstring/javadoc describing: what it does, its parameters, return value, and any notable side effects or exceptions
- Inline comments are for *why*, not *what* — if the comment restates the code, delete it
- Mark non-obvious workarounds with `// TODO(LUC-XX):` referencing the Linear issue that tracks the proper fix

### APIs
- Every API must have an up-to-date OpenAPI / Swagger spec generated from code annotations — not written by hand
- Document authentication requirements, rate limits, and error codes for every endpoint
- Breaking changes to a public API must be documented in a `CHANGELOG.md` entry before merging

### Architecture Decisions
- Significant architectural decisions must be recorded as ADRs (Architecture Decision Records) in `docs/adr/`
- ADR filename format: `NNNN-short-title.md` (e.g. `0001-use-kafka-for-event-bus.md`)
- Minimum ADR content: context, decision, consequences, and alternatives considered
- Link the ADR to the corresponding Linear issue

### README
- Every service and library must have a `README.md` covering: purpose, how to run locally, how to run tests, environment variables required, and links to relevant ADRs
- Keep the README runnable — every command in it must work on a clean checkout
- The README must reference `setup.sh` as the recommended first step for new contributors

## Bootstrap & Setup Script
- Every application must ship a `setup.sh` at the repository root
- The script must be idempotent — running it multiple times must produce the same result without errors
- Make it executable in the repository: `chmod +x setup.sh` and commit that permission
- The script must be POSIX-compliant `sh` (not bash-specific) so it runs on any Unix-like system

### setup.sh must cover
- Checking for required system dependencies (e.g. `java`, `node`, `docker`, `python3`) and printing a clear error if any are missing — never silently fail
- Verifying that `asdf` is installed and running `asdf install` to pin all runtimes to the versions declared in `.tool-versions`
- Copying `.env.example` to `.env` if `.env` does not already exist
- Installing project dependencies (e.g. `npm install`, `mvn dependency:resolve`, `pip install -r requirements.txt`)
- Running the dependency vulnerability scanner and aborting setup if high/critical issues are found
- Running database migrations or seed scripts if applicable
- Printing a clear success message with the next steps (e.g. how to start the dev server)

### setup.sh structure
  ```sh
  #!/bin/sh
  set -e

  # ── Colours ───────────────────────────────────────────────
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

  info()    { printf "${GREEN}[setup]${NC} %s\n" "$1"; }
  warn()    { printf "${YELLOW}[warn]${NC}  %s\n" "$1"; }
  abort()   { printf "${RED}[error]${NC} %s\n" "$1"; exit 1; }

  # ── Dependency checks ─────────────────────────────────────
  require() { command -v "$1" >/dev/null 2>&1 || abort "$1 is required but not installed."; }
  require asdf
  require docker

  # ── Runtime versions (asdf) ───────────────────────────────
  info "Installing runtime versions from .tool-versions..."
  asdf install

  # ── Environment ───────────────────────────────────────────
  [ -f .env ] || { cp .env.example .env; warn ".env created from .env.example — review it before continuing."; }

  # ── Install dependencies ──────────────────────────────────
  info "Installing dependencies..."
  npm install

  # ── Vulnerability scan ────────────────────────────────────
  info "Scanning dependencies for vulnerabilities..."
  npm audit --audit-level=high || abort "High/critical vulnerabilities found. Resolve them before proceeding."

  # ── Migrations ────────────────────────────────────────────
  info "Running database migrations..."
  npm run migrate

  # ── Done ──────────────────────────────────────────────────
  info "Setup complete. Run 'npm run dev' to start the development server."
  ```
- Adapt the template above to the project's actual ecosystem (Java, Python, etc.) — the structure and conventions stay the same
- Never hardcode secrets or credentials inside `setup.sh`
- Add `setup.sh` execution to the README as the recommended first step

## CI Setup
- Every project must have a CI pipeline configured during bootstrap — CI is not an afterthought
- CI must run on every push and pull request to the default branch
- Use GitHub Actions as the default CI platform unless the project has a specific reason to use something else

### Pipeline structure
- Every CI pipeline must include, at minimum, these stages in order:
  1. **Lint** — static analysis, shellcheck, formatting checks
  2. **Test** — unit tests, integration tests (with real/containerized dependencies)
  3. **Security** — dependency vulnerability scanning (see Dependency Scanning section)
  4. **Build** — compile/bundle to verify the artifact is producible
- Each stage must fail fast — do not continue to later stages if an earlier one fails

### Runtime versions in CI
- CI must install runtimes from `.tool-versions` via `asdf install` — never hardcode versions in the workflow file
- Use the [`asdf-vm/actions`](https://github.com/asdf-vm/actions) GitHub Action or equivalent to bootstrap asdf in CI:
  ```yaml
  - uses: asdf-vm/actions/install@v3
  ```
- If a Dockerfile is involved, it must also derive its base image version from `.tool-versions` — never pin independently

### CI workflow template (GitHub Actions)
  ```yaml
  name: ci

  on:
    push:
      branches: [main, master]
    pull_request:
      branches: [main, master]
    workflow_dispatch:

  concurrency:
    group: ci-${{ github.workflow }}-${{ github.ref }}
    cancel-in-progress: true

  permissions:
    contents: read

  jobs:
    lint:
      name: Lint
      runs-on: ubuntu-latest
      timeout-minutes: 10
      steps:
        - uses: actions/checkout@v4
        - uses: asdf-vm/actions/install@v3
        - name: Run linters
          run: npm run lint  # adapt to ecosystem

    test:
      name: Test
      runs-on: ubuntu-latest
      timeout-minutes: 20
      needs: lint
      steps:
        - uses: actions/checkout@v4
        - uses: asdf-vm/actions/install@v3
        - name: Install dependencies
          run: npm ci
        - name: Run tests
          run: npm test

    security:
      name: Security Scan
      runs-on: ubuntu-latest
      timeout-minutes: 10
      needs: lint
      steps:
        - uses: actions/checkout@v4
        - uses: asdf-vm/actions/install@v3
        - name: Install dependencies
          run: npm ci
        - name: Dependency audit
          run: npm audit --audit-level=high

    build:
      name: Build
      runs-on: ubuntu-latest
      timeout-minutes: 15
      needs: [test, security]
      steps:
        - uses: actions/checkout@v4
        - uses: asdf-vm/actions/install@v3
        - name: Install dependencies
          run: npm ci
        - name: Build
          run: npm run build
  ```
- Adapt the template to the project's ecosystem — the stage order and principles stay the same
- Never allow CI to pass with test failures, linter warnings treated as errors, or unresolved high/critical vulnerabilities

### CI best practices
- Pin action versions to a major tag (e.g. `actions/checkout@v4`), not `@main` or `@latest`
- Set `timeout-minutes` on every job to prevent runaway builds
- Use `concurrency` with `cancel-in-progress: true` to avoid wasting resources on superseded commits
- Cache dependencies (node_modules, .m2, .gradle) to speed up builds — but never cache build outputs that should be reproduced from source
- Store test reports and coverage artifacts using `actions/upload-artifact` for post-mortem debugging
- CI secrets (API keys, deploy tokens) must be stored in GitHub Actions secrets — never in the workflow file

## Runtime Versions (asdf)
- Every project must have a `.tool-versions` file at the repository root committing the exact runtime versions used
- `.tool-versions` must be committed to the repository and kept in sync with CI — never left as a local-only file
- asdf resolves versions by climbing the directory tree from `$PWD` up to `$HOME` — the project-level `.tool-versions` always takes precedence over any global default
- Add new runtimes to `.tool-versions` whenever a new language or tool is introduced; never rely on whatever version happens to be installed globally
- When upgrading a runtime version, update `.tool-versions`, run `asdf install`, verify tests pass, then commit both the file and any lockfile changes in the same commit

### Setting versions
- Use `asdf set` to pin a version in the current project directory — this writes to `$PWD/.tool-versions`:
  ```sh
  asdf set nodejs 22.3.0
  asdf set java temurin-21.0.3+9
  asdf set python 3.12.4
  ```
- Use `asdf set -u` only to set a user-wide default in `$HOME/.tool-versions` — never use this as a substitute for a project-level `.tool-versions`
- Never edit `.tool-versions` by hand — always use `asdf set` to avoid malformed entries
- After setting versions, run `asdf install` to download and activate them:
  ```sh
  asdf install          # installs all tools listed in .tool-versions
  ```
- Run `asdf current` at any time to verify which versions are active in the current directory and catch missing or mismatched entries before they cause CI failures

### .tool-versions format
  ```
  nodejs 22.3.0
  java temurin-21.0.3+9
  python 3.12.4
  ```
- Use the exact version string produced by `asdf list all <plugin>` — no ranges, no `latest`
- `.tool-versions` is the single source of truth for runtime versions — `setup.sh`, CI pipelines, and Dockerfiles must all derive their versions from it via `asdf install`, never hardcode versions independently

## Task Management
- For every non-trivial task: create a Linear issue before starting (workspace: lucasheartcliff, team: LUC)
- Break large tasks into sub-issues if 3+ steps are involved
- Reference the Linear issue identifier in every commit message (e.g. `LUC-42`)
- Update issue status as you progress: In Progress → In Review → Done
- Never start non-trivial work without a linked Linear issue
- Project default: use HIVE for AI agent work, Sylvain Noir Bot for bot-related work

## What NOT to Do
- Never modify .env or secrets files
- Never run destructive DB operations (DROP, DELETE without WHERE) without explicit confirmation
- Never push to remote branches without being asked
- Don't add comments that just restate what the code does
- Don't use tasks/todo.md for task tracking — use Linear

## Language-specific
- @~/.claude/docs/java.md
- @~/.claude/docs/typescript.md
