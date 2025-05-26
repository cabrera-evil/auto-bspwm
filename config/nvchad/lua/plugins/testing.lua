return {{
    "vim-test/vim-test",
    dependencies = {"preservim/vimux"},
    config = function()
        require("configs.vim-test")
    end
} -- {
--     "vinnymeller/swagger-preview.nvim",
--     cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
--     build = "npm i",
--     config = true
-- }
}
