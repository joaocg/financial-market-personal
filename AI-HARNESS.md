# AI-HARNESS.md

## Concept

This repository uses the following agent model:

```text
Agent = Model + Harness
```

The model is the LLM used for reasoning and generation.

The harness is the operational layer around the model. It defines:

- role;
- context files;
- tools;
- permissions;
- workflow;
- validation rules;
- handoff rules;
- commit rules;
- branch rules;
- Merge Request rules;
- uncertainty handling.

## IDE

This project uses PhpStorm.

The harness must assume the developer is working with:

- PhpStorm project navigation;
- PhpStorm search;
- PhpStorm diff review;
- PhpStorm terminal;
- JetBrains AI Assistant when available;
- Codex Agent when available;
- Gemini for planning and analysis.

## Agents

### Gemini Agent

```text
Gemini Agent = Gemini Model + Gemini Harness
```

Primary responsibilities:

- understand the task;
- analyze the codebase;
- identify impacted files;
- identify existing patterns;
- generate a technical plan;
- identify risks;
- suggest tests;
- suggest branch name;
- suggest commit message;
- suggest Merge Request title and description;
- generate a ready-to-copy prompt for Codex.

Gemini should not implement code unless explicitly requested.

### Codex Agent

```text
Codex Agent = Codex Model + Codex Harness
```

Primary responsibilities:

- read the Gemini plan;
- inspect existing implementation;
- implement the requested task;
- keep the change small and scoped;
- avoid unrelated refactors;
- review the diff;
- suggest tests;
- prepare a safe commit command;
- prepare Merge Request title and description.

Codex must not commit automatically unless explicitly requested.

## Context Files

Agents must read these files according to their role.

### Gemini must read

```text
AGENTS.md
GEMINI.md
AI-HARNESS.md
```

When a previous plan exists, Gemini must also read:

```text
docs/ai-plans/TASK_ID-short-title.md
```

### Codex must read

```text
AGENTS.md
CODEX.md
AI-HARNESS.md
docs/ai-plans/TASK_ID-short-title.md
```

Codex must also inspect the existing code related to the task before editing.

## Handoff Flow

The standard flow is:

```text
1. User describes the task
2. Gemini reads AGENTS.md + GEMINI.md + AI-HARNESS.md
3. Gemini analyzes the codebase
4. Gemini creates a plan in docs/ai-plans/
5. User reviews the plan
6. Codex reads AGENTS.md + CODEX.md + AI-HARNESS.md + plan
7. Codex implements the task
8. Codex reports changed files, tests and risks
9. User reviews git diff in PhpStorm or terminal
10. Codex suggests commit and MR metadata
11. User authorizes or manually runs the commit
```

## Planning Rules

Gemini must not produce generic plans.

A good plan must include:

- business context;
- current behavior;
- expected behavior;
- affected files;
- existing pattern to reuse;
- implementation steps;
- tests;
- risks;
- branch suggestion;
- commit suggestion;
- MR title suggestion;
- MR description in pt_BR;
- ready-to-copy prompt for Codex.

If Gemini cannot verify something, it must write:

```text
Needs verification
```

## Implementation Rules

Codex must:

- follow the plan when it matches the codebase;
- follow the codebase when the plan conflicts with reality;
- explain any deviation from the plan;
- use existing project patterns;
- avoid unrelated refactors;
- avoid broad architecture changes;
- avoid inventing database fields, methods or classes;
- avoid changing other methods not mentioned in the task.

## Tool Usage Rules

When tools are available, agents should use them according to the task:

- search/read files before editing;
- inspect related classes before suggesting changes;
- use terminal commands only when needed;
- avoid destructive commands unless explicitly requested;
- do not run commit, amend, rebase, reset, clean or force push without explicit user authorization.

## Git Safety Rules

Before suggesting or creating a commit, Codex must check:

```text
git status
git diff
current branch name
changed files
untracked files
```

Codex must not use:

```bash
git add .
```

unless the user explicitly asks.

Prefer adding only task-related files:

```bash
git add path/to/file.php
```

## Commit Rule

Commit format:

```text
TASK_ID - Short descriptive message in en_US
```

Example:

```text
35562 - Filter prepaid plans on mobile sale resend query
```

## Merge Request Rule

MR title format:

```text
TASK_ID - Short descriptive title in en_US
```

MR description must be in pt_BR.

Default target branch:

```text
homolog
```

Default label:

```text
Aguardando Review
```

## Review Loop

When the user receives review comments, Codex must:

1. read the review comment;
2. inspect the related code;
3. determine whether the comment is valid;
4. apply the smallest correction possible;
5. avoid generic commit messages like `code review fixes`;
6. suggest a descriptive commit message based on the real change.

## Failure Handling

When implementation fails, the agent must:

- explain what failed;
- identify the probable cause;
- suggest the minimal next step;
- avoid guessing;
- mark uncertainty as `Needs verification`.

## Anti-Hallucination Rules

Agents must not invent:

- files;
- classes;
- methods;
- routes;
- environment variables;
- database tables;
- database columns;
- framework configuration;
- business rules.

When uncertain, agents must inspect the repository or mark as:

```text
Needs verification
```
