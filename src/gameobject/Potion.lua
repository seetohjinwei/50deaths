Potion = Class{ __includes = GameObject }

function Potion:init(params)
    GameObject.init(self, params)

    self.width = 8
    self.height = 8

    -- oscillating logic
    self.initialY = self.y
    self.y = self.y + 4
    self.oscillatingUp = true
end

function Potion:update(dt)
    -- Every 3 seconds complete one oscillation.
    local dy = dt * (8 / 3)
    local invert = self.oscillatingUp and -1 or 1
    self.y = self.y + dy * invert

    local offsetY = self.y - self.initialY

    if offsetY >= 4 then
        self.y = self.initialY + 4
        self.oscillatingUp = true
    elseif offsetY <= -4 then
        self.y = self.initialY - 4
        self.oscillatingUp = false
    end

    GameObject.update(self, dt)
end

-- Animates it oscillating up * down.
function Potion:render()
    if DEBUG_MODE then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end

    local scale = 8 / 375
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(GlobalTextures[self.texture], self.x, self.y, 0, scale, scale)
end

-- Factory method to construct a Jump Potion at (x, y) for hero.
function Potion.jump(x, y, reusable, hero)
    -- Used for jumping to next level.
    JUMP_BOOST = {
        name = "Jump Boost",
        field = "jumpHeight",
        value = 5 * TILE_SIZE,
        duration = 0.5,
    }

    return Potion{
        x = x,
        y = y,
        target = "hero",
        texture = 'potion-jump',
        reusable = reusable,
        onConsume = function ()
            hero:addEffect(JUMP_BOOST)
        end,
    }
end

-- Factory method to construct a Speed Potion at (x, y) for hero.
function Potion.speed(x, y, reusable, hero)
    SPEED_BOOST = {
        name = "Speed Boost",
        field = "moveSpeed",
        value = hero.moveSpeed * 1.5,
        duration = 5,
    }

    return Potion{
        x = x,
        y = y,
        target = "hero",
        texture = 'potion-speed',
        reusable = reusable,
        onConsume = function ()
            hero:addEffect(SPEED_BOOST)
        end,
    }
end

-- Factory method to construct a HP Potion at (x, y) for hero.
function Potion.HP(x, y, reusable, hero)
    return Potion{
        x = x,
        y = y,
        target = "hero",
        texture = 'potion-hp',
        reusable = reusable,
        onConsume = function ()
            hero:addHP(2)
        end,
    }
end
