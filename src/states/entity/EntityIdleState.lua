EntityIdleState = Class{ __includes = EntityBaseState }

function EntityIdleState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("idle")
end
