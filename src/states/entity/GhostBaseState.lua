GhostBaseState = Class{ __includes = EntityBaseState }

function GhostBaseState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end

function GhostBaseState:update(_)
    local entity = self.entity

    -- prevent ghost from moving out of bounds
    if entity.x < 0 then
        entity.x = 0
    elseif entity.x > ROOM_WIDTH * TILE_SIZE - entity.width then
        entity.x = ROOM_WIDTH * TILE_SIZE - entity.width
    end
end

function GhostBaseState:render()
    local entity = self.entity
    local animation = entity.currentAnimation

    local scaleX = entity.width / 439
    local scaleY = entity.height / 554

    if DEBUG_MODE then
        love.graphics.rectangle("line", entity.x, entity.y, entity.width, entity.height)
    end

    -- red flash on taking damage
    if entity.damageFlash then
        love.graphics.setColor(1, 0.8, 0.8)
    end

    if entity.direction == LEFT then
        animation:renderCurrentFrame(GlobalFrames['enemy-ghost'], entity.x, entity.y, 0, scaleX, scaleY)
    else
        animation:renderCurrentFrame(GlobalFrames['enemy-ghost'], entity.x, entity.y, 0, -scaleX, scaleY, entity.width / scaleX, 0)
    end

    love.graphics.setColor(1, 1, 1)
end
