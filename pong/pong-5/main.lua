--[[
	GD50 2021
	Pong Remake

	pong-5
	"The Class Update"


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

-- the "Class" library we're using will allow us to represent
-- anything in our game as code, rather than keeping track of
-- many disparate variables and methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Our Paddle class, which stores position and dimensions for
-- each Paddle and the logic for rendering them
require 'Paddle'

-- Our Ball class, which isn't much different than a Paddle
-- structure-wise but which will mechanically function very
-- differently
require 'Ball'

-- Setting Arbitrary window values
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


-- speed at which we will move our paddle; multiplied by dt
-- in update; (dt = delta time)
PADDLE_SPEED = 200

--[[
	function love.load()
	Runs when the game first starts up, only once; used to initialize the game.
]]
function love.load()
	-- use nearest-neighbor filtering on upscaling and downscaling
	--to prevent blurring of text
	-- use graphics; try removing this function to see the difference
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- "seed" the RNG so that calls to random are always random
	-- use the current time, since that will vary on startup
	-- every time
	math.randomseed(os.time())

	-- more "retro-looking" font object we can use fir any text
	smallFont = love.graphics.newFont('font.ttf', 8)

	-- set LOVE2D's active font to the smallFont object
	love.graphics.setFont(smallFont)

	-- initialize our virtual resolution, which will be rendered
	-- within our actual window no matter its dimensions;
	-- replaces our love.window.setMode call from the previous
	-- pong version: pong-0
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 
		WINDOW_WIDTH, WINDOW_HEIGHT, {
			fullscreen = false,
			resizable = true,
			vsync = true
	})

	-- initialize our player paddles; make them global so that
	-- they can be detected by other functions and modules
	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

	-- place a ball in the middle of the screen
	ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

	-- game state variable used to transition between different
	-- parts of the game (used for beginning, menus, main game,
	-- high schore list, etc) we will use this to determine
	-- behavior during render and update
	gameState = 'start'
	
end


--[[
	function love.update(dt)
	Runs every frame, with "dt" passed in, our delta in seconds
	since the last frame, which LOVE2D supplied us.
]]
function love.update(dt)
	-- player 1 movement
	if love.keyboard.isDown('w') then
		player1.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('s') then
		player1.dy = PADDLE_SPEED
	else
		player1.dy = 0
	end

	-- player 2 movement
	if love.keyboard.isDown('up') then
		player2.dy = -PADDLE_SPEED
	elseif love.keyboard.isDown('down') then
		player2.dy = PADDLE_SPEED
	else
		player2.dy = 0
	end

	-- update our ball based on its DX and DY only if we're in
	-- play state; scale the velocity by dt so movement is
	-- framerate-independent
	if gameState == 'play' then
		ball:update(dt)
	end

	player1:update(dt)
	player2:update(dt)
end

--[[
	function love.keypressed(key)
	Keyboard handling, called by LOVE2D each frame;
	passes in the key we pressed so we can access.
]]
function love.keypressed(key)
	-- keys can be accessed by string name
	if key == 'escape' then
		-- function LOVE gives us to terminate application
		love.event.quit()
	-- if we press enter during the start state of the game,
	-- we'll go into play mode
	-- during play mode, the ball will move in a random direction
	elseif key == 'enter' or key == 'return' then
		if gameState == 'start' then
			gameState = 'play'
		else
			gameState = 'start'

			-- ball's new reset method
			ball:reset()
		end
	end
end



--[[
	function love.draw()
	Called after update by LOVE2D, used to draw anything to the screen, updated or otherwise.
]]
function love.draw()
	-- begin rendering at virtual resolution
	push:apply('start')

	-- clear the screen with a specific color; in this case, a
	-- color similar to some versions of the original Pong
	love.graphics.clear(40/255, 45/255, 52/255, 255/255)

	-- draw welcome text toward the top of the screen
	love.graphics.setFont(smallFont)

	if gameState == 'start' then
		love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
	else
		love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
	end

	-- render paddles, now using their class's render method
	player1:render()
	player2:render()

	-- render ball using it's class's render method
	ball:render()

	-- end rendering at virtual resolution
	push:apply('end')
end
