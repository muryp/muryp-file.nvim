--- TODO: findup package.json and .git or pnpm-workspaces.yaml and .git
--- TODO: get json pnpm-workspaces.yaml to table
--- TODO: if pnpm-workspaces.yaml not exist, use package.json
--- TODO: if package.json not exist, print dont have workspaces

local M = {}
--- find up file
--- @param PWD string|nil --- current path
--- @param RgFileMatch string[] --- file name
--- @return string|nil
M.findup = function(RgFileMatch, PWD)
  if type(RgFileMatch) ~= 'table' then
    return
  end
  PWD = PWD or vim.fn.getcwd()
  local getHomePath = vim.fn.expand '~'
  if string.match(PWD, getHomePath) then
    return
  end
  local isMatch = true
  for i = 1, #RgFileMatch do
    if not string.find(PWD, '/' .. RgFileMatch[i] .. '$') then
      isMatch = false
      break
    end
  end
  if isMatch == false then
    PWD = string.gsub(PWD, '(.*)/..*', '%1')
    return M.findup(RgFileMatch, PWD)
  end
  return PWD
end
M.getWorkspace = function()
  local getPathPnpm = M.findup { 'pnpm-workspaces.yaml', '.git' }
  local getPathNpm = M.findup { 'package.json', '.git' }

  if getPathPnpm then
    local PWD = getPathPnpm .. '/pnpm-workspaces.yaml'
    local getWorksSpaceList = vim.fn.system 'yq "((.packages[]) |= \\"'
      .. PWD
      .. '/\\" + . +\\"/\\") | .packages[]" '
      .. PWD
      .. '/pnpm-workspaces.yaml -o json' ---@type string --- JSON
    local ListWorkSpace = vim.fn.json_decode(getWorksSpaceList)
    print(vim.inspect(ListWorkSpace))
  end
  if getPathNpm then
    local getWorksSpaceList = vim.fn.system 'cat ' .. getPathNpm .. '/package.json' ---@type string -- JSON
    local ListWorkSpace = vim.fn.json_decode(getWorksSpaceList)
    print(vim.inspect(ListWorkSpace))
  end
end

M.getWorkspace()
return M
