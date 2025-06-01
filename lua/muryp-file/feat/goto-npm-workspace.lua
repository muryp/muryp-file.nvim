local picker = require 'muryp-file.utils.picker'
local M = {}
--- find up file
--- @param PWD string|nil --- current dir
--- @param RgFileMatch string[] --- file name
--- @return string|nil
M.findup = function(RgFileMatch, PWD)
  if type(RgFileMatch) ~= 'table' then
    return
  end
  PWD = PWD or vim.fn.getcwd()
  local getHomeDir = vim.fn.expand '~' .. '$'
  if string.match(PWD, getHomeDir) then
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

local function escape_pattern(text)
  return text:gsub("([^%w])", "%%%1")
end

---@param OBJ_NAME string
---@param FILE string
---@param rootDirWorkspace string
M.gotoFolder = function(OBJ_NAME, FILE, rootDirWorkspace)
  local CMD = 'yq "((.'
    .. OBJ_NAME
    .. '[]) |= \\"'
    .. rootDirWorkspace
    .. '/\\" + . +\\"/\\") | .'
    .. OBJ_NAME
    .. '[]" '
    .. FILE
    .. ' -o yaml'
  local getWorksSpaceConf = vim.fn.system(CMD) ---@type string --- yaml
  ---@type string --- yaml
  local getWorksSpaceList = vim.fn.system('ls -d ' .. string.gsub(getWorksSpaceConf, '\n', ' '))
  local ListWorkSpace = {} ---@type string[]
  for path in string.gmatch(getWorksSpaceList, '([^%s]+)') do
    local simplifyDir = string.gsub(path, '^'..escape_pattern(rootDirWorkspace), '')
    table.insert(ListWorkSpace, simplifyDir)
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
    local result = rootDirWorkspace .. goTO
    vim.cmd('cd ' .. result)
    print('your directory now : ' .. result)
  end
  picker {
    opts = ListWorkSpace,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end
M.getWorkspace = function()
  local getRootDirPnpm = M.findup { 'pnpm-workspace.yaml', '.git' }
  local getRootDirNpm = M.findup { 'package.json', '.git' }

  if getRootDirPnpm then
    local FILE = getRootDirPnpm .. '/pnpm-workspace.yaml'
    M.gotoFolder('packages', FILE, getRootDirPnpm)
    return
  end
  if getRootDirNpm then
    local FILE = getRootDirNpm .. '/package.json'
    M.gotoFolder('workspaces', FILE, getRootDirNpm)
    return
  end
  print 'no pnpm-workspace.yaml or package.json'
end
return M