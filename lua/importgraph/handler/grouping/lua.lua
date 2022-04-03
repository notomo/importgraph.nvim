return function(path, working_dir)
  local relative = path:sub(#working_dir + 1)
  relative = relative:gsub("/", ".")
  relative = relative:gsub(".lua$", "")
  relative = relative:gsub(".init$", "")
  return relative
end
