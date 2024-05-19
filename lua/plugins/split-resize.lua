return {
  "mrjones2014/smart-splits.nvim",
  dependencies = { "s1n7ax/nvim-window-picker" },
  config = function()
    -- recommended mappings
    -- resizing splits
    -- these keymaps will also accept a range,
    -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
    vim.keymap.set("n", "<leader>wj", require("smart-splits").resize_down, { desc = "resize down" })
    vim.keymap.set("n", "<leader>wh", require("smart-splits").resize_left, { desc = "resize left" })
    vim.keymap.set("n", "<leader>wk", require("smart-splits").resize_up, { desc = "resize up" })
    vim.keymap.set("n", "<leader>wl", require("smart-splits").resize_right, { desc = "resize down" })
  end,
}
