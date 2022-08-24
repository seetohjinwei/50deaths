HeroAttackState = Class{ __includes = HeroBaseState }

function HeroAttackState:init(entity)
    HeroBaseState.init(self, entity)
    self.entity:changeAnimation("attack")
end

function HeroAttackState:update(dt)
    -- don't accept input while attacking
    HeroBaseState.update(self, dt, false)
end

function HeroAttackState:enter(params)
    local hero = self.entity

    self.attackType = params.attackType

    if self.attackType == "melee" then
        local width = math.floor(hero.width * 3 / 4)
        -- hitbox of melee attack intersects with hero slightly
        -- so that player can melee attack enemies that walk into the player
        local offsetX = hero.direction == LEFT and (-8) or (hero.width - 4)
        local attackDuration = 0.15 * 3

        self.hitbox = {
            x = hero.x + offsetX,
            y = hero.y,
            width = width,
            height = hero.height,
        }

        -- Regular level.
        if hero.level.enemies ~= nil then
            for _, enemy in pairs(hero.level.enemies) do
                if enemy:doesCollide(self.hitbox) then
                    love.audio.play(GlobalSounds['hit'])
                    enemy:removeHP(hero.meleeDamage)
                end
            end
        end

        -- Boss level.
        if hero.level.boss ~= nil then
            if hero.level.boss:doesCollide(self.hitbox) then
                love.audio.play(GlobalSounds['hit'])
                hero.level.boss:removeHP(hero.meleeDamage)
            end
        end

        for _, object in pairs(hero.level.gameObjects) do
            -- allow hero to objects that target it
            if object.target == "hero" and object:doesCollide(self.hitbox) and object.destroyable then
                love.audio.play(GlobalSounds['hit'])
                object.shouldDestroy = true
            end
        end

        hero.attackCooldown = attackDuration

        Timer.after(attackDuration, function ()
            self:handleInput()
        end)
    elseif self.attackType == "range" then
        local fireball = Fireball.spawn(hero)
        table.insert(hero.level.gameObjects, fireball)

        local attackDuration = 0.15 * 3

        hero.attackCooldown = attackDuration + 0.2
        Timer.after(attackDuration, function ()
            self:handleInput()
        end)
    else
        -- invalid attackType -> go back to idle

        hero:changeState("idle")
    end
end

function HeroAttackState:render()
    if DEBUG_MODE then
        local hitbox = self.hitbox
        if hitbox ~= nil then
            love.graphics.rectangle("line", hitbox.x, hitbox.y, hitbox.width, hitbox.height)
        end
    end

    HeroBaseState.render(self)
end
