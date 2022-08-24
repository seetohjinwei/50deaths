Hero = Class{ __includes = Entity }

function Hero:init(params)
    Entity.init(self, params)

    self.stateMachine = StateMachine{
        ["attack"] = function()
            return HeroAttackState(self)
        end,
        ["idle"] = function()
            return HeroIdleState(self)
        end,
        ["jump"] = function()
            return HeroJumpState(self)
        end,
        ["run"] = function()
            return HeroRunState(self)
        end,
    }

    self.dy = 0

    local stats = params.stats

    self.score = stats.score
    self.maxHP = stats.maxHP
    self.hp = stats.hp
    self.moveSpeed = stats.moveSpeed
    self.meleeDamage = stats.meleeDamage
    self.rangedDamage = stats.rangedDamage
    self.rangedSpeed = stats.rangedSpeed
    self.rangedDistance = stats.rangedDistance

    self.onGround = true
    self.jumpHeight = 2 * TILE_SIZE
    self.attackCooldown = 0

    self.invulnerable = false
    self.invulnFlashDuration = 0.4
    self.invulnFlashTimer = 0
end

function Hero:update(dt)
    -- attackCooldown!
    if self.attackCooldown > 0 then
        self.attackCooldown = self.attackCooldown - dt
    end

    if self.hp <= 0 then
        -- Game Over!
        -- pop PlayState, push GameOverState
        GlobalStateStack:pop()
        GlobalStateStack:push(GameOverState(), {
            score = self.score,
        })
    end

    Entity.update(self, dt)
end

function Hero:render()
    Entity.render(self)

    love.graphics.setColor(1, 1, 1, 1)

    -- render HP on top left
    -- 1 HP = 1 heart
    -- hearts that are lost are monochrome
    local x = 10
    local y = 10

    if self.damageFlash then
        love.graphics.setColor(1, 1, 1, 0.5)
    end
    for i = 1, self.maxHP do
        local texture
        if i <= math.ceil(self.hp) then
            texture = 'heart'
        else
            texture = 'heart2'
        end
        love.graphics.draw(GlobalTextures[texture], x + (i - 1) * 16, y)
    end
    love.graphics.setColor(1, 1, 1, 1)

    -- render effects on top right
    local effectsToShow = {}

    for _, effect in pairs(self.effects) do
        -- skip render effect on top right if no name
        if effect.name ~= nil then
            table.insert(effectsToShow, effect)
        end
    end

    local numberOfEffects = #effectsToShow + 1

    local x = VIRTUAL_WIDTH - 60
    local y = 0
    local width = 60
    local height = numberOfEffects * 10
    love.graphics.setColor(64 / 255, 64 / 255, 64 / 255, 1)
    love.graphics.rectangle("fill", x, y, width, height)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["small"])

    -- render score
    love.graphics.printf("Score: " .. math.ceil(self.score), x, y, width, "left")

    for i, effect in pairs(effectsToShow) do
        love.graphics.printf(effect.name .. ": " .. math.ceil(effect.duration), x, y + i * 10, width, "left")
    end

    love.graphics.setColor(1, 1, 1, 1)
end

-- Checks if hero is colliding with floor, if so, teleport player up and return true.
-- Else, do nothing and return false.
function Hero:checkFloorCollision()
    local leeway = 2.5
    self.leftFloorTile = self.level:getNearestTile(self.x + leeway, self.y + self.height)
    self.rightFloorTile = self.level:getNearestTile(self.x + self.width - leeway, self.y + self.height)

    local leewayX = 1
    local leewayY = 2.5

    if self.leftFloorTile ~= nil and self:doesCollide(self.leftFloorTile, leewayX, leewayY) then
        self.dy = 0
        if not self.onGround then
            self.onGround = true
            love.audio.play(GlobalSounds['jump-land'])
        end
        self.y = math.min(self.leftFloorTile.y - self.height, self.y)
        return true
    elseif self.rightFloorTile ~= nil  and self:doesCollide(self.rightFloorTile, leewayX, leewayY) then
        self.dy = 0
        if not self.onGround then
            self.onGround = true
            love.audio.play(GlobalSounds['jump-land'])
        end
        self.y = math.min(self.rightFloorTile.y - self.height, self.y)
        return true
    end

    self.onGround = false
    return false
end

function Hero:removeHP(hpToRemove, overrideInvuln)
    -- don't remove HP if invulnerable (unless overriding)
    if self.invulnerable and overrideInvuln ~= true then
        return
    end

    -- turn invulnerable for 1 second
    Entity.addEffect(self, {
        field = "invulnerable",
        value = true,
        duration = 1,
    })
    -- give slight speed boost
    Entity.addEffect(self, {
        field = "moveSpeed",
        value = self.moveSpeed * 1.5,
        duration = 0.5,
    })

    Entity.removeHP(self, hpToRemove)
end
