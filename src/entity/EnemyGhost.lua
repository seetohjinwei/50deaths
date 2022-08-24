EnemyGhost = Class{ __includes = Enemy }

function EnemyGhost:init(params)
    params.animations = ENTITY_DEFS['enemy-ghost'].animations
    params.width = 12 / 554 * 439
    params.height = 12
    params.immuneToProjectiles = true
    Enemy.init(self, params)

    self.stateMachine = StateMachine{
        ["idle"] = function()
            return GhostIdleState(self)
        end,
        ["attack"] = function ()
            return GhostAttackState(self)
        end
    }

    self.hp = 6 * self.modifier

    self.moveSpeed = 0.5 * TILE_SIZE * self.modifier
    self.attackSpeed = 2 * TILE_SIZE * self.modifier
    self.patrolRadius = 1 * TILE_SIZE * self.modifier
end
