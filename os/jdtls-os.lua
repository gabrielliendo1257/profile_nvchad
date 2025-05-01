local M = {}

local utils = require("custom.utils")
local mason_registry = require 'mason-registry'
local jdtls = mason_registry.get_package 'jdtls'
local jdtls_path = jdtls:get_install_path()

if utils.is_windows then
    M.get_launcher = function()
        -- Obtain the path to the jar which runs the language server
        local launcher = vim.fn.glob(jdtls_path ..
            '/plugins/org.eclipse.equinox.launcher_*.jar')

        return launcher
    end

    M.get_config_system = function()
        return jdtls_path .. "/config_win"
    end

    M.get_lombok = function()
        return jdtls_path .. "/../lombok-nightly" .. "/lombok.jar"
    end
end

return M
