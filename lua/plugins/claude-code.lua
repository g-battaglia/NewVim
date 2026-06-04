return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("claude-code").setup({
			window = {
				position = "vertical",
				split_ratio = 0.3,
				enter_insert = true,
				hide_numbers = true,
				hide_signcolumn = true,
			},
		})
	end,
}
