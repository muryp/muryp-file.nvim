return function()
  local isTelescope, plug = pcall(require, 'telescope.builtin')
  if isTelescope then
    local api = require 'muryp-file'
    plug.npm_workspace = api.npm_workspace
    plug.muryp_dir_bookmark = api.folder_bookmark
    plug.muryp_cd = api.cd
    plug.muryp_CD = api.CD
    plug.addDirFile = require 'muryp-file.feat.add-dir-file'
  end
end