HeroBaseState = Class{ __includes = EntityBaseState }

function HeroBaseState:update(dt, acceptInput)
    local hero = self.entity

    if hero.invulnerable then
        hero.invulnFlashTimer = hero.invulnFlashTimer - dt
        if hero.invulnFlashTimer < 0 then
            hero.invulnFlashTimer = hero.invulnFlashDuration
        end
    end

    if not hero:checkFloorCollision() then
        hero.dy = hero.dy + GRAVITY * dt
        hero.y = hero.y + hero.dy
    end

    -- default to true
    if acceptInput == nil or acceptInput == true then
        self:handleInput()
    end
end

function HeroBaseState:handleInput()
    local hero = self.entity

    -- handle direction change
    -- done separately so that while jumping, can still change direction
    if love.keyboard.isDown("left") then
        hero.direction = LEFT
    elseif love.keyboard.isDown("right") then
        hero.direction = RIGHT
    end

    -- handle state change
    if love.keyboard.isDown("up") and hero.onGround then
        -- jump before left/right
        love.audio.play(GlobalSounds['jump'])
        hero:changeState("jump")
    elseif love.keyboard.isDown("z") and hero.attackCooldown <= 0 then
        love.audio.play(GlobalSounds['punch'])
        hero:changeState("attack", {
            attackType = "melee",
        })
    elseif love.keyboard.isDown("x") and hero.attackCooldown <= 0 then
        love.audio.play(GlobalSounds['fireball'])
        hero:changeState("attack", {
            attackType = "range",
        })
    elseif love.keyboard.isDown("left") then
        hero:changeState("run")
    elseif love.keyboard.isDown("right") then
        hero:changeState("run")
    else
        hero:changeState("idle")
    end
end

function HeroBaseState:render()
    local hero = self.entity
    local animation = hero.currentAnimation

    if DEBUG_MODE then
        -- use red for debug
        love.graphics.setColor(1, 0, 0)

        -- hero's bounding box
        love.graphics.rectangle("line", hero.x, hero.y, 16, 16)

        -- tile's bounding box
        local function renderTile(tile)
            if tile ~= nil then
                love.graphics.rectangle("line", tile.x, tile.y, tile.width, tile.height)
            end
        end

        renderTile(self.leftFloorTile)
        renderTile(self.rightFloorTile)
        renderTile(self.leftCeilingTile)
        renderTile(self.rightCeilingTile)

        love.graphics.setColor(1, 1, 1)
    end

    if hero.invulnerable then
        -- if invulnerable, give it a flash
        if hero.invulnFlashTimer < hero.invulnFlashDuration / 2 then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
    end

    if hero.direction == LEFT then
        -- need to provide offset
        animation:renderCurrentFrame(HeroQuad, hero.x, hero.y, 0, -1, 1, 16, 0)
    else
        animation:renderCurrentFrame(HeroQuad, hero.x, hero.y, 0, 1, 1, 0, 0)
    end
    love.graphics.setColor(1, 1, 1, 1)
end
