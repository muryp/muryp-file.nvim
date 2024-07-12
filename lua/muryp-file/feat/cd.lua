local picker = require 'muryp-file.utils.picker'

---TODO: ADD,REMOVE BOOKMARK
local function cd()
  local LIST_PATH = vim.fn.system 'find . -maxdepth 1 -type d,l -name "*" -print'
  LIST_PATH = vim.fn.split(LIST_PATH, '\n')
  table.insert(LIST_PATH, '..')
  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = goTO
    vim.cmd('cd ' .. result)
    if result ~= '.' then
      return cd()
    end
    print('your in path: ' .. result)
  end

  picker {
    opts = LIST_PATH,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end

return cd
