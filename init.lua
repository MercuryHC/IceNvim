Ice = {}

-- 加载核心配置和插件配置
require "core.init"
require "plugins.init"

-- 获取nvim配置路径和用户配置路径
local config_root = vim.fn.stdpath "config"
local custom_path = vim.fs.joinpath(config_root, "lua/custom")
if not vim.api.nvim_get_runtime_file("lua/custom/", false)[1] then
    os.execute('mkdir "' .. custom_path .. '"')
end
-- Debug Code --
-- print("config_root:", config_root)
-- print("custom_path:", custom_path)
--
-- Result:
-- > config_root: C:/Users/Mi/AppData/Local/nvim
-- > custom_path: C:/Users/Mi/AppData/Local/nvim/lua/custom
----------------------------------

-- 检查custom_path中是否存在"init.lua"文件
-- vim.fs.joinpath("xxx", "xxx"): 拼接路径
-- vim.uv.fs_stat(): 检查文件是否存在
if vim.uv.fs_stat(vim.fs.joinpath(custom_path, "init.lua")) then
    require "custom.init"
end

-- 加载core.utils模块，注册keymap按键映射表
require("core.utils").group_map(Ice.keymap)

for filetype, config in pairs(Ice.ft) do
    require("core.utils").ft(filetype, config)
end

-- Only load plugins and colorscheme when --noplugin arg is not present
if not require("core.utils").noplugin then
    require("lazy").setup(vim.tbl_values(Ice.plugins), Ice.lazy)

    local pattern = "IceAfter transparent"
    if Ice.plugins["nvim-transparent"].enabled == false then
        pattern = "VeryLazy"
    end
    vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = pattern,
        callback = function()
            local rtp_plugin_path = vim.fs.joinpath(vim.opt.packpath:get()[1], "plugin")
            local dir = vim.uv.fs_scandir(rtp_plugin_path)
            if dir ~= nil then
                while true do
                    local plugin, entry_type = vim.uv.fs_scandir_next(dir)
                    if plugin == nil or entry_type == "directory" then
                        break
                    else
                        vim.cmd(string.format("source %s/%s", rtp_plugin_path, plugin))
                    end
                end
            end

            if not Ice.colorscheme then
                Ice.colorscheme = "tokyonight"
                local colorscheme_cache = vim.fs.joinpath(vim.fn.stdpath "data", "colorscheme")
                if vim.uv.fs_stat(colorscheme_cache) then
                    local colorscheme_cache_file = io.open(colorscheme_cache, "r")
                    ---@diagnostic disable: need-check-nil
                    local colorscheme = colorscheme_cache_file:read "*a"
                    colorscheme_cache_file:close()
                    Ice.colorscheme = colorscheme
                end
            end

            require("plugins.utils").colorscheme(Ice.colorscheme, false)
        end,
    })
end

-- Prepend this to runtimepath last as it would be overridden by lazy otherwise
vim.opt.rtp:prepend(custom_path)
