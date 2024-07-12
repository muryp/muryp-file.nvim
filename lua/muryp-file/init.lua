local M = {}

M.npm_workspace = require('muryp-file.feat.npm-workspace').getWorkspace
M.folder_bookmark = require 'muryp-file.feat.bookmark-folder'
M.cd = require 'muryp-file.feat.cd'
_G.MURYP_FILE = {}

---@param Args {LIST_PROJECT?:string}
M.setup = function(Args)
  _G.MURYP_FILE = Args
end

return M
