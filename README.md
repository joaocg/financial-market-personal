# Financial Market Personal

Personal workspace for financial market experiments and supporting applications.

## Repository Layout

- `laravel/`: Laravel backend kept in its own repository at `https://github.com/joaocg/financial-market-personal-back.git`.
- `waha/`: WAHA service kept as a Git submodule.
- `mobile/`: Flutter mobile application.
- `docker/`: Local Docker services used by the workspace.
- `specs/`: Feature specifications and implementation planning artifacts.
- `docs/`: Project documentation and BMAD artifacts.

## Git Structure

This repository is organized as a workspace. The Laravel backend has its own
repository, `waha` is referenced through a submodule, and project-owned workspace
files plus the Flutter app live directly in this repository.

After cloning, initialize submodules with:

```bash
git submodule update --init --recursive
```

## Local Development

Use each subproject's own README for setup details:

- `laravel/README.md`
- `waha/README.md`
- `mobile/README.md`
