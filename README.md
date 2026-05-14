# Financial Market Personal

Personal workspace for financial market experiments and supporting applications.

## Repository Layout

- `laravel/`: Laravel backend kept as a Git submodule from `https://github.com/joaocg/financial-market-personal-back.git`.
- `waha/`: WAHA service kept as a Git submodule.
- `mobile/`: Flutter mobile application.
- `docker/`: Local Docker services used by the workspace.
- `specs/`: Feature specifications and implementation planning artifacts.
- `docs/`: Project documentation and BMAD artifacts.

## Git Structure

This repository is organized as a workspace. The Laravel backend and WAHA service
are referenced through submodules, while project-owned workspace files and the
Flutter app live directly in this repository.

After cloning, initialize submodules with:

```bash
git submodule update --init --recursive
```

## Local Development

Use each subproject's own README for setup details:

- `laravel/README.md`
- `waha/README.md`
- `mobile/README.md`
