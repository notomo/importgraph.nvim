local M = {}
M.__index = M

local unescape = function(s)
  s = s:gsub([[\\]], [[\]])
  return s
end

local escape = function(s)
  s = s:gsub([[\]], [[\\]])
  return s
end

local language_to_patterns = {
  lua = {
    { head = "'", tail = "'", adjust = unescape },
    { head = '"', tail = '"', adjust = unescape },
    { head = "%[=*%[", tail = "%]=*%]" },
  },
  go = {
    { head = '"', tail = '"' },
    { head = "`", tail = "`", adjust = escape },
  },
  javascript = {
    { head = '"', tail = '"' },
    { head = "'", tail = "'" },
    { head = "`", tail = "`" },
  },
}
language_to_patterns.typescript = language_to_patterns.javascript

function M.new(language)
  vim.validate({ language = { language, "string" } })

  local patterns = language_to_patterns[language]
  if not patterns then
    error(("no unwrapper for `%s`"):format(language))
  end

  local tbl = {
    _patterns = vim
      .iter(patterns)
      :map(function(e)
        local adjust = e.adjust or function(s)
          return s
        end
        return { head = "^" .. e.head, tail = e.tail .. "$", adjust = adjust }
      end)
      :totable(),
  }
  return setmetatable(tbl, M)
end

function M.unwrap(self, str)
  for _, pattern in ipairs(self._patterns) do
    local remove_head, count = str:gsub(pattern.head, "")
    if count > 0 then
      local result = remove_head:gsub(pattern.tail, "")
      return pattern.adjust(result)
    end
  end
  return str
end

return M
