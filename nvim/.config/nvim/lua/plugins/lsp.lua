-- LSP - Language Server Protocol.
--
-- A language server is a background process that actually understands the
-- language you are editing. It provides the red squiggles, "jump to
-- definition", rename-across-files and hover documentation.
--
-- How the pieces fit together:
--   mason.nvim       downloads the server binaries into ~/.local/share/nvim/mason
--   nvim-lspconfig   ships ready-made definitions (start command, project root
--                    detection, sane defaults) for hundreds of servers
--   vim.lsp.enable   Neovim 0.11+ built-in: turns a definition on
--
-- To add a language: add the server name to BOTH lists below, then restart.
-- Server names:  :Mason  (browse)  or  :help lspconfig-all

-- The servers that should be active. One visible list, no magic.
local servers = {
	"lua_ls", -- Lua (this config itself)
	"ts_ls", -- TypeScript / JavaScript
	"pyright", -- Python
	"clangd", -- C / C++
	"jsonls", -- JSON
	"yamlls", -- YAML (docker-compose, CI, supabase)
	"bashls", -- shell scripts
}

return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = { border = "rounded" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason-org/mason.nvim" },
		config = function()
			-- --- Diagnostics: how errors and warnings are displayed -------------
			vim.diagnostic.config({
				virtual_text = { prefix = "●", spacing = 2 },
				underline = true,
				severity_sort = true,
				float = { border = "rounded", source = true },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
			})

			-- --- Per-server tweaks ----------------------------------------------
			-- vim.lsp.config() merges on top of what nvim-lspconfig already
			-- defines, so we only spell out what actually differs.
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						-- Stop it complaining that `vim` is an undefined global.
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			-- --- Turn the servers on ---------------------------------------------
			vim.lsp.enable(servers)

			-- --- Shortcuts, active only in buffers with a running server ---------
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("dotfiles_lsp_attach", { clear = true }),
				callback = function(event)
					local function map(keys, action, desc)
						vim.keymap.set("n", keys, action, { buffer = event.buf, desc = desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gr", vim.lsp.buf.references, "Show references")
					map("gI", vim.lsp.buf.implementation, "Go to implementation")
					map("K", vim.lsp.buf.hover, "Show documentation")
					map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action / quick fix")
					map("<leader>ci", "<cmd>checkhealth vim.lsp<CR>", "LSP status")

					-- Highlight every occurrence of the symbol under the cursor.
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method("textDocument/documentHighlight") then
						local group = vim.api.nvim_create_augroup(
							"dotfiles_lsp_highlight_" .. event.buf,
							{ clear = true }
						)
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = group,
							callback = vim.lsp.buf.clear_references,
						})
					end
				end,
			})
		end,
	},

	-- Installs the server binaries listed above, plus the formatters used by
	-- lua/plugins/format.lua. Without this you would have to click through
	-- :Mason by hand on every new machine.
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = vim.list_extend(vim.deepcopy(servers), {
				"stylua", -- Lua formatter
				"prettier", -- JS/TS/JSON/YAML/Markdown formatter
				"ruff", -- Python linter + formatter
				"clang-format", -- C/C++ formatter
				"shfmt", -- shell formatter
			}),
			run_on_start = true,
		},
	},
}
