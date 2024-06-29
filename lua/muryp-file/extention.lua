return function()
  local isTelescope, plug = pcall(require, 'telescope.builtin')
  if isTelescope then
    local api = require 'muryp-file'
    plug.npm_workspace = api.getWorkspace
  end
end
