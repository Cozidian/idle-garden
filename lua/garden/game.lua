local game = {}

game.state = {
	alive = false,
	stage = "",
	hydration = 0,
	sunlight = 0,
	timer = nil,
	buf = nil,
}

local function get_ascii_art(stage)
	if stage == "seed" then
		return {
			"    .",
			"   (o)",
			"  (ooo)",
			"   '''",
		}
	elseif stage == "sprout" then
		return {
			"    .",
			"   (o)",
			"  (ooo)",
			"    |",
			"   \\|/",
			"    |",
			"   '''",
		}
	elseif stage == "flower" then
		return {
			"    \\♠/",
			"   ⋆*❀*⋆",
			"  \\△━△/",
			"    ┃|┃",
			"   ┗|┻|┛",
			"    \\|/",
			"     |",
			"    ╱╲",
		}
	elseif stage == "dead" then
		return {
			"    †",
			"   ╱ ╲",
			"   ╲ ╱",
			"    †",
		}
	else
		return { "Unknown stage" }
	end
end

function game.update_display()
	if not game.state.buf or not vim.api.nvim_buf_is_valid(game.state.buf) then
		return
	end

	local art = get_ascii_art(game.state.stage)
	local lines = {}
	table.insert(lines, "Plant Status: " .. game.state.stage)
	table.insert(lines, "Hydration: " .. game.state.hydration .. "   Sunlight: " .. game.state.sunlight)
	table.insert(lines, "")
	for _, line in ipairs(art) do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(game.state.buf, 0, -1, false, lines)
end

function game.game_tick()
	if not game.state.alive then
		return
	end

	-- Reduce resources on every tick
	game.state.hydration = game.state.hydration - 1
	game.state.sunlight = game.state.sunlight - 1

	-- If any resource falls to zero or below, the plant dies
	if game.state.hydration <= 0 or game.state.sunlight <= 0 then
		game.state.alive = false
		game.state.stage = "dead"
		game.update_display()
		if game.state.timer then
			game.state.timer:stop()
			game.state.timer:close()
			game.state.timer = nil
		end
		return
	end

	-- Promote growth if both resources are high enough
	if game.state.hydration >= 8 and game.state.sunlight >= 8 then
		if game.state.stage == "seed" then
			game.state.stage = "sprout"
		elseif game.state.stage == "sprout" then
			game.state.stage = "flower"
		end
	end

	game.update_display()
end

function game.start_timer()
	if game.state.timer then
		game.state.timer:stop()
		game.state.timer:close()
	end
	game.state.timer = vim.loop.new_timer()
	game.state.timer:start(
		10000,
		10000,
		vim.schedule_wrap(function()
			game.game_tick()
		end)
	)
end

function game.cleanup()
	if game.state.timer then
		game.state.timer:stop()
		game.state.timer:close()
		game.state.timer = nil
	end
	if game.state.buf and vim.api.nvim_buf_is_valid(game.state.buf) then
		vim.api.nvim_buf_delete(game.state.buf, { force = true })
		game.state.buf = nil
	end
	game.state.alive = false
	game.state.stage = ""
	game.state.hydration = 0
	game.state.sunlight = 0
end

return game
