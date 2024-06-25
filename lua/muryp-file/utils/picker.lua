---@param Arg {callBack:function,opts:string[],PREVIEW_OPTS?:'GH_ISSUE'|'FILE',title:string,CACHE_DIR?:string}
---@return nil : Telescope custom list
return function(Arg)
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local actions = require 'telescope.actions'
  local conf = require('telescope.config').values
  local action_state = require 'telescope.actions.state'
  local callBack = Arg.callBack ---if user select/enter
  local Opts = Arg.opts ---list opts for choose
  local TITLE = Arg.title ---title for telescope
  pickers
    .new({}, {
      prompt_title = TITLE,
      finder = finders.new_table {
        results = Opts,
      },
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local MultiSelect = action_state.get_current_picker(prompt_bufnr)._multi._entries
          actions.close(prompt_bufnr)
          local UserSelect = {}
          local TABLE_LENG = 0
          for key, _ in pairs(MultiSelect) do
            table.insert(UserSelect, key[1])
            TABLE_LENG = TABLE_LENG + 1
          end
          ---@return string|string[]
          local singleSelect = function()
            if TABLE_LENG == 0 then
              return action_state.get_selected_entry()[1]
            end
            return UserSelect
          end
          callBack(singleSelect())
        end)
        -- keep default keybindings
        return true
      end,
      sorter = conf.generic_sorter {},
    })
    :find()
end
