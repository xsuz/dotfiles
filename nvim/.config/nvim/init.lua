-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{ 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
		{
			'nvim-telescope/telescope.nvim',
			tag = 'v0.2.0',
			dependencies = { 'nvim-lua/plenary.nvim' }
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {},
			dependencies = { { "mason-org/mason.nvim", opts = {} }, "neovim/nvim-lspconfig", }
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "pencil" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- Setup lualine.nvim
require('lualine').setup()

--Setup mason-lspconfig
require("mason-lspconfig").setup()

-- Setup Completion
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- 補完の設定
		if client:supports_method('textDocument/completion') then
			-- 文字を入力する度に補完を表示（遅くなる可能性あり）
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			-- 補完を有効化
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
		-- フォーマット
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 3000 })
				end,
			})
		end
	end,
})

vim.opt.completeopt = {
	"menuone",
	"noinsert",
}

-- Setup diagnostics
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
		end,
	},
})

-- General Settings

vim.opt.number = true
