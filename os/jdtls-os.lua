local M = {}

local utils = require("custom.utils")
local mason_registry = require 'mason-registry'
local jdtls = mason_registry.get_package 'jdtls'
local jdtls_path = jdtls:get_install_path()

---@return string
M.get_launcher = function ()
    return vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
end

---@return string
M.get_lombok = function ()
    return jdtls_path .. '/lombok.jar'
end

if utils.is_windows then
    M.get_path_config_system = function()
        return jdtls_path .. '/config_win'
    end
else
    M.get_path_config_system = function()
        return jdtls_path .. '/config_linux'
    end
end

return M
