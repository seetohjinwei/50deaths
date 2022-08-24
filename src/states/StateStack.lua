--[[
    This code is pretty much the same as the statestack provided in cs50g pokemon's source code.

    Modified to add optional enter parameters when pushing a new state in.
]]

StateStack = Class{}

function StateStack:init()
    self.states = {}
end

function StateStack:update(dt)
    if #self.states <= 0 then
        -- if no states, don't do anything
        return
    end

    -- update most recent state
    self.states[#self.states]:update(dt)
end

function StateStack:render()
    for _, state in ipairs(self.states) do
        state:render()
    end
end

function StateStack:clear()
    self.states = {}
end

function StateStack:push(state, params)
    -- add & enter new state
    table.insert(self.states, state)
    state:enter(params)
end

function StateStack:pop()
    if #self.states <= 0 then
        -- don't pop if nothing left
        return
    end

    -- exit & remove last state
    self.states[#self.states]:exit()
    table.remove(self.states)
end
