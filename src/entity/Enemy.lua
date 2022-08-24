Enemy = Class{ __includes = Entity }

function Enemy:init(params)
    Entity.init(self, params)

    self.collisionDamage = params.collisionDamage or 1
    self.hero = params.hero
    self.immuneToProjectiles = params.immuneToProjectiles or false
end
