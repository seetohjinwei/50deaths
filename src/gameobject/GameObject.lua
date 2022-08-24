GameObject = Class{}

function GameObject:init(params)
    -- "hero" or "enemy"
    self.target = params.target

    self.x = params.x
    self.y = params.y

    self.width = params.width
    self.height = params.height

    self.texture = params.texture
    self.frame = params.frame

    -- prevent consuming twice within 0.5 seconds
    self.consumeLock = 0
    -- reusable -> don't disappear on consume
    self.reusable = params.reusable or false
    self.onConsume = params.onConsume

    self.destroyable = params.destroyable or false
    self.shouldDestroy = false
end

function GameObject:update(dt)
    if self.consumeLock > 0 then
        self.consumeLock = self.consumeLock - dt
    end
end

function GameObject:render()
    if self.shouldDestroy then
        -- don't render if marked for destroy
        return
    end

    love.graphics.draw(GlobalTextures[self.texture], GlobalTextures[self.texture][self.frame], self.x, self.y)
end

-- `other` table should have x, y, height, width
function GameObject:doesCollide(other, leewayX, leewayY)
    return DoesCollide(self, other, leewayX, leewayY)
end

-- Returns true if the object is to be removed.
function GameObject:consume(param)
    if self.onConsume == nil then
        return false
    end
    -- if not reusable, ignore consumeLock
    if self.reuseable and self.consumeLock > 0 then
        return false
    end
    -- re-lock the consume
    self.consumeLock = 0.5
    self.onConsume(param)

    return not self.reusable
end
