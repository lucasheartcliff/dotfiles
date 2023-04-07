local _, dap = pcall(require, 'dap')
dap.set_log_level("DEBUG")

local M = {}




function M.execute_buf_command(command, callback)
  vim.lsp.buf_request(
    0, 'workspace/executeCommand', command, function(err, _, res)
      if callback then
        callback(err, res)
      elseif err then
        print('Execute command failed: ' .. err.message)
      end
    end)
end

function M.execute_command(command, callback)
  if type(command) == 'string' then command = { command = command } end

  M.execute_buf_command(
    command, function(err, res)
      -- assert(not err, err and (err.message or Log.ins(err)))
      callback(res)
    end)
end

-- TS/JS Debugger --
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/.local/share/nvim-dap/vscode-node-debug2/out/src/nodeDebug.js' },
}

dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

dap.configurations.typescript = dap.configurations.javascript

--Python Debugger--
dap.adapters.python = {
  type = 'executable',
  command = 'python3',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch file',
    program = '${file}',
    pythonPath = function()
      return '/usr/bin/python3'
    end,
  },
}

-- dap.adapters.java = {
--   type = "executable",
--   command = "java",
--   args = { "-jar", os.getenv("HOME") .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server" }
-- }
local JAVA_PORT = 5005
dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Attach to remote Java server",
    hostName = "localhost",
    timeout = 30000,
    port = JAVA_PORT -- The port on which the server is listening
  }
}

-- dap.configurations.java = {
--   {
--     type = 'java',
--     request = 'launch',
--     name = 'Debug (Launch)',
--     mainClass = '${file}',
--     args = '',
--     jvmArgs = '-ea',
--   },
-- }
--
return M
