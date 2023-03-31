local setup, hybrid = pcall(require, "hybrid")

if not setup then
    return
end

vim.g.hybrid_custom_term_colors = 1
vim.g.hybrid_reduced_contrast = 1
