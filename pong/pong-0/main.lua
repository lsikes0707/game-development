--[[
	GD50 2021
	Pong Remake

	pong-0
	"The Day-0 Update"
	"The beginning"

	-- Main Program --

	Author: Lacey Gruwell
	lsikes@csumb.edu

	Originally programmed by Atari in 1972. Features two paddles, controlled by players, with the goal of getting the ball past your opponent's edge. First player to 10 points wins the game.

	This version is built more closely to resemble the NES version than the original Pong machines or the Atari 2600 in terms of resolution, though in widescreen (16:9) so it looks nicer on modern systems.
]]

-- Setting Arbitrary window values
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--[[
	function love.load()
	Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
	love.window.setMode(
	WINDOW_WIDTH, WINDOW_HEIGHT, {
	fullscreen = false,
	resizable = false,
	vsync = true
	})
end

--[[
	function love.draw()
	Called after update by LOVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
	love.graphics.printf(
		'Hello Pong!',	-- text to render
		0,				-- starting X (0 since we're going to center it based on width)
		WINDOW_HEIGHT / 2 - 6,	-- starting Y (halfway down the screen)
		WINDOW_WIDTH,	-- number of pixels to center within (the entire screen here)
		'center')		-- alignment mode, can be 'center', 'left', or 'right'
end
