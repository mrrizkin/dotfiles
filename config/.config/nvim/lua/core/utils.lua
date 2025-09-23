local M = {}

M.coalesce = function(...)
	for i = 1, select("#", ...) do
		local value = select(i, ...)
		if value ~= nil then
			return value
		end
	end
end

M.copyf = function(f)
	return function(...)
		return f(...)
	end
end

M.log_levels = {
	silent = 0,
	error = 1,
	warn = 2,
	info = 3,
	debug = 4,
}

M.should_log = function(current_level, message_level)
	local current_num = M.log_levels[current_level] or M.log_levels.info
	local message_num = M.log_levels[message_level] or M.log_levels.info
	return message_num <= current_num
end

M.registered_keymaps = {}
M.ignored_builtin_keymaps = {}

M.check_conflict = function(mode, lhs)
	local key = mode .. ":" .. lhs
	if M.registered_keymaps[key] then
		return M.registered_keymaps[key]
	end

	local existing = vim.fn.maparg(lhs, mode, false, true)
	if existing and existing.lhs then
		return {
			source = "vim_builtin",
			desc = existing.desc or "Built-in vim mapping",
			rhs = existing.rhs or existing.callback or "Unknown",
			buffer = existing.buffer or 0,
		}
	end

	return nil
end

M.map = function(modes, lhs, rhs, opts)
	opts = opts or {}
	opts.noremap = M.coalesce(opts.noremap, true)
	opts.silent = M.coalesce(opts.silent, true)

	if type(modes) == "string" then
		modes = { modes }
	end

	local conflicts = {}
	for _, mode in ipairs(modes) do
		local conflict = M.check_conflict(mode, lhs)
		if conflict then
			table.insert(conflicts, {
				mode = mode,
				lhs = lhs,
				existing = conflict,
			})
		end
	end

	local map_data = { modes, lhs, rhs, opts }
	if #conflicts > 0 then
		map_data.conflicts = conflicts
	end

	return map_data
end

M.nmap = function(lhs, rhs, opts)
	return M.map("n", lhs, rhs, opts)
end

M.imap = function(lhs, rhs, opts)
	return M.map("i", lhs, rhs, opts)
end

M.vmap = function(lhs, rhs, opts)
	return M.map("v", lhs, rhs, opts)
end

M.tmap = function(lhs, rhs, opts)
	return M.map({ "n", "t" }, lhs, rhs, opts)
end

M.keymaps = function(maps, options)
	options = options or {}
	local report_conflicts = M.coalesce(options.report_conflicts, true)
	local abort_on_conflict = M.coalesce(options.abort_on_conflict, false)
	local override_conflicts = M.coalesce(options.override_conflicts, true)

	local log_level = options.log_level or "info" -- "silent", "error", "warn", "info", "debug"
	local log_conflicts = M.coalesce(options.log_conflicts, report_conflicts)
	local log_success = M.coalesce(options.log_success, true)
	local log_override = M.coalesce(options.log_override, true)
	local log_skip = M.coalesce(options.log_skip, true)

	local function log(level, message, force)
		if force or M.should_log(log_level, level) then
			local prefix = {
				error = "❌",
				warn = "⚠️ ",
				info = "ℹ️ ",
				debug = "🐛",
			}
			print((prefix[level] or "") .. " " .. message)
		end
	end

	local all_conflicts = {}
	local successful_maps = {}

	for _, m in ipairs(maps) do
		local modes = m[1]
		local lhs = m[2]
		local rhs = m[3]
		local o = m[4] or {}
		local conflicts = m.conflicts or {}

		if #conflicts > 0 then
			for _, conflict in ipairs(conflicts) do
				if not M.ignored_builtin_keymaps[conflict.mode .. ":" .. conflict.lhs] and conflict.buffer == 0 then
					table.insert(all_conflicts, {
						mode = conflict.mode,
						lhs = conflict.lhs,
						new_desc = o.desc or "No description",
						new_rhs = type(rhs) == "function" and "function" or tostring(rhs),
						existing = conflict.existing,
					})
				end
			end
		end

		table.insert(successful_maps, m)
	end

	if #all_conflicts > 0 then
		if log_conflicts then
			log("warn", "Keymap Conflicts Detected:")
			log("warn", string.rep("=", 60))
			for _, conflict in ipairs(all_conflicts) do
				log("warn", string.format("Mode: %s | Key: %s", conflict.mode, conflict.lhs))
				log("warn", string.format("  New: %s -> %s", conflict.new_desc, conflict.new_rhs))
				log(
					"warn",
					string.format(
						"  Existing: %s -> %s",
						conflict.existing.desc or "No description",
						conflict.existing.rhs or "Unknown"
					)
				)
				log("warn", string.rep("-", 40))
			end
			log("warn", "")
		end

		if abort_on_conflict then
			error("Keymap conflicts detected. Aborting keymap registration.")
			return
		end

		if not override_conflicts then
			if log_skip then
				log("warn", "Skipping conflicting keymaps...")
			end
			return
		else
			if log_override then
				log("info", string.format("Overriding %d conflicting keymaps...", #all_conflicts))
			end
		end
	end

	local registered_count = 0
	for _, m in ipairs(successful_maps) do
		local modes = m[1]
		local lhs = m[2]
		local rhs = m[3]
		local o = m[4] or {}

		if type(modes) == "string" then
			modes = { modes }
		end

		for _, mode in ipairs(modes) do
			local key = mode .. ":" .. lhs
			M.registered_keymaps[key] = {
				source = "user_defined",
				desc = o.desc or "User defined mapping",
				rhs = type(rhs) == "function" and "function" or tostring(rhs),
			}

			vim.keymap.set(mode, lhs, rhs, o)
			registered_count = registered_count + 1

			log("debug", string.format("Registered: %s:%s -> %s", mode, lhs, o.desc or "No description"))
		end
	end

	if log_success then
		if #all_conflicts == 0 then
			log("info", string.format("Successfully registered %d keymaps with no conflicts", registered_count))
		else
			log(
				"info",
				string.format(
					"Successfully registered %d keymaps (%d conflicts resolved)",
					registered_count,
					#all_conflicts
				)
			)
		end
	end
end

M.ignore_keymaps = function(maps)
	for _, m in ipairs(maps) do
		local modes = m[1]
		local lhs = m[2]

		if type(modes) == "string" then
			modes = { modes }
		end

		for _, mode in ipairs(modes) do
			M.ignored_builtin_keymaps[mode .. ":" .. lhs] = true
		end
	end
end

M.list_keymaps = function(mode_filter)
	print("📋 Registered Keymaps:")
	print(string.rep("=", 50))

	for key, info in pairs(M.registered_keymaps) do
		local mode, lhs = key:match("([^:]+):(.+)")
		if not mode_filter or mode == mode_filter then
			print(string.format("Mode: %s | Key: %-15s | %s", mode, lhs, info.desc))
		end
	end
end

M.find_keymaps = function(pattern)
	local matches = {}
	for key, info in pairs(M.registered_keymaps) do
		local mode, lhs = key:match("([^:]+):(.+)")
		if lhs:match(pattern) or info.desc:lower():match(pattern:lower()) then
			table.insert(matches, {
				mode = mode,
				lhs = lhs,
				desc = info.desc,
				rhs = info.rhs,
			})
		end
	end
	return matches
end

M.load_lsps = function(lspconf, lsps, config)
	for _, lsp in pairs(lsps) do
		lspconf(lsp, config)
	end
end

return M
