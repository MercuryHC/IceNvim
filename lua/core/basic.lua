local g = vim.g
local opt = vim.opt

-- This MUST NOT be en_US, but en_US.UTF-8
-- I originally set it to en_US without UTF-8 and `yGp` ceased to work
-- It just threw an 'E353: Nothing in register "' error at me
-- vim.cmd "language en_US.UTF-8"

vim.cmd "syntax off"
g.encoding = "UTF-8"
opt.fileencoding = "utf-8"

-- * 全局设置 * --
-- see `:help vim.g`
vim.g.mapleader = " "               -- 设置全局leader键为空格
vim.g.maplocalleader = " "          -- 设置本地leader键为空格
vim.g.have_nerd_font = true         -- 启用nerd_font字体
vim.g.markdown_folding = 1          -- 启用markdown层级折叠
vim.g.simple_indicator_on = false   -- 关闭简单指示器

-- * 基础设置 * --
-- [[ 设置选项 Options ]]
-- See `:help vim.o`
-- TODO: 配置项查找
-- 具体配置项说明，参考`:help option-list`!!!
opt.winborder = "rounded"           -- 设置窗口边框样式

-- ** 光标与行号
opt.cursorline = true               -- 高亮当前行
opt.cursorcolumn = true             -- 高亮当前列
opt.number = true                   -- 显示行号
opt.relativenumber = true           -- 显示相对行号
opt.colorcolumn = "80"              -- 80列标记
local win_height = vim.fn.winheight(0)         -- 智能设置光标上下保持行号
opt.scrolloff = math.floor((win_height - 1) / 5)
opt.sidescrolloff = math.floor((win_height - 1) / 5)

-- ** 空格与缩进
opt.expandtab = true                -- 使用空格代替Tab
opt.tabstop = 4                     -- Tab 宽度
opt.shiftwidth = 4                  -- 自动缩进宽度
opt.smartindent = true              -- 智能缩进

-- ** 智能换行
opt.wrap = true                     -- 启用自动换行
opt.breakindent = true              -- 启用断行缩进
opt.linebreak = true                -- 启用行内断行(尽量在单词边界换行)
opt.showbreak = "⤻"                 -- 设置换行符号

-- * 搜索与高亮
opt.ignorecase = true               -- 关闭大小写搜索
opt.smartcase = true                -- 智能大小写
opt.hlsearch = true                 -- 搜索高亮

-- * 窗口 * --
-- ** 窗口分割
opt.splitbelow = true               -- split 分割窗口靠下
opt.splitright = true               -- vsplit 分割窗口靠右

-- * 设置特殊字符 * --
-- ** 设置文件格式
-- opt.fileformat = "unix"        -- Unix 格式(LF)
-- opt.fileformat = "dos"         -- Windows 格式(CRLF)
opt.fileformats = "unix,dos"      -- 尝试自动检测

-- ** 显示特殊字符
opt.list = false
opt.listchars = {
    tab = "▸ ",
    eol = "↲",
    space = "·",
    nbsp = "␣",
    extends = "»",
    precedes = "«",
    trail = "×"
}

-- * 其他
opt.termguicolors = true            -- 真色彩
opt.mouse = "a"                     -- 启用鼠标
opt.mousemodel = "extend"
-- TDDO: vim.schedule
vim.schedule(function()
  opt.clipboard = 'unnamedplus'     -- 互联系统剪切板
end)
opt.signcolumn = "yes"              -- 显示符号列，如git,TODO等信息展示
opt.shiftround = true               -- ?
opt.confirm = true                  -- 操作失败提示,如文件未保存，使用`:q`退出时，会弹出保存提示，而非Failed信息

opt.cmdheight = 0                   -- 设置命令栏高度
opt.cmdwinheight = 1                -- 命令窗口高度

-- Auto load the file when modified externally
opt.autoread = true

-- Use left / right arrow to move to the previous / next line when at the start
-- or end of a line.
-- See doc (:help 'whichwrap')
opt.whichwrap = "<,>,[,]"

-- Allow hiding modified buffer
opt.hidden = true

opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Time to wait for a sequence of key combination
opt.timeoutlen = 500

-- Do not display the character "W" before search count
opt.shortmess = vim.o.shortmess .. "s"

-- Maximum of 16 lines of prompt
-- This affects both neovim's native completion and that of nvim-cmp
opt.pumheight = 16

-- Always show tab line
-- Otherwise, when bufferline is loaded, it will "flash" a bit initially
opt.showtabline = 2
opt.tabline = "%!''"

opt.showmode = false

opt.nrformats = "bin,hex,alpha"

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = false

opt.laststatus = 3

if require("core.utils").is_windows then
    opt.shellslash = true
end

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})

opt.shadafile = "NONE"
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdwinEnter" }, {
    once = true,
    callback = function()
        local shada = vim.fs.joinpath(vim.fn.stdpath "state", "shada/main.shada")
        vim.o.shadafile = shada
        vim.cmd("rshada! " .. shada)
    end,
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
    callback = function()
        vim.cmd "startinsert"
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("WinNew", {
    callback = function()
        vim.wo.wrap = false
    end
})

-- WinNew is not triggered for the first window
vim.wo.wrap = false
