local Turret = class("Turret", Level)

local botImage = love.graphics.newImage("assets/gfx/sprites/bot.png")

function Turret:initialize()
	Level.initialize(self)

	self.name = "turret"


	self.requiredScore = 30


	self.turret = {
		x = 400,
		y = 400,
		width = 36 * 1.5,
		height = 35 * 1.5,
		rotation = 0,
		headImage = love.graphics.newImage("assets/gfx/sprites/turretHead.png"),
		baseImage = love.graphics.newImage("assets/gfx/sprites/turretBase.png"),
	}

	self.bots = {}
	self.botSpeed = 120

	self.bullets = {}
	self.bulletSpeed = 500
	self.shootCooldown = 0 


	self.t = {
		rotate = function(r) self.turret.rotation = self.turret.rotation + r end,
		getRotation = function() return self.turret.rotation end,
		shoot = function() self:shoot() end,
	}

	self.environment = {
		turret = self.t,
		getBots = function() return self.bots end
	}

	self.reference = {
		{"turret.rotate(r)", "Rotate turret by r radians"},
		{"turret.getRotation()", "Returns rotation of turret"},
		{"turret.shoot()", "Shoot bullet"},
		{"getBots()", "Returns a table of all bots"},
		{"bot.x", "X-coordinate of a bot"},
		{"bot.y", "Y-coordinate of a bot"},

	}

	self.objectiveWindow = window:new(1920 / 2 - 650 / 2, 1080 / 2 - 300/2, 650, 200)
	self.objectiveWindow.drawContent = function()
		love.graphics.print("Survive for 30 seconds by shooting enemies", 650 / 2 - game.font:getWidth("Survive for 30 seconds by shooting enemies") / 2, 20)
	end
	self.objectiveWindow.visible = true

	self.objectiveWindow:addButton(button:new("Ok", 650/2-game.font:getWidth("Ok"), 125, function()
		self.objectiveWindow.visible = false
		terminal.typing = true
	end))

	self.timer = 0
	self.spawnTimer = 0

	self:newBot()

end

function Turret:update(dt)
	self.timer = self.timer + dt
	self.testScore = math.floor(self.timer) 

	self.spawnTimer = self.spawnTimer + dt
	if self.spawnTimer >= 2 then
		self:newBot()
		self.spawnTimer = 0
	end

	self.shootCooldown = self.shootCooldown - dt

	for i,v in pairs(self.bots) do
		v.x = v.x + math.cos(v.angle) * self.botSpeed * dt
		v.y = v.y + math.sin(v.angle) * self.botSpeed * dt
	end
	for i,v in pairs(self.bullets) do
		v.x = v.x + math.cos(v.angle) * self.bulletSpeed * dt
		v.y = v.y + math.sin(v.angle) * self.bulletSpeed * dt

		for j, k in pairs(self.bots) do
			if rectangleCollision(v.x, v.y, 3, 3, k.x, k.y, 15*3, 29*3) then 
				self.bots[k.id] = nil
				self.bullets[v.id] = nil
			end
		end
	end
end

function Turret:draw()

	love.graphics.draw(self.turret.baseImage, self.turret.x, self.turret.y, 0, 3)
	love.graphics.draw(self.turret.headImage, self.turret.x + 29, self.turret.y + 30, self.turret.rotation, 3, 3, 7, 20)

	for i,v in pairs(self.bots) do
		love.graphics.draw(botImage, v.x, v.y, 0, 3, 3)
	end

	love.graphics.setColor(1,1,0)
	for i,v in pairs(self.bullets) do
		love.graphics.rectangle("fill", v.x, v.y, 3, 3)
	end
	love.graphics.setColor(1,1,1)

	game:fontSize(30)

	love.graphics.print(self.testScore, 400 - game.font:getWidth(self.testScore) / 2, 20)

	game:fontSize(20)
end	

function Turret:restart()
	self.testScore = 0
	self.timer = 0

	self.turret.rotation = 0
	self.bullets = {}
	self.bots = {}
end


function Turret:newBot()
	local xPos = {-100, 900}
	local yPos = {-100, 900}
	local x, y

	if math.random(1, 2) == 1 then -- Decide position
		x = math.random(0, 800)
		y = yPos[math.random(1, 2)]
	else
		x = xPos[math.random(1, 2)]
		y = math.random(0, 800)
	end
	local bot = {
		x = x,
		y = y,
		angle = math.atan2(self.turret.y - y , self.turret.x - x),
		id = #self.bots
	}

	table.insert(self.bots, bot)
end

function Turret:shoot()
	if self.shootCooldown <= 0 then 
		table.insert(self.bullets, {x = self.turret.x + 10, y = self.turret.y, angle = self.turret.rotation - math.pi/2, id = #self.bullets})
		self.shootCooldown = 1
	end
end



return Turret:new()