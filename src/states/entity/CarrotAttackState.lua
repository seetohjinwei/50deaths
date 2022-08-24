-- Enemy Carrot Attack State
CarrotAttackState = Class{ __includes = CarrotBaseState }

function CarrotAttackState:enter()
    self.timer = self.entity.fireInterval
end

function CarrotAttackState:update(dt)
    local entity = self.entity
    local hero = entity.hero

    if entity.x < hero.x then
        entity.direction = RIGHT
    else
        entity.direction = LEFT
    end

    self.timer = self.timer - dt

    if self.timer < 0 then
        self.timer = entity.fireInterval

        local projectile = CarrotProjectile.spawn(entity)

        table.insert(hero.level.gameObjects, projectile)
    end

    local displacementX = math.abs(entity.x - hero.x)
    local displacementY = math.abs(entity.y - hero.y)

    if displacementX > entity.idleRadius or displacementY > 5 then
        entity:changeState("idle")
    end

    CarrotBaseState.update(self, dt)
end
