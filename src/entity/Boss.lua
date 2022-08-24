Boss = Class{ __includes = Enemy }

function Boss:init(params)
    params.animations = ENTITY_DEFS['hero'].animations
    params.width = 64
    params.height = 64
    Enemy.init(self, params)

    self.stateMachine = StateMachine{
        ["idle"] = function()
            return BossIdleState(self)
        end,
        ["attack"] = function()
            return BossAttackState(self)
        end,
    }

    self.hp = 150
    self.maxHP = 150
    self.collisionDamage = 2
    self.direction = LEFT
    self.moveSpeed = 2 * TILE_SIZE
    self.meleeDamage = 2
    self.rangedDamage = 2
    self.fireInterval = 0.8
    self.rangedSpeed = 5 * TILE_SIZE
    self.rangedDistance = 5 * TILE_SIZE
end
