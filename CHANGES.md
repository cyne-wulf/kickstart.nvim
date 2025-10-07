# Recent Changes

- Added `after/ftplugin/sql.lua` and `after/ftplugin/psql.lua` so SQL buffers default to pgsql dialect, set the dadbod omnifunc, and let psql files opt into completions automatically.
- Introduced `lua/custom/blink/dadbod.lua` and pointed Blink at it to enable vim-dadbod-completion for Postgres-oriented filetypes while preserving buffer and lazydev sources.
- Expanded Treesitter’s `ensure_installed` list in `lua/kickstart/plugins/treesitter.lua` to include SQL and supporting formats (dockerfile, json, toml, yaml).
- Updated `lua/kickstart/plugins/blink-cmp.lua` to register the custom dadbod provider, add buffer fallback, and recognise psql filetypes.

> Tip: the repository is already a git repo (`git status` works), so you can restore the previous state with `git restore` or `git reset --hard` if needed.
