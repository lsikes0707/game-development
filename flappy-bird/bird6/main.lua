--[[
	GD50
	Flappy Bird Remake

	Flappy-Bird6
	"The PipePair Update"

	Author: Lacey Gruwell
	lsikes@csumb.edu

	A mobile game by Dong Nguyen that went viral in 2013,
	utilizing a very simple but effective gameplay mechanic of
	avoiding pipes indefinitely by just tapping the screen, making
	the player's bird avatar flap its wings and move upwards
	slightly. A variant of popular games like "Helicopter Game"
	that floated around the internet for years prior. Illustrates
	some of the most basic procedural generation of game levels
	possible as by having pipes stick out of the ground by 
	varying amounts, acting as an infinitely generated obstacle
	course for the player.
]]

-- virtual resolution handling library
-- to apply a retro aesthetic, useing push library
push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

-- class representing the pipes
require 'Pipe'

-- class representing pair of pipes together
require 'PipePair'

-- define some constants
-- physical window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual window resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Goal: draw 2 images to the screen; a foreground and background
-- use paralex scrolling

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413
-- point at which we should loop our ground back to 0
local GROUND_LOOPING_POINT = 514

-- our bird = Bird()
local bird = Bird()

-- our table of spawning Pipes
local pipePairs = {}

-- our timer for spawning pipes
local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to
-- base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

function love.load()
	-- initialize our nearest-neighbor filter
	-- to prevent our images from looking blurry, use:
	-- use 'nearest' for upscale(min) and downscale(mag) to avoid
	-- interpolation of the pixels
	love.graphics.setDefaultFilter('nearest', 'nearest')

	-- app window title
	love.window.setTitle('Flappy Bird')

	-- initialize our virtual resolution
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
	vsync = true,
	fullscreen = false,
	resizable = true
})

	-- initialize input table
	love.keyboard.keysPressed = {}
end

function love.resize(w, h)
	push:resize(w, h)
end

-- user input function
function love.keypressed(key)
	-- add to our table of keys pressed this frame
	love.keyboard.keysPressed[key] = true

	if key == 'escape' then
		love.event.quit()
	end
end

--[[
	function love.keyboard.wasPressed(key)
	New function used to check our global input table for keys we
	activated during this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

-- function love.update(dt)
function love.update(dt)
	-- scroll background by preset speed * dt, looping back to 0
	-- after the looping point
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

	-- scroll ground by preset speed * dt, looping back to 0
	-- after the screen width passes
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
		% GROUND_LOOPING_POINT

	spawnTimer = spawnTimer + dt

	-- spawn a new PipePair if the timer is past 2 seconds
	if spawnTimer > 2 then
		-- modify the last Y coordinate we placed so pipe gaps
		-- aren't too far apart->no higher than 10 pixels below
		-- the top edge of the screen, and no lower than the a
		-- gap length (90 pixels) from the bottom
		local y = math.max(-PIPE_HEIGHT + 10,
			math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
		lastY = y

		table.insert(pipePairs, PipePair(y))
		spawnTimer = 0
	end

	bird:update(dt)

	-- for every pipe in the scene...
	for k, pipe in pairs(pipePairs) do
		pipe:update(dt)
	end

	-- remove any flagged pipes
	-- we need this second loop, rather than deleting in the
	-- previous loop, because modifying the table in-place without
	-- explicit keys will result in skipping the next pipe, since
	-- all implicit keys (numerical indixes) are automatically
	-- shifted down after a table removal
	for k, pair in pairs(pipePairs) do
		if pair.remove then
			table.remove(pipePairs, k)
		end
	end

	-- reset input table
	love.keyboard.keysPressed = {}
end

-- render function
function love.draw()
	push:start()

	-- here, we draw our images shifted to the left by their
	-- looping point; eventually, they will revert back to 0 once
	-- a certain distance has elapsed, which will make it seem as
	-- if they are infinitely scrolling. Choosing a looping point
	-- that is seamless is key, so as to provide the illusion of
	-- looping

	-- draw the background at the negative looping point
	love.graphics.draw(background, -backgroundScroll, 0)

	for k, pair in pairs(pipePairs) do
		pair:render()
	end

	-- draw the ground on top of the background, toward the
	-- bottom of the screen, at its negative looping point
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	-- render our bird to the screen using its own render logic
	bird:render()

	push:finish()
end
