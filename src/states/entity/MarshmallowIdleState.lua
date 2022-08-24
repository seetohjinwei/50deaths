-- Enemy Marshmallow Idle State
MarshmallowIdleState = Class{ __includes = EntityBaseState }

function MarshmallowIdleState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end

function MarshmallowIdleState:update(dt)
    -- marshmallow will always look at the hero
    local entity = self.entity
    local hero = entity.hero

    if entity.x < hero.x then
        entity.direction = RIGHT
    else
        entity.direction = LEFT
    end

    EntityBaseState.update(self, dt)
end

function MarshmallowIdleState:render()
    local entity = self.entity
    local animation = entity.currentAnimation

    local scaleX = entity.width / 350.5
    local scaleY = entity.height / 204

    if DEBUG_MODE then
        love.graphics.rectangle("line", entity.x, entity.y, entity.width, entity.height)
    end

    -- red flash on taking damage
    if entity.damageFlash then
        love.graphics.setColor(1, 0.8, 0.8)
    end

    if entity.direction == LEFT then
        animation:renderCurrentFrame(GlobalFrames['enemy-marshmallow'], entity.x, entity.y, 0, scaleX, scaleY)
    else
        animation:renderCurrentFrame(GlobalFrames['enemy-marshmallow'], entity.x, entity.y, 0, -scaleX, scaleY, entity.width / scaleX, 0)
    end

    love.graphics.setColor(1, 1, 1)
end
