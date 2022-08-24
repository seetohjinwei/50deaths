--[[
    This code is pretty much the same as the EntityBaseState provided in cs50g pokemon's source code.
]]

EntityBaseState = Class{}

function EntityBaseState:init(entity)
    self.entity = entity
end

function EntityBaseState:update(dt)
end

function EntityBaseState:processAI(params, dt)
end

function EntityBaseState:enter(params)
end

function EntityBaseState:exit()
end

function EntityBaseState:render()
end
