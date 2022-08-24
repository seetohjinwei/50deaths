HeroIdleState = Class{ __includes = HeroBaseState }

function HeroIdleState:init(entity)
    HeroBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end
