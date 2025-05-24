return vim.tbl_deep_extend("force", require("plugins.core"), require("plugins.lsp"), require("plugins.ui"),
    require("plugins.tools"), require("plugins.coding"), require("plugins.git"), require("plugins.testing"))
