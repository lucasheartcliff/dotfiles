local _, dap = pcall(require,'dap')

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
local JAVA_PORT = 5005
dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Attach to remote Java server",
    hostName = "localhost",
    port = JAVA_PORT -- The port on which the server is listening
  }
}
dap.adapters.java = {
  type = 'executable',
  command = 'jdb',
  args = { '-connect', 'com.sun.jdi.SocketAttach:hostname=localhost,port=5005' }
  --args = { '-cp', './resources/java-debug.jar', 'com.microsoft.java.debug.core.Main' },
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
