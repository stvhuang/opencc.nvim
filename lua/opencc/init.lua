local api = vim.api

local M = {}

M.convert = function(config)
  local buffer = api.nvim_get_current_buf()

  -- path = parent + name
  local path = api.nvim_buf_get_name(buffer)
  local split_path = vim.split(path, "/")
  local name = split_path[#split_path]
  split_path[#split_path] = nil
  local parent = table.concat(split_path, "/")
  if parent == "" then
    parent = "."
  end
  local tmp_name = string.format("%s_%d_%s", "~opencc", math.random(1, 1000000), name)
  local tmp_path = parent .. "/" .. tmp_name

  -- read buffer content
  local lines = api.nvim_buf_get_lines(buffer, 0, -1, false)

  -- write buffer content to the temporary file
  local io_write = io.open(tmp_path, "w+")
  for _, line in pairs(lines) do
    io_write:write(line)
    io_write:write("\n")
  end
  io_write:flush()
  io_write:close()

  -- convert the temporary file
  os.execute(string.format("opencc -c %s -i %s -o %s", config, tmp_path, tmp_path))

  -- load the converted file and then remove it
  local io_read = io.open(tmp_path, "r")
  local converted_lines = {}
  for line in io_read:lines() do
    table.insert(converted_lines, line)
  end
  io_read:close()
  os.remove(tmp_path)

  -- writed the content of the converted file to the buffer
  api.nvim_buf_set_lines(buffer, 0, -1, false, converted_lines)
end

M.pinned = { "t2s", "s2t" }
M.pinned_idx = 1
M.pinned_cycle = function()
  if #M.pinned ~= 0 then
    local config = M.pinned[M.pinned_idx]

    M.pinned_idx = M.pinned_idx + 1

    if M.pinned_idx > #M.pinned then
      M.pinned_idx = 1
    end

    M.convert(config)
  end
end

M.create_user_command = function()
  api.nvim_create_user_command("OpenCC", function(opts)
    M.convert(opts.args)
  end, { nargs = 1 })

  api.nvim_create_user_command("OpenCC", function()
    M.pinned_cycle()
  end, { nargs = 0 })
end

M.setup = function(args)
  M.pinned = args.pinned or M.pinned
  M.create_user_command()
end

return M
