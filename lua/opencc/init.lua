local M = {}

M.format = function(conversion)
  local buffer = vim.api.nvim_get_current_buf()

  local fullpath = vim.api.nvim_buf_get_name(buffer)

  local split_fullpath = vim.split(fullpath, '/')
  local temp_filename = string.format('%s_%d_%s', '~opencc',
                                      math.random(1, 1000000),
                                      split_fullpath[#split_fullpath])

  split_fullpath[#split_fullpath] = nil
  local temp_parents = table.concat(split_fullpath, '/')
  if temp_parents == '' then
    temp_parents = '.'
  end
  local temp_fullpath = temp_parents .. '/' .. temp_filename

  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
  local temp_io = io.open(temp_fullpath, 'w+')
  for _, line in pairs(lines) do
    temp_io:write(line)
    temp_io:write('\n')
  end
  temp_io:flush()
  temp_io:close()

  os.execute('opencc -c ' .. conversion .. ' -i ' .. temp_fullpath .. ' -o ' ..
                 temp_fullpath)

  local converted_io = io.open(temp_fullpath, 'r')
  local converted_lines = {}
  for line in converted_io:lines() do
    table.insert(converted_lines, line)
  end
  converted_io:close()
  os.remove(temp_fullpath)

  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, converted_lines)
end

M.make_commands = function()
  vim.cmd [[command! OpenCChk2s  lua require('opencc').format('hk2s')]]
  vim.cmd [[command! OpenCCjp2t  lua require('opencc').format('jp2t')]]
  vim.cmd [[command! OpenCCs2hk  lua require('opencc').format('s2hk')]]
  vim.cmd [[command! OpenCCs2t   lua require('opencc').format('s2t')]]
  vim.cmd [[command! OpenCCs2tw  lua require('opencc').format('s2tw')]]
  vim.cmd [[command! OpenCCt2hk  lua require('opencc').format('t2hk')]]
  vim.cmd [[command! OpenCCt2jp  lua require('opencc').format('t2jp')]]
  vim.cmd [[command! OpenCCt2s   lua require('opencc').format('t2s')]]
  vim.cmd [[command! OpenCCtw2s  lua require('opencc').format('tw2s')]]
  vim.cmd [[command! OpenCCtw2t  lua require('opencc').format('tw2t')]]
end

M.setup = function(config)
  M.config = config

  M.make_commands()
end

return M
