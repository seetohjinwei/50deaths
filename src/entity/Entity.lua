--[[
    This code is based on the Entity provided in cs50g pokemon's source code.

    Added:
    1. Status Effects
    2. HP functions
]]

Entity = Class{}

function Entity:init(params)
    self.direction = params.direction or RIGHT

    self.animations = Entity.createAnimations(self, params.animations)

    self.width = params.width
    self.height = params.height

    self.x = params.x
    self.y = params.y

    -- stats modifier
    self.modifier = params.modifier or 1

    self.hp = (params.hp or 10) * self.modifier
    self.damageFlash = false

    self.effects = {}

    self.currentState = ""
end

function Entity:createAnimations(animations)
    local createdAnimations = {}

    for k, animationDef in pairs(animations) do
        createdAnimations[k] = Animation{
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
        }
    end

    return createdAnimations
end

function Entity:changeState(name, enterParams)
    self.currentState = name
    self.stateMachine:change(name, enterParams)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    self.stateMachine:update(dt)
    self.currentAnimation:update(dt)

    local toRemove = {}

    for i, effect in pairs(self.effects) do
        effect.duration = effect.duration - dt

        if effect.duration < 0 then
            -- revert the field
            self[effect.field] = effect.oldValue

            if effect.callback ~= nil then
                -- trigger effect callback
                effect.callback()
            end
            table.insert(toRemove, i)
        end
    end

    for _, i in pairs(toRemove) do
        table.remove(self.effects, i)
    end
end

function Entity:render()
    self.stateMachine:render()
end

-- `other` table should have x, y, height, width
function Entity:doesCollide(other, leewayX, leewayY)
    return DoesCollide(self, other, leewayX, leewayY)
end

function Entity:addHP(hpToAdd)
    self.hp = math.min(self.hp + hpToAdd, self.maxHP or 50)

    self:addEffect({
        field = "healFlash",
        value = true,
        duration = 0.2,
    })
end

function Entity:removeHP(hpToRemove)
    self.hp = math.max(self.hp - hpToRemove, 0)

    self:addEffect({
        field = "damageFlash",
        value = true,
        duration = 0.2,
    })
end

--[[
    local effect = {
        field = "field of entity to affect", will be reverted back
        value = new value of field,
        oldValue = value to revert back to, leave as nil if revert back to original,
        duration = in seconds,
        callback = callback function after effect ends,
    }
]]

-- If adding effect with same field, override the previous effect.
function Entity:addEffect(effect)
    for _, e in pairs(self.effects) do
        -- if same field, override previous
        if e.field == effect.field then
            e.name = effect.name
            e.value = effect.value
            e.oldValue = effect.oldValue or e.oldValue
            e.duration = math.max(effect.duration)
            e.callback = effect.callback
            return
        end
    end

    local field = effect.field
    local oldValue = effect.oldValue or self[field]
    self[field] = effect.value

    -- shallow copy the effect to not mutate it
    local toAdd = {
        name = effect.name,
        field = effect.field,
        value = effect.value,
        oldValue = oldValue,
        duration = effect.duration,
        callback = effect.callback,
    }

    table.insert(self.effects, toAdd)
end

-- Undos all effects.
function Entity:clearEffects()
    for _, effect in pairs(self.effects) do
        self[effect.field] = effect.oldValue
    end

    self.effects = {}
end
