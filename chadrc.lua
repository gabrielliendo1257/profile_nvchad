---@type ChadrcConfig
local M = {}
-- Path to overriding theme and highlights files
-- local highlights = require "custom.highlights"

M.ui = {
    theme = "ayu_dark",
    -- transparency = true,
    theme_toggle = { "catppuccin" },
    nvdash = {
        load_on_startup = true
    },
    lsp_semantic_tokens = true,
    -- hl_override = highlights.override,
    -- hl_add = highlights.add,
    tabufline = {
        enabled = false,
    },
    statusline = {
        theme = "vscode_colored",
    },
}

M.plugins = "custom.plugins"
-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
