local picker = require 'muryp-file.utils.picker'

---TODO: ADD,REMOVE BOOKMARK
local function cd()
  local LIST_DIR = vim.fn.system 'find . -maxdepth 1 -type d,l -name "*" -print'
  LIST_DIR = vim.fn.split(LIST_DIR, '\n')
  table.insert(LIST_DIR, '..')
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
    print('your directory now : ' .. result)
  end

  picker {
    opts = LIST_DIR,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end

return cd
