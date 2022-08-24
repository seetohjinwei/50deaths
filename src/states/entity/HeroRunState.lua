HeroRunState = Class{ __includes = HeroBaseState }

local tweenDuration = 0.1

function HeroRunState:init(entity)
    HeroBaseState.init(self, entity)
    self.entity:changeAnimation("run")
end

function HeroRunState:enter(_)
    local toX = self.entity.x
    local direction = self.entity.direction

    if direction == LEFT then
        toX = toX - self.entity.moveSpeed
    elseif direction == RIGHT then
        toX = toX + self.entity.moveSpeed
    end

    -- prevent player from going out of bounds
    toX = math.max(0, toX)
    toX = math.min(ROOM_WIDTH * TILE_SIZE - self.entity.width, toX)

    Timer.tween(tweenDuration, {
        [self.entity] = {
            x = toX,
        }
    }):finish(function()
        self:handleInput()
    end)
end

function HeroRunState:update(dt)
    -- don't accept input while running
    HeroBaseState.update(self, dt, false)
end
