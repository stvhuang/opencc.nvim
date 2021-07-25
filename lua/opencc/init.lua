local M = {}

M.format = function(conv)
  local buffer = vim.api.nvim_get_current_buf()

  -- path = parent + name
  local path = vim.api.nvim_buf_get_name(buffer)
  local split_path = vim.split(path, '/')
  local name = split_path[#split_path]
  split_path[#split_path] = nil
  local parent = table.concat(split_path, '/')
  if parent == '' then
    parent = '.'
  end

  local tmp_name = string.format('%s_%d_%s', '~opencc', math.random(1, 1000000),
                                 name)
  local tmp_path = parent .. '/' .. tmp_name

  -- read buffer content
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

  -- write buffer content to the temporary file
  local io_write = io.open(tmp_path, 'w+')
  for _, line in pairs(lines) do
    io_write:write(line)
    io_write:write('\n')
  end
  io_write:flush()
  io_write:close()

  -- convert the temporary file
  -- os.execute('opencc -c ' .. conv .. ' -i ' .. tmp_path .. ' -o ' ..
  -- tmp_path)
  os.execute(string.format('opencc -c %s -i %s -o %s', conv, tmp_path, tmp_path))

  -- load the converted file and then remove it
  local io_read = io.open(tmp_path, 'r')
  local conv_lines = {}
  for line in io_read:lines() do
    table.insert(conv_lines, line)
  end
  io_read:close()
  os.remove(tmp_path)

  -- writed the content of the converted file to the buffer
  vim.api.nvim_buf_set_lines(buffer, 0, -1, false, conv_lines)
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
