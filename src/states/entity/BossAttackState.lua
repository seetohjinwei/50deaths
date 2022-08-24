BossAttackState = Class{ __includes = BossBaseState }

function BossAttackState:init(entity)
    BossBaseState.init(self, entity)
    self.entity:changeAnimation("attack")
end

function BossAttackState:enter()
    self.timer = self.entity.fireInterval
end

function BossAttackState:update(dt)
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

    self.timer = self.timer - dt

    if self.timer < 0 then
        self.timer = entity.fireInterval

        local fireball = Fireball.spawnForBoss(entity)

        table.insert(entity.level.gameObjects, fireball)
    end

    local displacement = math.abs(entity.x - hero.x)
    if displacement > 5 * TILE_SIZE then
        entity:changeState("idle")
    end

    BossBaseState.update(self, dt)
end
