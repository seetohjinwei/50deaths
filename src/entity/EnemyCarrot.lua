EnemyCarrot = Class{ __includes = Enemy }

function EnemyCarrot:init(params)
    params.animations = ENTITY_DEFS['enemy-carrot'].animations
    params.width = 16
    params.height = 16 / 606 * 506
    Enemy.init(self, params)

    self.stateMachine = StateMachine{
        ["idle"] = function()
            return CarrotIdleState(self)
        end,
        ["attack"] = function()
            return CarrotAttackState(self)
        end,
    }

    -- align with floor
    self.y = self.y + (16 - self.height)
    self.hp = 20 * self.modifier

    self.fireInterval = 1 / self.modifier
    self.attackRadius = 6 * TILE_SIZE * self.modifier
    self.idleRadius = 8 * TILE_SIZE * self.modifier
    self.projectileSpeed = 3 * TILE_SIZE * (self.modifier / 2)
    self.projectileDistance = self.attackRadius
end
