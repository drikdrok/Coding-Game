math.randomseed(os.time())
love.graphics.setDefaultFilter("nearest", "nearest")
require("assets/codebase/core/require")


function love.load()

	console = console:new()
	game = game:new()
	terminal = terminal:new()
	menu = menu:new()

	love.graphics.setLineWidth(3)
	love.keyboard.setKeyRepeat(true)

	game:loadLevel("start")
end

function love.update(dt)
	game:update(dt)
	love.window.setTitle("Coding Game "..love.timer.getFPS().."FPS")
end


function love.draw()
	game:draw()
end

function love.keypressed(key)
	terminal:keypressed(key)
	game:keypressed(key)

end

function love.textinput(text)
	terminal:textinput(text)
end

function love.mousepressed(x, y, b)
	game:mousepressed(x, y, b)
end

function love.wheelmoved(x, y)
	console:wheelmoved(y)
end


--Puzzle ideas
-- Create a chess AI
-- Flappy bird AI
-- Pong AI
-- Sort words alphabetically
-- Informatik trains
-- Pacman AI
-- Basket ball - calculate trajectory of ball
