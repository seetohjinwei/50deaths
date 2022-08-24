EnemyMarshmallow = Class{ __includes = Enemy }

function EnemyMarshmallow:init(params)
    params.animations = ENTITY_DEFS['enemy-marshmallow'].animations
    params.width = 16
    params.height = 16 / 350.5 * 204
    Enemy.init(self, params)

    -- marshmallow is simpler and only has 1 state
    self.stateMachine = StateMachine{
        ["idle"] = function()
            return MarshmallowIdleState(self)
        end
    }

    -- align with floor
    self.y = self.y + (16 - self.height)
    self.hp = 10 * self.modifier
    self.collisionDamage = 2 * self.modifier
end
