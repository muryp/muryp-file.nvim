local picker = require 'muryp-file.utils.picker'

---TODO: ADD,REMOVE BOOKMARK
return function()
  local DIR = _G.MURYP_FILE.LIST_PROJECT
  local GET_LIST_WORKSPACE = vim.fn.system('cat ' .. DIR)
  local PATH_HOME = vim.env.HOME .. '/'
  local LIST_WORKSPACE = vim.fn.split(GET_LIST_WORKSPACE:gsub(PATH_HOME, ''), '\n')
  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = string.gsub(goTO, '.*=> ', '')
    vim.cmd('cd ' .. PATH_HOME .. result)
    vim.cmd 'Telescope muryp_cd'
  end

  picker {
    opts = LIST_WORKSPACE,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end
