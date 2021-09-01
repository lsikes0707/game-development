--[[
	GD50 2021
	Pong Remake

	-- Ball Class --

	Author: Lacey Gruwell
	lsikes@csumb.edu

	Represents a ball which will bounce back and forth between
	paddles and walls until it passes left or right boundary of
	the screen, scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
	self.x = x
	self.y = y
	self.width = width
	self.height = height

	-- these variables are for keeping track of our velocity on
	-- both the X and Y axis, since the ball can move in two
	-- dimensions
	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

--[[
	function Ball:collides(paddle)
	Expects a paddle as an argument and returns true or false,
	depending on wheter their rectangles overlap
]]
function Ball:collides(paddle)
	-- first, check to see if the left edge of either is farther
	-- to the right than the right edge of the other
	if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
		return false
	end

	-- then check to see if the bottomw edge of either is higher
	-- than the top edge of the other
	if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
		return false
	end

	-- if the above aren't true, they're overlapping
	return true
end

--[[
	Places the ball in the middle of the screen, with an initial
	random velocity on both axes.
]]
function Ball:reset()
	self.x = VIRTUAL_WIDTH / 2 - 2
	self.y = VIRTUAL_HEIGHT / 2 - 2
	self.dy = math.random(2) == 1 and -100 or 100
	self.dx = math.random(-50, 50)
end

--[[
	Simply applied velocity to position, scaled by DeltaTime.
]]
function Ball:update(dt)
	self.x = self.x + self.dx * dt
	self.y = self.y + self.dy * dt
end

function Ball:render()
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
