## Install and configs

```lua
{
  'muryp/muryp-file',
  keys = {
    {
      '<leader>da',
      function()
        require('muryp-file').addDir()
      end,
      desc = 'ADD_DIR_BOOKMARK',
    },
    { 'fd', ':Telescope muryp_cd<CR>', 'CD' },
    { 'fwb', ':Telescope muryp_dir_bookmark<CR>', 'CHANGE_DIR_BOOKMARK' },
    { 'fwn', ':Telescope npm_workspace<cr>', desc = 'NPM_WORKSPACE' },
  },
  config = function()
    require('muryp-file').setup {
      LIST_PROJECT = 'location/file/for/safe/bookmark',
    }
  end,
}
```

## how use

- `fd` for change directory
- `fwb` for go to dir bookmark
- `fwn` for go to npm workspace
- `<leader>da` for add dir bookmark