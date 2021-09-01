--[[
	GD50 2021
	Pong Remake

	pong-1
	"The Low-Res Update"


	-- Main Program --

	Author: Lacey Gruwell
	lsikes@csumb.edu

	Originally programmed by Atari in 1972. Features two paddles, controlled by players, with the goal of getting the ball past your opponent's edge. First player to 10 points wins the game.

	This version is built more closely to resemble the NES version than the original Pong machines or the Atari 2600 in terms of resolution, though in widescreen (16:9) so it looks nicer on modern systems.
]]

-- push.lua is the push library that will allow us to draw our
-- game at a virtual resolution, instead of however large our
-- window is; used to provide a more retro aesthetic
-- Find it:
-- https://github.com/Ulydev/push
push = require 'push'

-- Setting Arbitrary window values
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

--[[
	function love.load()
	Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
	-- use nearest-neighbor filtering on upscaling and downscaling
	--to prevent blurring of text
	-- use graphics; try removing this function to see the difference
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- initialize our virtual resolution, which will be rendered
	-- within our actual window no matter its dimensions;
	-- replaces our love.window.setMode call from the previous
	-- pong version: pong-0
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 
		WINDOW_WIDTH, WINDOW_HEIGHT, {
			fullscreen = false,
			resizable = false,
			vsync = true
	})
	
end

--[[
	Keyboard handling, called by LOVE2D each frame;
	passes in the key we pressed so we can access.
]]
function love.keypressed(key)
	-- keys can be accessed by string name
	if key == 'escape' then
		-- function LOVE gives us to terminate application
		love.event.quit()
	end
end



--[[
	function love.draw()
	Called after update by LOVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
	-- begin rendering at virtual resolution
	push:apply('start')

	-- condensed onto one line from last example
	-- NOTE: we are now using virtual width and height now for
	-- text placement
	love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')
	
	-- end rendering at virtual resolution
	push:apply('end')
end
