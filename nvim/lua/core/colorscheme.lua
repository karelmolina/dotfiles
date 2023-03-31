local status, _ = pcall(vim.cmd, "colorscheme hybrid")
if not status then
    print("colorscheme not found")
    return
end