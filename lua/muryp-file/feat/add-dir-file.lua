local picker = require 'muryp-file.utils.picker'

local function addFolderFile(path)
  if string.match(path, '%.%w+$') then
    local PATH = string.gsub(path, '(.*)/', '%1')
    vim.fn.system('mkdir -p ' .. PATH)
    vim.fn.system('touch ' .. path)
    vim.cmd('e ' .. path)
    print('success : ' .. path)
  else
    vim.fn.system('mkdir -p ' .. path)
    vim.cmd('cd ' .. path)
    print('your directory now : ' .. path)
  end
end

return function()
  local LIST_FOLDER = require 'muryp-file.utils.getFolderList'()
  local function callBack(UserSelect)
    local pathOpts = ''
    if type(UserSelect) == 'string' then
      pathOpts = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        pathOpts = USER_SELECT
      end
    end
    local PATH = pathOpts
    local userInput = vim.fn.input 'input your path/file: '
    local haveSlash = string.match(userInput, '^/$')
    if haveSlash == nil then
      userInput = '/' .. userInput
    end
    addFolderFile(PATH .. userInput)
  end
  picker {
    callBack = callBack,
    opts = LIST_FOLDER,
    title = 'choose which folder you want to add',
  }
end
