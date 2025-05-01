local M = {}

M.is_windows = vim.loop.os_uname().sysname == "Windows_NT"

M.is_linux = vim.loop.os_uname().sysname == "Linux"

return M
