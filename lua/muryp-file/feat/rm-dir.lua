local picker = require 'muryp-file.utils.picker'

return function()
  local TEMP_LIST_BOOKMARK = vim.fn.system('cat ' .. _G.MURYP_FILE.LIST_PROJECT)
  local LIST_BOOKMARK = vim.split(TEMP_LIST_BOOKMARK, '\n')
  local function callBack(UserSelect)
    local LIST_DELETED ---@type string
    if type(UserSelect) == 'string' then
      local DELETE_DIR = string.gsub(TEMP_LIST_BOOKMARK, UserSelect .. '\n', '')
      vim.fn.system('echo "' .. DELETE_DIR .. '" > ' .. _G.MURYP_FILE.LIST_PROJECT)
    else
      for _, USER_SELECT in pairs(UserSelect) do
        local DELETE_DIR = string.gsub(TEMP_LIST_BOOKMARK, USER_SELECT .. '\n', '')
        vim.fn.system('echo "' .. DELETE_DIR .. '" > ' .. _G.MURYP_FILE.LIST_PROJECT)
        LIST_DELETED = LIST_DELETED .. '\n' .. USER_SELECT
      end
    end
    print('success delete :\n' .. LIST_DELETED)
  end
  picker {
    opts = LIST_BOOKMARK,
    callBack = callBack,
    title = 'choose your bookmark want to delete',
  }
end
