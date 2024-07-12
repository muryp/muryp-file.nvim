local picker = require 'muryp-file.utils.picker'

---TODO: ADD,REMOVE BOOKMARK
return function()
  local PATH = _G.MURYP_FILE.LIST_PROJECT or os.getenv 'HOME' .. '/.muryp/LIST_PROJECT'
  local GET_LIST_WORKSPACE = vim.fn.system('cat ' .. PATH)
  local LIST_WORKSPACE = vim.fn.split(GET_LIST_WORKSPACE, '\n')
  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = string.gsub(goTO, '.*=>', '')
    vim.cmd('cd ' .. result)
    print('your in path: ' .. result)
  end

  picker {
    opts = LIST_WORKSPACE,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end
