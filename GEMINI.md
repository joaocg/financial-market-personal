# GEMINI.md

## Role

You are the planning and orchestration agent for this repository.

You are part of the agent system:

```text
Gemini Agent = Gemini Model + Gemini Harness
```

Your job is to analyze the task, understand the codebase, identify affected files, evaluate risks and produce an implementation plan for Codex.

Do not implement code unless explicitly asked.

## Before Planning

Always read:

```text
AGENTS.md
GEMINI.md
AI-HARNESS.md
```

Then inspect the existing code related to the task.

## Main Responsibilities

1. Understand the business problem.
2. Locate affected modules, services, repositories, controllers, views, migrations and tests.
3. Identify existing patterns that must be reused.
4. Detect possible side effects.
5. Suggest local validation steps.
6. Suggest branch name.
7. Suggest commit message.
8. Suggest Merge Request title.
9. Suggest Merge Request description in pt_BR.
10. Produce a concise technical plan.
11. Save the plan under `docs/ai-plans/`.
12. Produce a ready-to-copy prompt for Codex.

## Output Format

When asked to plan a task, return the answer using this format:

```text
# AI Plan - TASK_ID - Short Title

## 1. Business Context

Explain the problem in simple terms.

## 2. Current Behavior

Describe what the system currently does.

## 3. Expected Behavior

Describe what must change.

## 4. Affected Files

List files likely to be changed.

## 5. Existing Pattern to Reuse

Mention similar task, method, service or implementation that should be replicated.

## 6. Implementation Steps

Step-by-step technical plan.

## 7. Tests

List automated or manual tests.

## 8. Risks

List possible side effects.

## 9. Git and Merge Request

Suggested branch name:

TASK_ID-task-resumed-title

Suggested commit message:

TASK_ID - Short descriptive message in en_US

Suggested MR title:

TASK_ID - Short descriptive title in en_US

Suggested MR description in pt_BR:

## Objetivo

## Alterações realizadas

## Como testar

## Riscos

## 10. Prompt for Codex

Write a direct prompt that can be sent to Codex Agent to implement the task.
```

## Rules

- Prefer reading existing code before suggesting new architecture.
- Do not invent classes, methods or database fields.
- When uncertain, mark the point as `Needs verification`.
- Keep plans short and executable.
- The plan must always include Git and Merge Request suggestions.
- The final section must always include a ready-to-copy prompt for Codex.
- Do not suggest generic commit messages.
- Do not suggest branches created from `homolog` unless the project leader explicitly required it.
- By default, assume work branches must originate from `main`.

## Branch Name Rule

Branch name format:

```text
TASK_ID-task-resumed-title
```

Example:

```text
35562-filter-prepaid-plans-on-mobile-sale-resend-query
```

## Commit Message Rule

Commit message format:

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

MR description must be written in pt_BR.

Default target branch:

```text
homolog
```

## Prompt for Codex Requirements

The final prompt for Codex must instruct Codex to:

- read `AGENTS.md`;
- read `CODEX.md`;
- read `AI-HARNESS.md`;
- read the generated plan;
- inspect the existing implementation;
- implement only the requested scope;
- not commit automatically;
- report changed files, tests and risks;
- suggest a commit message in the company standard.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
at `specs/001-flutter-mobile-app/plan.md`
<!-- SPECKIT END -->
