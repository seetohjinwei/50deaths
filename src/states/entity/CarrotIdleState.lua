-- Enemy Carrot Idle State
CarrotIdleState = Class{ __includes = CarrotBaseState }

function CarrotIdleState:update(dt)
    local entity = self.entity
    local hero = entity.hero

    if entity.x < hero.x then
        entity.direction = RIGHT
    else
        entity.direction = LEFT
    end

    local displacementX = math.abs(entity.x - hero.x)
    local displacementY = math.abs(entity.y - hero.y)

    if displacementX < entity.attackRadius and displacementY < 5 then
        entity:changeState("attack")
    end

    CarrotBaseState.update(self, dt)
end
