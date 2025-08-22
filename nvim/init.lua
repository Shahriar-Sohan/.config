------------------------------
-- 0️⃣ Set leader key
------------------------------
vim.g.mapleader = " "  -- Space as leader

------------------------------
-- 1️⃣ Keybinding for NvimTree
------------------------------
vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

------------------------------
-- 0️⃣ Bootstrap lazy.nvim
------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

------------------------------
-- 1️⃣ Lazy.nvim plugin setup
------------------------------
require("lazy").setup({
  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",

  -- LSP
  "neovim/nvim-lspconfig",

  -- Treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Colorscheme
  "catppuccin/nvim",
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35, side = "left"  },
        hijack_cursor = true,
        update_focused_file = { enable = true },
      })
      -- Toggle keybinding
      vim.api.nvim_set_keymap('n', '<Leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
      -- Open on startup if no file argument
      vim.cmd [[autocmd VimEnter * if !argc() | NvimTreeOpen | endif]]
    end,
  },

  -- Statusline
  "nvim-lualine/lualine.nvim",

  -- Optional: icons
  "nvim-tree/nvim-web-devicons",
})

------------------------------
-- 2️⃣ Basic options
------------------------------
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true
vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])

------------------------------
-- 3️⃣ Colorscheme (Catppuccin)
------------------------------
vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
vim.cmd([[colorscheme catppuccin]])

------------------------------
-- 4️⃣ LSP + nvim-cmp setup
------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Attach capabilities to LSP
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup{
  capabilities = capabilities,
}

-- TypeScript / JavaScript
lspconfig.ts_ls.setup{
  capabilities = capabilities,
}

-- C / C++
lspconfig.clangd.setup{
  capabilities = capabilities,
}

-- C# (OmniSharp)
lspconfig.omnisharp.setup{
  cmd = { "~/omnisharp/OmniSharp" }, -- change to your path
  capabilities = capabilities,
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
  analyze_open_documents_only = false,
}

------------------------------
-- 5️⃣ Treesitter
------------------------------
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "cpp", "python", "javascript", "typescript", "tsx" }, -- C# excluded
  highlight = { enable = true },
  indent = { enable = true },
}

------------------------------
-- 6️⃣ Statusline
------------------------------
require('lualine').setup {
  options = { theme = 'catppuccin', section_separators = '', component_separators = '' }
}


