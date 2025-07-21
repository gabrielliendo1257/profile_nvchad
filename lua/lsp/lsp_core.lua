AbstractLsp = {}
AbstractLsp.__index = AbstractLsp

function AbstractLsp:new ()

  local obj = setmetatable({}, self)
  self.mason_packages = vim.fn.stdpath('data').."/mason".."/packages"
    self.lsp_plugin = nil

  return obj

end

function AbstractLsp:do_logic ()
    self.lsp_plugin = self:factory_lsp_plugin()
end

function AbstractLsp:factory_lsp_plugin ()
end


JdtlsConfiguration = setmetatable({}, { __index = AbstractLsp })
JdtlsConfiguration.__index = JdtlsConfiguration

function JdtlsConfiguration:new()

  local obj_base = AbstractLsp.new(self)
  local obj = setmetatable({}, self)
  obj.java_debug_path = obj_base.mason_packages .. "/java-debug-adapter"
  obj.java_test_path = obj_base.mason_packages .. "/java-test"
  obj.jdtls_path = obj_base.mason_packages .. "/jdtls"

  obj.main_config = {}

  return obj

end

function JdtlsConfiguration:get_bundles()
  local bundles = {
    vim.fn.glob(self.java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
  }

  vim.list_extend(bundles, vim.split(vim.fn.glob(self.java_test_path.."/extension/server/*.jar", 1), "\n"))

  return bundles
end

function JdtlsConfiguration:get_launcher()
  return vim.fn.glob(self.jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
end

function JdtlsConfiguration:get_lombok()
  return self.jdtls_path .. "/lombok.jar"
end

function JdtlsConfiguration:get_jars_config_platform()
  if vim.loop.os_uname().sysname == "Windows_NT" then
    return self.jdtls_path .. "/config_win"
  else
    return self.jdtls_path .. "/config_linux"
  end
end

function JdtlsConfiguration:get_workspace()
  local home = os.getenv("HOME") or os.getenv("HOMEPATH")

  local workspace_path = home .. "/workspace_java"
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local now_workspace_dir = workspace_path .. project_name

  return now_workspace_dir
end

function JdtlsConfiguration:factory_lsp_plugin()
  local jdtls = require("jdtls")
  local extendedClientCapabilities = jdtls.extendedClientCapabilities
  extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

  self.main_config = {
    cmd = {
      "java",
      '-Declipse.application=org.eclipse.jdt.ls.core.id1',
      '-Dosgi.bundles.defaultStartLevel=4',
      '-Declipse.product=org.eclipse.jdt.ls.core.product',
      '-Dlog.protocol=true',
      '-Dlog.level=ALL',
      '-Xmx1g',
      '--add-modules=ALL-SYSTEM',
      '--add-opens',
      'java.base/java.util=ALL-UNNAMED',
      '--add-opens',
      'java.base/java.lang=ALL-UNNAMED',
      '-javaagent:' .. self:get_lombok(),
      '-jar',
      self:get_launcher(),
      '-configuration',
      self:get_jars_config_platform(),
      '-data',
      self:get_workspace(),
    },
    root_dir = jdtls.setup.find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
    init_options = {
      bundles = self:get_bundles(),
      extendedClientCapabilities = extendedClientCapabilities,
    },
    on_attach = function(_, bufnr)

    require('jdtls.dap').setup_dap()

    require('jdtls.dap').setup_dap_main_class_configs()
    vim.lsp.codelens.refresh()

    vim.api.nvim_create_autocmd('BufWritePost', {
        pattern = { '*.java' },
        callback = function()
            local _, _ = pcall(vim.lsp.codelens.refresh)
        end,
    })
end,

-- Configure settings in the JDTLS server
settings = {
    java = {
        -- Enable code formatting
        format = {
            enabled = true,
            -- Use the Google Style guide for code formattingh
            settings = {
                -- url = vim.fn.stdpath("config") .. "/lang_servers/intellij-java-google-style.xml",
                profile = 'GoogleStyle',
            },
        },
        -- Enable downloading archives from eclipse automatically
        eclipse = {
            downloadSource = true,
        },
        -- Enable downloading archives from maven automatically
        maven = {
            downloadSources = true,
        },
        -- Enable method signature help
        signatureHelp = {
            enabled = true,
        },
        -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
        contentProvider = {
            preferred = 'fernflower',
        },
        -- Setup automatical package import oranization on file save
        saveActions = {
            organizeImports = true,
        },
        -- Customize completion options
        completion = {
            -- When using an unimported static method, how should the LSP rank possible places to import the static method from
            favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
            },
            -- Try not to suggest imports from these packages in the code action window
            filteredTypes = {
                'com.sun.*',
                'io.micrometer.shaded.*',
                'java.awt.*',
                'jdk.*',
                'sun.*',
            },
            -- Set the order in which the language server should organize imports
            importOrder = {
                'java',
                'jakarta',
                'javax',
                'com',
                'org',
            },
        },
        sources = {
            -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
            organizeImports = {
                starThreshold = 9999,
                staticThreshold = 9999,
            },
        },
        -- How should different pieces of code be generated?
        codeGeneration = {
            -- When generating toString use a json format
            toString = {
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
            },
            -- When generating hashCode and equals methods use the java 7 objects method
            hashCodeEquals = {
                useJava7Objects = true,
            },
            -- When generating code use code blocks
            useBlocks = true,
        },
        -- If changes to the project will require the developer to update the projects configuration advise the developer before accepting the change
        configuration = {
            updateBuildConfiguration = 'interactive',
        },
        -- enable code lens in the lsp
        referencesCodeLens = {
            enabled = true,
        },
        -- enable inlay hints for parameter names,
        inlayHints = {
            parameterNames = {
                enabled = 'all',
            },
        },
    },
},
  }

    return self.main_config
end
