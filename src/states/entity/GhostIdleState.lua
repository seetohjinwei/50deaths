-- Enemy Ghost Idle State
-- Patrols a certain radius
GhostIdleState = Class{ __includes = GhostBaseState }

function GhostIdleState:enter(_)
    local entity = self.entity
    self.centerX = entity.x
end

function GhostIdleState:update(dt)
    -- ghost will patrol back & forth
    local entity = self.entity
    local hero = entity.hero
    local patrolRadius = entity.patrolRadius

    local dx = dt * entity.moveSpeed
    if entity.direction == LEFT then
        entity.x = entity.x - dx
        if entity.x < 0 then
            entity.direction = RIGHT
            entity.x = 0
        elseif entity.x < self.centerX - patrolRadius then
            entity.direction = RIGHT
            entity.x = self.centerX - patrolRadius
        end
    else
        entity.x = entity.x + dx
        if entity.x > ROOM_WIDTH * TILE_SIZE - entity.width then
            entity.direction = LEFT
            entity.x = ROOM_WIDTH * TILE_SIZE - entity.width
        elseif entity.x > self.centerX + patrolRadius then
            entity.direction = LEFT
            entity.x = self.centerX + patrolRadius
        end
    end

    local displacementX = math.abs(entity.x - hero.x)
    local displacementY = math.abs(entity.y - hero.y)
    if displacementX < 3 * TILE_SIZE and displacementY < 5 then
        entity:changeState("attack")
    end

    GhostBaseState.update(self, dt)
end
