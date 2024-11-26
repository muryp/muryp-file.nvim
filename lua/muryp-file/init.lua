local M = {}

M.npm_workspace = require('muryp-file.feat.goto-npm-workspace').getWorkspace
M.folder_bookmark = require 'muryp-file.feat.goto-bookmark-dir'
M.cd = require 'muryp-file.feat.cd'
M.addDir = require 'muryp-file.feat.add-dir'
M.gotoBookmark = require 'muryp-file.feat.gotoPathBookmark'

_G.MURYP_FILE = {}

--- @param Args {LIST_PROJECT?:string}|nil
function M.setup(Args)
  Args = Args or {}
  _G.MURYP_FILE.LIST_PROJECT = Args.LIST_PROJECT or os.getenv 'HOME' .. '/.muryp/LIST_PROJECT'
  require 'muryp-file.extention'() ---add telescope extention
end

return M
