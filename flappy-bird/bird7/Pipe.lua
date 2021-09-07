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

PIPE_SPEED = 60
PIPE_HEIGHT = 288

-- height of pipe image, globally accessiblePIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
	self.x = VIRTUAL_WIDTH
	self.y = y

	self.width = PIPE_WIDTH
	self.height = PIPE_HEIGHT

	self.orientation = orientation
end

function Pipe:update(dt)

end

function Pipe:render()
	love.graphics.draw(PIPE_IMAGE, self.x,
		(self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
		0, 1, self.orientation == 'top' and -1 or 1)
end
