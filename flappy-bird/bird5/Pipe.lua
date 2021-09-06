--[[
	Pipe Class
	Author: Lacey Gruwell
	lsikes@csumb.edu

	The Pipe Class represents the pipes that randomly spawn in our
	game, which act as our primary obstacles. The pipes can stick
	out a random distance from the top of bottom of the screen.
	When the player collides with one of them, it's game over. 
	Rather than our bird actually moving through the screen
	horizontally, the pipes themselves scroll through the game to
	give the illusion of player movement.
]]

Pipe = Class{}

-- since we only want the iamge loaded once, not per instantation,
-- define it externally
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

local PIPE_SCROLL = -60

function Pipe:init()
	self.x = VIRTUAL_WIDTH

	-- set the Y to a random value halfway below the screen
	self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

	self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
	self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
	love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
end
