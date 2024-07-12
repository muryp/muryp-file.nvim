local picker = require 'muryp-file.utils.picker'
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
  local getHomePath = vim.fn.expand '~' .. '$'
  if string.match(PWD, getHomePath) then
    return
  end
  local isMatch = true
  for i = 1, #RgFileMatch do
    local checkFile = vim.fn.glob(PWD .. '/' .. RgFileMatch[i])
    if checkFile == '' then
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

---@param OBJ_NAME string
---@param FILE string
---@param rootPathWorkspace string
M.gotoFolder = function(OBJ_NAME, FILE, rootPathWorkspace)
  local CMD = 'yq "((.'
    .. OBJ_NAME
    .. '[]) |= \\"'
    .. rootPathWorkspace
    .. '/\\" + . +\\"/\\") | .'
    .. OBJ_NAME
    .. '[]" '
    .. FILE
    .. ' -o yaml'
  local getWorksSpaceConf = vim.fn.system(CMD) ---@type string --- yaml
  ---@type string --- yaml
  local getWorksSpaceList = vim.fn.system('ls -d ' .. string.gsub(getWorksSpaceConf, '\n', ' '))
  local ListWorkSpace = {} ---@type string[]
  for word in string.gmatch(getWorksSpaceList, '([^%s]+)') do
    local simplifyPath = string.gsub(word, rootPathWorkspace, '')
    table.insert(ListWorkSpace, simplifyPath)
  end
  ---@param UserSelect string|string[]
  ---@return nil
  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = rootPathWorkspace .. goTO
    vim.cmd('cd ' .. result)
    print('your in path: ' .. result)
  end
  picker {
    opts = ListWorkSpace,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end
M.getWorkspace = function()
  local getRootPathPnpm = M.findup { 'pnpm-workspace.yaml', '.git' }
  local getRootPathNpm = M.findup { 'package.json', '.git' }

  if getRootPathPnpm then
    local FILE = getRootPathPnpm .. '/pnpm-workspace.yaml'
    M.gotoFolder('packages', FILE, getRootPathPnpm)
    return
  end
  if getRootPathNpm then
    local FILE = getRootPathNpm .. '/package.json'
    M.gotoFolder('workspaces', FILE, getRootPathNpm)
    return
  end
  print 'no pnpm-workspace.yaml or package.json'
end
return M
