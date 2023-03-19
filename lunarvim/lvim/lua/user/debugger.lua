local dap = require('dap')

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

dap.adapters.java = {
  type = 'executable',
  command = 'java',
  args = { '-cp', '/path/to/vscode-java-debug.jar', 'com.microsoft.java.debug.core.Main' },
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'launch',
    name = 'Debug (Launch)',
    mainClass = '${file}',
    args = '',
    jvmArgs = '-ea',
  },
}
