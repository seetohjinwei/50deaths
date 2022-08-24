BossLevel = Class{}

function BossLevel:init(params)
    self.level = params.level
    self.levelOver = false

    self.hero = Hero{
        x = TILE_SIZE,
        y = (ROOM_HEIGHT - 2) * TILE_SIZE - 10,
        width = 16,
        height = 16,
        animations = ENTITY_DEFS['hero'].animations,
        stats = params.heroStats,
    }
    self.hero.level = self
    self.hero:changeState('idle')

    self.boss = Boss{
        x = (ROOM_WIDTH - 6) * TILE_SIZE,
        y = (ROOM_HEIGHT - 5) * TILE_SIZE,
        hero = self.hero,
        modifier = self.enemyModifier,
    }
    self.boss.level = self
    self.boss:changeState('idle')

    self.height = params.height or ROOM_HEIGHT
    self.width = params.width or ROOM_WIDTH

    self.tiles = {}
    self.gameObjects = {}
end

function BossLevel:generate()
    local tiles = {}
    local tileType = Tile.generateRandomType()

    for c = 1, self.width do
        local tileVariation = Tile.generateRandomVariation()

        local tile = Tile{
            r = ROOM_HEIGHT,
            c = c,
            id = tileType * 3 + tileVariation,
        }

        table.insert(tiles, tile)
    end

    return tiles
end

function BossLevel:update(dt)
    -- remove destroyed objects
    local objectsToRemove = {}

    for i, gameObject in pairs(self.gameObjects) do
        local shouldDestroy = gameObject.shouldDestroy

        if not shouldDestroy then
            -- only update gameobject & check collision if not marked for destroy
            gameObject:update(dt)

            if gameObject.target == "hero" and gameObject:doesCollide(self.hero) then
                if gameObject:consume(self.hero) then
                    shouldDestroy = true
                end
            end

            if gameObject.target == "enemy" and gameObject:doesCollide(self.boss) then
                if gameObject:consume(self.boss) then
                    shouldDestroy = true
                end
            end
        end

        if shouldDestroy then
            table.insert(objectsToRemove, i)
        end
    end

    for i = #objectsToRemove, 1, -1 do
        table.remove(self.gameObjects, objectsToRemove[i])
    end

    if self.boss ~= nil then
        if self.boss:doesCollide(self.hero) then
            self.hero:removeHP(self.boss.collisionDamage)
        end

        if self.boss.hp <= 0 then
            self.hero.score = self.hero.score + 1000
            self.boss = nil
        end
    end

    if not self.levelOver and self.boss == nil then
        self.levelOver = true

        Timer.after(3, function()
            -- transition to next level 3 seconds after boss is dead
            GlobalStateStack:pop()
            GlobalStateStack:push(GameOverState(), {
                win = true,
                score = self.hero.score,
            })
        end)
    end

    if self.boss ~= nil then
        self.boss:update(dt)
    end
    self.hero:update(dt)

    if DEBUG_MODE and love.keyboard.isDown('k') then
        -- kill boss
        self.boss = nil
    end
end

function BossLevel:render()
    if self.levelOver then
        love.graphics.setFont(GlobalFonts["title-large"])
        love.graphics.printf("You Won", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    end

    -- render all tiles
    for _, tile in pairs(self.tiles) do
        tile:render()
    end

    for _, gameObject in pairs(self.gameObjects) do
        gameObject:render()
    end

    if self.boss ~= nil then
        local boss = self.boss
        boss:render()

        love.graphics.setColor(1, 0, 0)
        local maxWidth = VIRTUAL_WIDTH - 120
        local width = boss.hp / boss.maxHP * maxWidth
        love.graphics.rectangle("fill", 60, 36, width, 10)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 60 + width, 36, maxWidth - width, 10)
    end
    self.hero:render()
end

-- Gets nearest tile from (x, y) coordinates provided.
function BossLevel:getNearestTile(x, y)
    if x < 0 or y < 0 or x > self.width * TILE_SIZE or y > self.height * TILE_SIZE then
        return nil
    end

    local xIndex = math.floor(x / TILE_SIZE) + 1
    return self.tiles[xIndex]
end
