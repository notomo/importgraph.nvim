return function(path, working_dir)
  if not vim.endswith(path, ".lua") then
    return nil
  end

  local relative = path:sub(#working_dir + 1)
  relative = relative:gsub("/", ".")
  relative = relative:gsub(".lua$", "")
  relative = relative:gsub(".init$", "")
  relative = relative:gsub("^lua.", "")
  return relative
end
