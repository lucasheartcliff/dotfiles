local HOME = os.getenv "HOME"

-- Debugger installation location
local DEBUGGER_LOCATION = HOME .. "/.local/share/nvim"

-- Debugging
local bundles = {
    vim.fn.glob(
        DEBUGGER_LOCATION .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
    ),
}
vim.list_extend(bundles, vim.split(vim.fn.glob(DEBUGGER_LOCATION .. "/vscode-java-test/server/*.jar"), "\n"))
