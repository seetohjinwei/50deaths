CarrotBaseState = Class{ __includes = EntityBaseState }

function CarrotBaseState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end

function CarrotBaseState:render()
    local entity = self.entity
    local animation = entity.currentAnimation

    local scaleX = entity.width / 606
    local scaleY = entity.height / 506

    if DEBUG_MODE then
        love.graphics.rectangle("line", entity.x, entity.y, entity.width, entity.height)
    end

    -- red flash on taking damage
    if entity.damageFlash then
        love.graphics.setColor(1, 0.8, 0.8)
    end

    if entity.direction == LEFT then
        animation:renderCurrentFrame(GlobalFrames['enemy-carrot'], entity.x, entity.y, 0, scaleX, scaleY)
    else
        animation:renderCurrentFrame(GlobalFrames['enemy-carrot'], entity.x, entity.y, 0, -scaleX, scaleY, entity.width / scaleX, 0)
    end

    love.graphics.setColor(1, 1, 1)
end
