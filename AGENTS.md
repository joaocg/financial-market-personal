# AGENTS.md

## Purpose

This file defines global rules for any AI agent working in this repository.

An agent must be treated as:

```text
Agent = Model + Harness
```

The model provides reasoning and generation.

The harness provides:

- context;
- rules;
- available tools;
- task workflow;
- validation steps;
- safety limits;
- commit standards;
- branch standards;
- Merge Request standards;
- handoff between agents.

## IDE Context

This project uses PhpStorm as the main IDE.

AI agents may be used through:

- Gemini, for planning and analysis;
- Codex, for implementation, code changes, review, commit preparation and Merge Request preparation.

## Project Language

- All file names, class names, methods, variables and database-related identifiers must be written in English.
- Explanations, task notes and business context may be written in Portuguese when needed.
- Commit messages, branch names and Merge Request titles must be written in en_US.
- Merge Request descriptions must be written in pt_BR.

## Architecture Rules

- Keep business logic out of controllers.
- Controllers must only receive requests, validate input, call services/use cases and return responses.
- Use services/use cases for business rules.
- Use repositories/models for database queries according to the existing project pattern.
- Avoid duplicated queries and duplicated business rules.
- Prefer explicit DTOs or structured arrays over passing raw request data across layers.
- Keep external integrations isolated under `services/external`, `Services/External` or the equivalent structure used by the project.
- Always read existing code before suggesting new architecture.
- Do not invent classes, methods, routes, database fields or configuration keys.

## Scope Rules

- Do not introduce broad changes outside the requested task.
- Do not rename public methods, routes or database fields unless the task explicitly requires it.
- Preserve backward compatibility when working on legacy systems.
- Do not modify generated files, vendor files, build artifacts or environment files unless explicitly requested.
- If something is uncertain, mark it as `Needs verification`.

## PhpStorm Workflow Rules

- Prefer using PhpStorm inspections, search, navigation and diff review before changing code.
- Use existing project structure and namespace conventions.
- When suggesting commands, assume they will be executed from the project root.
- Do not rely on IDE-only state; all important conclusions must be based on repository files or command output.

## Code Quality

Before finishing a task, the agent must explain:

```text
Changed files:
- ...

What changed:
- ...

How to test:
- ...

Risks:
- ...
```

## Commit Message Rules

Commit messages must follow this format:

```text
TASK_ID - Short descriptive message in en_US
```

Example:

```text
35562 - Filter prepaid plans on mobile sale resend query
```

Rules:

- `TASK_ID` must be the numeric task/card/work item identifier.
- The commit message must describe what was changed in a concise and clear way.
- Commit messages must always be written in en_US.
- Generic commit messages are not allowed.

Invalid examples:

```text
fix
ajustes
correções
ajustes de code review
update
```

## Branch Rules

Work branches must be created from `main`, unless the project leader explicitly says otherwise.

Branch names must follow this format:

```text
TASK_ID-task-resumed-title
```

Example:

```text
35562-filter-prepaid-plans-on-mobile-sale-resend-query
```

Hotfix branches must follow the same pattern and use the original task/card ID.

Example:

```text
35562-hotfix-filter-prepaid-plans-on-mobile-sale-resend-query
```

## Merge Request Rules

- The initial Merge Request target branch must be `homolog`, unless explicitly instructed otherwise.
- Do not delete the source branch after merging into `homolog`.
- The Merge Request title must be the branch name converted to a readable title.
- Replace hyphens with spaces and keep the title in en_US.
- The Merge Request description must be written in pt_BR.
- A reviewer must always be assigned.
- The label `Aguardando Review` must be added when opening the MR.
- If there is a Merge Request template, it must be filled with relevant information.
- After opening the MR, the reviewer must be notified with the MR link.
- If corrections are requested, notify the reviewer after applying the fixes.
- If rebase is required, respect the label `Necessário Rebase` and remove it only after the rebase is done.

Example branch:

```text
35562-filter-prepaid-plans-on-mobile-sale-resend-query
```

Example MR title:

```text
35562 - Filter prepaid plans on mobile sale resend query
```

## Agent Harness Rules

- Read `AI-HARNESS.md` before planning, implementing, committing or preparing Merge Requests.
- Gemini must be used primarily for planning, analysis and handoff prompts.
- Codex must be used primarily for code implementation, diff review, commit preparation and MR preparation.
- Do not skip the planning step for large or risky tasks.
- Do not let an agent commit automatically unless the user explicitly requests it.
- Prefer small, reviewable changes.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
