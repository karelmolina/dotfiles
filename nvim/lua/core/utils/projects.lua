local M = {}
local project_path_json = vim.fn.stdpath("config") .. "/project_path.json"

function M.get_project_path()
  local paths = {}
  if vim.fn.filereadable(project_path_json) == 1 then
    local json = vim.fn.readfile(project_path_json)
    paths = vim.fn.json_decode(json)
  else
    paths = {
      "~/workspace/*",
      "~/.config/*"
    }
  end

  return paths
end

return M
