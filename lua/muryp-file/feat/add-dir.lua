return function()
  local CWD = vim.fn.getcwd()
  local NAME_DIR = vim.fn.input 'input your path: '
  vim.fn.system('echo "' .. NAME_DIR .. ' => ' .. CWD .. '" >> ' .. _G.MURYP_FILE.LIST_PROJECT)
end
