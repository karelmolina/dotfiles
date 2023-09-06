local M = {}

--- regex used for matching a valid URL/URI string
M.url_matcher =
  "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

--- Delete the syntax matching rules for URLs/URIs if set
function M.delete_url_match()
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
  end
end

--- Add syntax matching rules for highlighting URLs/URIs
function M.set_url_match()
  M.delete_url_match()
  if vim.g.highlighturl_enabled then vim.fn.matchadd("HighlightURL", M.url_matcher, 15) end
end

function M.is_available(plugin)
	local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
	return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

function M.which_key_register()
	if M.which_key_queue then
		local wk_avail, wk = pcall(require, "which-key")
		if wk_avail then
			for mode, registration in pairs(M.which_key_queue) do
				wk.register(registration, { mode = mode })
			end
			M.which_key_queue = nil
		end
	end
end

function M.set_mappings(map_table)
	for mode, mapped in pairs(map_table) do
		for key, options in pairs(mapped) do
			if options then
				local cmd = options
				local keymaps_opts = {}
				if type(options) == "table" then
					cmd = options[1]
					keymaps_opts = options
					keymaps_opts[1] = nil
				end

				if not cmd or keymaps_opts.name then
					if not keymaps_opts.name then
						keymaps_opts.name = keymaps_opts.desc
					end
					if not M.which_key_queue then
						M.which_key_queue = {}
					end
					if not M.which_key_queue[mode] then
						M.which_key_queue[mode] = {}
					end

					M.which_key_queue[mode][key] = keymaps_opts
				else
					vim.keymap.set(mode, key, cmd, keymaps_opts)
				end
			end
		end
	end

	if package.loaded["which-key"] then
		M.which_key_register()
	end -- if which-key is loaded already, register
end

return M
