local utils = require("custom.utils")
local mason_registry = require 'mason-registry'
local jdtls = mason_registry.get_package 'jdtls'
local jdtls_path = jdtls:get_install_path()

local M = {}

if utils.is_windows then
    M.get_path_debugpy = function()
        return jdtls_path .. '/..' .. '/debugpy' .. '/venv/Scripts/python'
    end
else
    M.get_path_debugpy = function()
        return jdtls_path .. '/..' .. '/debugpy' .. '/venv/bin/python'
    end
end

return M
