HeroJumpState = Class{ __includes = HeroBaseState }

local jumpDuration = 0.3

function HeroJumpState:init(entity)
    HeroBaseState.init(self, entity)
    self.entity:changeAnimation("jump")
end

function HeroJumpState:enter(_)
    local hero = self.entity
    local jumpHeight = hero.jumpHeight
    local toY = hero.y - jumpHeight

    for check = 0, jumpHeight, (TILE_SIZE / 2) do
        local futureHero = {
            x = hero.x,
            y = hero.y - check,
            height = hero.height,
            width = hero.height,
        }
        local leeway = 2.5

        local leftCeilingTile = hero.level:getNearestTile(futureHero.x + leeway, futureHero.y + 1)
        local rightCeilingTile = hero.level:getNearestTile(futureHero.x + futureHero.width - leeway, futureHero.y + 1)

        self.leftCeilingTile = leftCeilingTile
        self.rightCeilingTile = rightCeilingTile

        if leftCeilingTile ~= nil and DoesCollide(futureHero, leftCeilingTile) then
            toY = math.max(leftCeilingTile.y + leftCeilingTile.height, futureHero.y)
            hero.leftCeilingTile = leftCeilingTile
            break
        elseif rightCeilingTile ~= nil and DoesCollide(futureHero, rightCeilingTile) then
            toY = math.max(rightCeilingTile.y + rightCeilingTile.height, futureHero.y)
            hero.rightCeilingTile = rightCeilingTile
            break
        end
    end

    -- prevent player from going out of bounds
    toY = math.max(1, toY)
    toY = math.min(ROOM_HEIGHT * TILE_SIZE - self.entity.height, toY)

    Timer.tween(jumpDuration, {
        [self.entity] = {
            y = toY,
        }
    }):finish(function()
        self:handleInput()
    end)
end
