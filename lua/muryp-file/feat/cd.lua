local picker = require 'muryp-file.utils.picker'

---TODO: ADD,REMOVE BOOKMARK
local function cd()
  local LIST_DIR = vim.fn.system 'find . -maxdepth 1 -type d,l -name "*" -print'
  LIST_DIR = vim.fn.split(LIST_DIR, '\n')
  table.insert(LIST_DIR, '..')
  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = goTO
    vim.cmd('cd ' .. result)
    if result ~= '.' then
      return cd()
    end
    print('your directory now : ' .. result)
  end

  picker {
    opts = LIST_DIR,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end
local function CD()
  local ignore_patterns = {}

  -- 1. Baca .gitignore secara manual
  local f = io.open('.gitignore', 'r')
  if f then
    for line in f:lines() do
      -- Abaikan baris kosong, komentar, atau baris yang hanya berisi spasi
      if line ~= '' and not line:match '^%s*#' then
        -- Bersihkan '/' di awal dan akhir
        local pattern = line:gsub('^%s*', ''):gsub('%s*$', ''):gsub('^/', ''):gsub('/$', '')
        if pattern ~= '' then
          table.insert(ignore_patterns, pattern)
        end
      end
    end
    f:close()
  end

  -- 2. Bangun argumen exclude untuk find
  local exclude_args = ' -not -path "*/.git/*" -not -path "./.git"'
  for _, p in ipairs(ignore_patterns) do
    exclude_args = exclude_args .. ' -not -path "*/' .. p .. '/*" -not -path "./' .. p .. '"'
  end

  -- 3. Eksekusi dengan vim.fn.system
  local cmd = 'find . -type d,l' .. exclude_args .. ' -print'
  local raw_output = vim.fn.system(cmd)

  -- 4. Split untuk membersihkan baris kosong, lalu join kembali dengan \n
  local folder_list = vim.split(raw_output, '\n', { trimempty = true })
  print(vim.inspect(folder_list))

  local function callBack(UserSelect)
    local goTO = ''
    if type(UserSelect) == 'string' then
      goTO = UserSelect
    else
      for _, USER_SELECT in pairs(UserSelect) do
        goTO = USER_SELECT
      end
    end
    local result = goTO
    vim.cmd('cd ' .. result)
    print('your directory now : ' .. result)
  end
  picker {
    opts = folder_list,
    callBack = callBack,
    PREVIEW_OPTS = 'GH_ISSUE',
    title = 'choose your issue',
  }
end

return { cd = cd, CD = CD }
