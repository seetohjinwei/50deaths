-- Enemy Ghost Attack State
-- Actively tracks & moves towards player
GhostAttackState = Class{ __includes = GhostBaseState }

function GhostAttackState:update(dt)
    local entity = self.entity
    local hero = entity.hero

    local dx = dt * entity.attackSpeed
    if entity.x < hero.x then
        entity.direction = RIGHT
        entity.x = entity.x + dx
    else
        entity.direction = LEFT
        entity.x = entity.x - dx
    end

    local displacementX = math.abs(entity.x - hero.x)
    local displacementY = math.abs(entity.y - hero.y)
    if displacementX >= 3 * TILE_SIZE or displacementY > 5 then
        entity:changeState("idle")
    end

    GhostBaseState.update(self, dt)
end
