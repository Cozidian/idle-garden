local animations = {}

local sun_frames = {
	{
		"    \\   |   /",
		"  \\  \\  |  /  /",
		"    .-\\-☀-/-.",
		"  /  /  |  \\  \\",
		"    /   |   \\",
	},
	{
		"    -   |   -",
		"  -  -  |  -  -",
		"    .-\\-☀-/-.",
		"  -  -  |  -  -",
		"    -   |   -",
	},
	{
		"    |   |   |",
		"  |  |  |  |  |",
		"    .-\\-☀-/-.",
		"  |  |  |  |  |",
		"    |   |   |",
	},
}

local rain_frames = {
	{
		"  ⋰  ⋰   ⋰  ⋰  ",
		" ╱ ╱ ╱ ╱ ╱ ╱ ╱",
		"  ⋰  ⋰   ⋰  ⋰ ",
		" ╱ ╱ ╱ ╱ ╱ ╱ ╱",
	},
	{
		" ⋰  ⋰   ⋰  ⋰   ",
		"╱ ╱ ╱ ╱ ╱ ╱ ╱ ",
		"  ⋰  ⋰   ⋰  ⋰  ",
		"╱ ╱ ╱ ╱ ╱ ╱ ╱ ",
	},
	{
		"⋰  ⋰   ⋰  ⋰    ",
		" ╱ ╱ ╱ ╱ ╱ ╱ ╱",
		"⋰  ⋰   ⋰  ⋰   ",
		" ╱ ╱ ╱ ╱ ╱ ╱ ╱",
	},
}

function animations.animate_sun(game)
	if not game.state.buf or not vim.api.nvim_buf_is_valid(game.state.buf) then
		return
	end

	local frame_index = 1
	local total_frames = #sun_frames
	local iterations = 6
	local delay = 200

	local sun_timer = vim.loop.new_timer()
	sun_timer:start(
		0,
		delay,
		vim.schedule_wrap(function()
			if iterations <= 0 then
				sun_timer:stop()
				sun_timer:close()
				game.update_display() -- revert back to the plant display
				return
			end

			local lines = {}
			table.insert(lines, "Plant Status: " .. game.state.stage)
			table.insert(lines, "Hydration: " .. game.state.hydration .. "   Sunlight: " .. game.state.sunlight)
			table.insert(lines, "")
			-- Insert the current rain frame
			for _, line in ipairs(sun_frames[frame_index]) do
				table.insert(lines, line)
			end

			vim.api.nvim_buf_set_lines(game.state.buf, 0, -1, false, lines)
			frame_index = (frame_index % total_frames) + 1
			iterations = iterations - 1
		end)
	)
end

function animations.animate_rain(game)
	if not game.state.buf or not vim.api.nvim_buf_is_valid(game.state.buf) then
		return
	end

	local frame_index = 1
	local total_frames = #rain_frames
	local iterations = 6 -- Number of rain frame cycles
	local delay = 200 -- Delay in milliseconds between frames

	local rain_timer = vim.loop.new_timer()
	rain_timer:start(
		0,
		delay,
		vim.schedule_wrap(function()
			if iterations <= 0 then
				rain_timer:stop()
				rain_timer:close()
				game.update_display() -- revert back to the plant display
				return
			end

			local lines = {}
			table.insert(lines, "Plant Status: " .. game.state.stage)
			table.insert(lines, "Hydration: " .. game.state.hydration .. "   Sunlight: " .. game.state.sunlight)
			table.insert(lines, "")
			-- Insert the current rain frame
			for _, line in ipairs(rain_frames[frame_index]) do
				table.insert(lines, line)
			end

			vim.api.nvim_buf_set_lines(game.state.buf, 0, -1, false, lines)
			frame_index = (frame_index % total_frames) + 1
			iterations = iterations - 1
		end)
	)
end

return animations
