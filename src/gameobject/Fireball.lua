Fireball = Class{ __includes = GameObject }

function Fireball:init(params)
    GameObject.init(self, params)

    self.direction = params.direction

    self.speed = params.speed
    self.distance = params.distance
    self.distanceTravelled = 0

    self.onConsume = function(enemy)
        love.audio.play(GlobalSounds['hit'])
        enemy:removeHP(params.damage)
        self.shouldDestroy = true
    end
end

-- Factory method to construct a Fireball for hero.
function Fireball.spawn(hero)
    local offsetX = hero.direction == LEFT and -8 or hero.width

    return Fireball{
        x = hero.x + offsetX,
        y = hero.y + 4,
        target = "enemy",
        direction = hero.direction,
        width = 8,
        height = 8,
        texture = 'fireball',
        reusable = false,
        damage = hero.rangedDamage,
        speed = hero.rangedSpeed,
        distance = hero.rangedDistance,
        -- actual onConsume created in `init` function because requires reference to self.
    }
end

-- Factory method to construct a Fireball for boss.
function Fireball.spawnForBoss(boss)
    local offsetX = boss.direction == LEFT and -8 or boss.width

    return Fireball{
        x = boss.x + offsetX,
        y = boss.hero.y,
        target = "hero",
        direction = boss.direction,
        width = 16,
        height = 16,
        texture = 'fireball',
        reusable = false,
        damage = boss.rangedDamage,
        speed = boss.rangedSpeed,
        distance = boss.rangedDistance,
        -- actual onConsume created in `init` function because requires reference to self.
    }
end

function Fireball:update(dt)
    local dx = self.speed * dt
    self.distanceTravelled = self.distanceTravelled + dx

    local invert = self.direction == LEFT and -1 or 1
    self.x = self.x + dx * invert

    if self.distanceTravelled >= self.distance then
        self.shouldDestroy = true
    end
end

function Fireball:render()
    if self.shouldDestroy then
        -- don't render if marked for destroy
        return
    end

    if DEBUG_MODE then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end

    local scaleX = self.width / 16
    local scaleY = self.width / 16
    love.graphics.setColor(1, 1, 1)
    if self.direction == LEFT then
        -- need to provide offset
        love.graphics.draw(GlobalTextures[self.texture], self.x, self.y, 0, -scaleX, scaleY, 16)
    else
        love.graphics.draw(GlobalTextures[self.texture], self.x, self.y, 0, scaleX, scaleY)
    end
end
