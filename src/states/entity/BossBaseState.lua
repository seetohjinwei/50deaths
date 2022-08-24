BossBaseState = Class{ __includes = EntityBaseState }

function BossBaseState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end

function BossBaseState:update(_)
    local entity = self.entity

    -- prevent boss from moving out of bounds
    if entity.x < 0 then
        entity.x = 0
    elseif entity.x > ROOM_WIDTH * TILE_SIZE - entity.width then
        entity.x = ROOM_WIDTH * TILE_SIZE - entity.width
    end
end

function BossBaseState:render()
    local entity = self.entity
    local animation = entity.currentAnimation

    if DEBUG_MODE then
        love.graphics.rectangle("line", entity.x, entity.y, entity.width, entity.height)
    end

    -- red flash on taking damage
    if entity.damageFlash then
        love.graphics.setColor(1, 0.8, 0.8)
    end

    if entity.direction == LEFT then
        -- need to provide offset
        animation:renderCurrentFrame(HeroQuad, entity.x, entity.y, 0, -4, 4, 16, 0)
    else
        animation:renderCurrentFrame(HeroQuad, entity.x, entity.y, 0, 4, 4, 0, 0)
    end
    love.graphics.setColor(1, 1, 1, 1)
end
