## Install and configs
```lua
{
  'muryp/muryp-file',
  keys = {
    { "fw", ":Telescope npm_workspace<cr>", desc = "NPM_WORKSPACE" },
  },
  config=function()
    require('muryp-file.extention')()
  end
}
```
## how use
- after use npm_workspace, enter to goto workspace