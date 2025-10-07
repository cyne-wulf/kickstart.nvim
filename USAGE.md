# Usage Guide

## Table of Contents

- [Overview](#overview)
- [Docker-Based Postgres Workflow](#docker-based-postgres-workflow)
  - [1. Start the Database Container](#1-start-the-database-container)
  - [2. Expose a Connection DSN](#2-expose-a-connection-dsn)
  - [3. Launch Neovim with Dadbod Ready](#3-launch-neovim-with-dadbod-ready)
  - [4. Working Inside SQL Buffers](#4-working-inside-sql-buffers)
  - [5. Troubleshooting](#5-troubleshooting)
- [Key Features in This Config](#key-features-in-this-config)
- [Daily Workflow Cheatsheet](#daily-workflow-cheatsheet)
- [Maintaining This Repository](#maintaining-this-repository)
- [Additional Tips](#additional-tips)

---

## Overview

This Neovim setup extends the stock kickstart configuration with database tooling
for PostgreSQL, blink.cmp autocompletion, and Treesitter language support.
`USAGE.md` highlights the bits you need to be productive without replacing the
canonical `README.md` shipped with kickstart-modular.nvim.

> **What changed?**
>
> - Blink now queries dadbod for Postgres-aware completions.
> - SQL buffers default to the `pgsql` dialect and use the dadbod omnifunc.
> - Treesitter automatically installs the `sql` parser (plus Docker/TOML/YAML/JSON) for better highlighting.

Keep reading if your workflow relies on Dockerized Postgres or you want to know
how the pieces fit together.

---

## Docker-Based Postgres Workflow

These steps assume you have Docker Desktop (or CLI) installed and the Postgres
image available. Replace container names/ports/credentials to match your setup.

### 1. Start the Database Container

```bash
# Example: run Postgres 16 in the background
# Exposes port 5432 and stores data in ./tmp/db
mkdir -p tmp/db

docker run -d \
  --name dev-postgres \
  -e POSTGRES_USER=app \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=app_db \
  -p 5432:5432 \
  -v "$(pwd)/tmp/db:/var/lib/postgresql/data" \
  postgres:16
```

> **Tip:** `docker logs -f dev-postgres` confirms when Postgres is ready.

### 2. Expose a Connection DSN

Dadbod, Blink, and Neovim use a DSN (Data Source Name) to talk to Postgres.
Set one of the following before starting Neovim:

```bash
# Option A: export globally for your shell session
export DATABASE_URL="postgresql://app:secret@localhost:5432/app_db"

# Option B: stash it in an .env file and load with direnv or similar
cat <<'ENV' > .env
DATABASE_URL=postgresql://app:secret@localhost:5432/app_db
ENV
```

If you use `kristijanhusak/vim-dadbod-ui`, you may also define
`DB_UI_*` variables or entries in `vim.g.dbs`. The config now defaults to the
pgsql dialect but **never overwrites your existing credentials**.

### 3. Launch Neovim with Dadbod Ready

```bash
# From your project root
nvim query.sql
```

When Neovim opens a `.sql` buffer it will:

- Set `vim.bo.omnifunc = 'vim_dadbod_completion#omni'`
- Default `vim.b.sql_type = 'pgsql'`
- Enable Blink’s dadbod source if the filetype is `sql`, `psql`, or any `sql.*`
  variant

The first time, run:

```vim
:TSUpdate sql
```

to download the Treesitter parser.

### 4. Working Inside SQL Buffers

| Action | Key | Notes |
| --- | --- | --- |
| Trigger completion | `<C-Space>` or type `schema.` | Blink shows dadbod suggestions immediately |
| Execute current query with dadbod-ui | `:w` | Saves & runs the buffer against the active connection |
| Toggle DB drawer | `<leader>db` | Provided by `vim-dadbod-ui` |
| Open docs/help | `<space>sh` | Telescope help shortcut from kickstart |

Blink will mix dadbod results with LSP/path/snippet suggestions. The dadbod items
are boosted so table/column names appear at the top.

### 5. Troubleshooting

> **No completions?**
> - Ensure the buffer filetype is `sql` or `psql` (`:set ft?`).
> - Verify `:echo &omnifunc` returns `vim_dadbod_completion#omni`.
> - Check `:echo $DATABASE_URL` from inside Neovim.
> - Run `:messages` for dadbod status logs.
>
> **Treesitter queries missing?**
> - Run `:TSInstall sql` or `:TSUpdate sql`.
>
> **Docker connectivity issues?**
> - Confirm the container port (`5432`) matches the DSN.
> - Run `psql "$DATABASE_URL"` from the shell to confirm connectivity before opening Neovim.

---

## Key Features in This Config

| Feature | Description | File(s) |
| --- | --- | --- |
| Blink + Dadbod | Custom provider to enable Postgres completions | `lua/custom/blink/dadbod.lua`, `lua/kickstart/plugins/blink-cmp.lua` |
| SQL buffer defaults | Sets pgsql dialect, omnifunc, tidy indent | `after/ftplugin/sql.lua`, `after/ftplugin/psql.lua` |
| Treesitter languages | Ensures SQL, Dockerfile, JSON, TOML, YAML | `lua/kickstart/plugins/treesitter.lua` |
| Dadbod UI bindings | Toggle UI with `<leader>db` | `lua/custom/plugins/database.lua` |
| Lazy-managed plugins | Kickstart + modular overrides | `lua/lazy-plugins.lua`, `lua/custom/plugins/*.lua` |

---

## Daily Workflow Cheatsheet

```mermaid
flowchart TD
  A[Start Docker container] --> B[Export DATABASE_URL]
  B --> C[Launch nvim query.sql]
  C --> D{Write query}
  D --> |Completion| E[Blink + Dadbod suggests tables/columns]
  D --> |Execute| F[:w to run via dadbod-ui]
  F --> G[Inspect results in dbout buffer]
```

- **Completion refresh**: Blink handles refresh automatically when you type `.`,
  `"` or `` ` ``.
- **DB drawer**: Use the dadbod UI to browse schemas, run helpers (indexes,
  primary keys, etc.), and manage saved queries.
- **Multiple configs**: Use `NVIM_APPNAME` per project if you want a clean slate:

  ```bash
  NVIM_APPNAME=nvim-db nvim
  ```

---

## Maintaining This Repository

Keeping the configuration healthy is straightforward:

1. **Track upstream**: Periodically pull from the kickstart-modular upstream if you forked it.
2. **Lazy updates**: Run `:Lazy sync` or `:Lazy update` after backing up `lazy-lock.json`.
3. **Treesitter hygiene**: Run `:TSUpdate` monthly to refresh parsers.
4. **Database secrets**: Store credentials in env files or direnv; never commit them.
5. **Git hygiene**:
   - Stage intentional changes with `git add -p`.
   - Use feature branches for bigger tweaks.
   - Regenerate `USAGE.md` and `CHANGES.md` whenever you modify workflows.
6. **Regression checks**:
   - Open a `.sql` buffer and verify completions.
   - Launch `:DBUI` and list tables.
   - Confirm `:checkhealth` reports no failing checks.

Consider adding automated linting (e.g., via `stylua`) or tests if the config grows.

---

## Additional Tips

- **Blink configuration reference**: `:help blink.cmp-config`.
- **Dadbod documentation**: `:help vim-dadbod-completion` and `:help dadbod-ui`.
- **SQL formatting**: Install `pg_format` or `sqlfluff` and add them to Conform’s `formatters_by_ft`.
- **Direnv**: Pair with `direnv allow` to automatically load DSNs per project.
- **Neovim updates**: Always read `:help news` after upgrading to catch breaking changes.

Happy querying! 🎯
