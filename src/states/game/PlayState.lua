PlayState = Class{ __includes = BaseState }

function PlayState:enter(params)
    if params.level < BOSS_LEVEL then
        self.level = Level(params)
        local tiles, enemies, objects = self.level:generate(self.level.height, self.level.width)

        self.level.tiles = tiles

        for _, enemy in pairs(enemies) do
            table.insert(self.level.enemies, enemy)
        end

        for _, object in pairs(objects) do
            table.insert(self.level.gameObjects, object)
        end
    else
        self.level = BossLevel(params)
        self.level.tiles = self.level:generate()
    end
end

function PlayState:update(dt)
    if love.keyboard.isDown("p") then
        GlobalStateStack:push(PauseState())
    end

    self.level:update(dt)
end

function PlayState:render()
    -- #333333 dark gray background
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    self.level:render()
end
