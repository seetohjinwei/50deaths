CarrotProjectile = Class{ __includes = GameObject }

function CarrotProjectile:init(params)
    GameObject.init(self, params)

    self.direction = params.direction

    self.speed = params.speed
    self.distance = params.distance
    self.distanceTravelled = 0

    self.onConsume = function(hero)
        love.audio.play(GlobalSounds['hit'])
        hero:removeHP(1)
        self.shouldDestroy = true
    end
end

-- Factory method to construct a projectile for carrot.
function CarrotProjectile.spawn(carrot)
    local offsetX = carrot.direction == LEFT and -12 or carrot.width + 4

    return CarrotProjectile{
        x = carrot.x + offsetX,
        y = carrot.y + 4,
        target = "hero",
        direction = carrot.direction,
        width = 8,
        height = 8 / 606 * 506,
        texture = '',
        reusable = false,
        destroyable = true,
        speed = carrot.projectileSpeed,
        distance = carrot.projectileDistance,
        -- actual onConsume created in `init` function because requires reference to self.
    }
end

function CarrotProjectile:update(dt)
    local dx = self.speed * dt
    self.distanceTravelled = self.distanceTravelled + dx

    local invert = self.direction == LEFT and -1 or 1
    self.x = self.x + dx * invert

    if self.distanceTravelled >= self.distance then
        self.shouldDestroy = true
    end
end

function CarrotProjectile:render()
    if self.shouldDestroy then
        -- don't render if marked for destroy
        return
    end

    if DEBUG_MODE then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end

    local scaleX = self.width / 606
    local scaleY = self.height / 506

    love.graphics.setColor(1, 1, 1)
    -- using enemy carrot & just rotating it (so tiny can't really see much, so just use first frame for simplicity)
    if self.direction == LEFT then
        love.graphics.draw(GlobalTextures['enemy-carrot'], GlobalFrames['enemy-carrot'][1], self.x, self.y + self.height, -math.pi / 2, scaleX, scaleY)
    else
        love.graphics.draw(GlobalTextures['enemy-carrot'], GlobalFrames['enemy-carrot'][1], self.x + self.width, self.y, math.pi / 2, scaleX, scaleY)
    end
end
