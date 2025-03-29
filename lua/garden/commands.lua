local game = require("garden.game")
local animations = require("garden.animations")

local commands = {}

local function plant()
	-- Clean up any existing game state
	game.cleanup()
	
	-- Create a new scratch buffer for the game
	game.state.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(game.state.buf)

	game.state.alive = true
	game.state.stage = "seed"
	game.state.hydration = 10
	game.state.sunlight = 10

	game.update_display()
	game.start_timer()
end

local function water()
	if not game.state.alive then
		return
	end
	game.state.hydration = math.min(game.state.hydration + 2, 10)
	game.update_display()
	animations.animate_rain(game)
end

-- Sun command: boost sunlight
local function give_sun()
	if not game.state.alive then
		return
	end
	game.state.sunlight = math.min(game.state.sunlight + 2, 10)
	game.update_display()
	animations.animate_sun(game)
end

-- Create user commands
vim.api.nvim_create_user_command("Plant", function()
	plant()
end, {})
vim.api.nvim_create_user_command("Water", function()
	water()
end, {})
vim.api.nvim_create_user_command("Sun", function()
	give_sun()
end, {})

return commands
