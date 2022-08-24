EntityRunState = Class{ __includes = EntityBaseState }

function EntityRunState:init(entity)
    EntityBaseState.init(self, entity)
    self.entity:changeAnimation("run")
end
