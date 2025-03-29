local M = {}

-- Add the lua directory to package path
package.path = package.path .. ";./lua/?.lua"

M.game = require("garden.game")
M.animations = require("garden.animations")
M.commands = require("garden.commands")

return M
