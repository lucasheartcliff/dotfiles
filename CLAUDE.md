# Claude Code Guidelines

## asdf Version Management
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
