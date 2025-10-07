-- Extend dadbod completion so blink also triggers for Postgres-flavoured SQL buffers
local provider = require('vim_dadbod_completion.blink')

local supported = {
  sql = true,
  mysql = true,
  plsql = true,
  psql = true,
  ['sql.postgres'] = true,
}

function provider:enabled()
  local ft = vim.bo.filetype
  if supported[ft] then
    return true
  end

  if type(ft) == 'string' and ft:match('^sql%.') then
    return true
  end

  if ft == 'sql' then
    local dialect = (vim.b.sql_type or vim.g.sql_type_default or ''):lower()
    if dialect == 'pgsql' or dialect == 'postgres' or dialect == 'postgresql' then
      return true
    end
  end

  if vim.b.enable_dadbod_completion == true then
    return true
  end

  return false
end

return provider
