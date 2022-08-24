--[[
    This code is pretty much the same as the StateMachine provided in cs50g pokemon's source code.
]]

StateMachine = Class{}

local emptyState = {
    update = function(self, dt) end,
    render = function(self) end,
    processAI = function(self, params, dt) end,
    enter = function(self, params) end,
    exit = function(self) end,
}

function StateMachine:init(states)
    self.states = states or {}
    self.current = emptyState
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end

function StateMachine:processAI(params, dt)
    self.current:processAI(params, dt)
end
