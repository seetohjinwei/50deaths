BossIdleState = Class{ __includes = BossBaseState }

function BossIdleState:init(entity)
    BossBaseState.init(self, entity)
    self.entity:changeAnimation("run")
end

function BossIdleState:update(dt)
    local entity = self.entity
    local hero = entity.hero

    local dx = dt * entity.moveSpeed
    if entity.x > hero.x then
        entity.direction = LEFT
        entity.x = entity.x - dx
    else
        entity.direction = RIGHT
        entity.x = entity.x + dx
    end

    local displacement = math.abs(entity.x - hero.x)
    if displacement < 5 * TILE_SIZE then
        entity:changeState("attack")
    end

    BossBaseState.update(self, dt)
end
