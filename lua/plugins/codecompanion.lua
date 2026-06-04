-- =============================================================================
-- NewVim - plugins/codecompanion.lua
-- =============================================================================
-- codecompanion.nvim:
--   - assistente AI chat/inline dentro Neovim
--   - usa z.ai GLM Coding Plan come provider LLM
--   - adapter basato su openai_compatible
--
-- Keymap (<leader>a = prefisso AI):
--   <leader>aa  -> Actions (palette)
--   <leader>ac  -> Toggle Chat
--   <leader>ai  -> Inline assist
--   <leader>ae  -> Spiega il codice selezionato (visual mode)
--   ga          -> Aggiungi selezione alla chat (visual mode)
-- =============================================================================

local notify_id = nil -- id per poter aggiornare/chiudere la notifica

return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	lazy = false, -- carica subito, niente attesa al primo keymap
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},

	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
		{ "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
		{ "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI Inline" },
		{ "<leader>ae", ":'<,'>CodeCompanion explain<cr>", mode = "v", desc = "AI Explain" },
		{ "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "AI Add to Chat" },
	},

	opts = {
		adapters = {
			http = {
				zai_glm = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						name = "zai_glm",
						formatted_name = "Z.AI GLM",
						env = {
							url = "https://api.z.ai/api/coding/paas/v4",
							api_key = "ZAI_API_KEY",
							chat_url = "/chat/completions",
						},
						schema = {
							model = {
								default = "glm-5.1",
								choices = { "glm-5.1" },
							},
						},
						handlers = {
							-- Gestione robusta degli errori API per inline_output
							inline_output = function(self, data, context)
								if data and data ~= "" then
									local ok, json = pcall(vim.json.decode, data.body, { luanil = { object = true } })
									if not ok then
										return { status = "error", output = "Errore decoding risposta API" }
									end
									if not json.choices or not json.choices[1] then
										local msg = "Errore sconosciuto"
										if json.error and json.error.message then
											msg = json.error.message
										end
										return { status = "error", output = "API Error: " .. msg }
									end
									local choice = json.choices[1]
									if choice.message and choice.message.content then
										return { status = "success", output = choice.message.content }
									end
								end
							end,
						},
					})
				end,
			},
		},

		interactions = {
			chat = {
				adapter = "zai_glm",
			},
			inline = {
				adapter = "zai_glm",
			},
		},

		display = {
			action_palette = {
				provider = "snacks",
			},
		},

		-- Risposte sempre in italiano + log level
		opts = {
			language = "Italian",
			log_level = "INFO",
		},
	},

	config = function(_, opts)
		-- Setup del plugin
		require("codecompanion").setup(opts)

		-- Notifica di caricamento quando la richiesta inizia/finisce
		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionRequestStarted",
			callback = function()
				notify_id = vim.notify("⏳ Attendi...", vim.log.levels.INFO, {
					title = "CodeCompanion",
					timeout = false, -- non sparire finché non finisce
					replace = notify_id,
				})
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionRequestFinished",
			callback = function()
				if notify_id then
					vim.notify("", vim.log.levels.INFO, { replace = notify_id, timeout = 1 })
					notify_id = nil
				end
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "CodeCompanionChatDone",
			callback = function()
				if notify_id then
					vim.notify("", vim.log.levels.INFO, { replace = notify_id, timeout = 1 })
					notify_id = nil
				end
				vim.notify("✅ Risposta completata", vim.log.levels.INFO, {
					title = "CodeCompanion",
					timeout = 2000,
				})
			end,
		})
	end,
}
