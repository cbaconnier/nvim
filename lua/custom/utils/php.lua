local M = {}

-- Generate PHP namespace from file path (without filename)
M.get_php_namespace = function()
  local file_path = vim.fn.expand "%:p"
  local file_dir = vim.fn.fnamemodify(file_path, ":h") -- Get directory without filename
  local project_root = vim.fn.getcwd()

  -- Ensure project_root ends with a slash
  if project_root:sub(-1) ~= "/" then
    project_root = project_root .. "/"
  end

  -- Escape special pattern characters in project_root
  -- Eg.: /home/user/my-projects/ will be replaced with /home/user/my%-projects/
  local escaped_root = project_root:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")

  -- vim.notify("escaped_root:  " .. escaped_root, vim.log.levels.INFO)

  -- Remove project root from directory path
  local namespace_path = file_dir:gsub(escaped_root, "")

  -- Convert path to namespace
  if namespace_path:match "^app/" then
    namespace_path = namespace_path:gsub("^app/", "App\\")
  elseif namespace_path:match "^tests/" then
    namespace_path = namespace_path:gsub("^tests/", "Tests\\")
  end

  namespace_path = namespace_path:gsub("/", "\\")

  -- Add semicolon
  namespace_path = namespace_path .. ";"

  return namespace_path
end

-- Get class name from filename
M.get_php_class_name = function()
  -- Get filename without extension
  local filename = vim.fn.expand "%:t:r"
  return filename
end

return M
