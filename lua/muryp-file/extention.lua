return function()
  local isTelescope, plug = pcall(require, 'telescope.builtin')
  if isTelescope then
    local api = require 'muryp-file'
    plug.npm_workspace = api.npm_workspace
    plug.muryp_folder_bookmark = api.folder_bookmark
    plug.muryp_cd = api.cd
  end
end
