local status_ok, kanagawa = pcall(require, "kanagawa")
if not status_ok then
  return
end

local colors = require("kanagawa.colors").setup({ theme = "dragon" })
local palette = colors.palette

kanagawa.setup({
  colors = {
    theme ={
      dragon = {
        ui = {
          bg = palette.dragonBlack0,
          fg_dim = palette.dragonBlack1,
          bg_gutter = palette.dragonBlack2,
          bg_p2 = palette.dragonBlack4,
        },
        syn = {
          string = palette.dragonGreen,
        },
        diff = {
            add    = palette.autumnGreen,
            delete = palette.winterRed,
            change = palette.waverBlue1,
            text   = palette.autumnYellow,
        },
      }
    }
  }
})
