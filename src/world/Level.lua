Level = Class{}

-- Need to call Level:generate *after* init (because it references self values).
function Level:init(params)
    self.level = params.level
    self.levelOver = false
    -- every level increases enemy modifier by 20%
    self.enemyModifier = 1 + (self.level - 1) * 0.2

    self.hero = Hero{
        x = TILE_SIZE,
        y = (ROOM_HEIGHT - 2) * TILE_SIZE - 10,
        width = 16,
        height = 16,
        animations = ENTITY_DEFS['hero'].animations,
        stats = params.heroStats or {
            -- default hero stats (for first level)
            score = 0,
            maxHP = 5,
            hp = 5,
            moveSpeed = (SPEED_HACK and 3 or 0.3) * TILE_SIZE,
            meleeDamage = 6,
            rangedDamage = 4,
            rangedSpeed = 5 * TILE_SIZE,
            rangedDistance = 5 * TILE_SIZE,
        },
    }
    self.hero.level = self

    -- initial state is idle
    self.hero:changeState('idle')

    self.height = params.height or ROOM_HEIGHT
    self.width = params.width or ROOM_WIDTH

    self.tiles = {}
    self.enemies = {}
    self.gameObjects = {}
end

local function numberOfRowsToSkip()
    return math.random(2, 3)
end

function Level:generateRow(tiles, tileType, previousRow, r, columns)
    local function shouldGenerateGap(c)
        if r == ROOM_HEIGHT then
            -- don't generate gap for first row
            return false
        end

        if c == ROOM_WIDTH then
            -- don't generate gap for last column
            return false
        end

        if tiles[previousRow][c] == nil or tiles[previousRow][c+1] == nil then
            -- don't generate gaps consecutively (vertically)
            return false
        end

        return math.random(1, columns) <= 2
    end

    local rowTiles = {}
    local rowEnemies = {}
    local rowObjects = {}
    local hasGap = r == ROOM_HEIGHT or false

    local skipNext = false
    for c = 1, columns do
        local toGenerateGap = shouldGenerateGap(c)
        if skipNext or toGenerateGap then
            -- generate gap -> skip the column
            hasGap = true

            local x = (c - 1) * TILE_SIZE
            local y = (previousRow - 2) * TILE_SIZE
            local pot = Potion.jump(x, y, true, self.hero)

            table.insert(rowObjects, pot)

            skipNext = false
            if toGenerateGap then
                skipNext = true
            end
            goto continue
        end

        local tileVariation = Tile.generateRandomVariation()

        local tile = Tile{
            r = r,
            c = c,
            id = tileType * 3 + tileVariation,
        }

        table.insert(rowTiles, c, tile)

        -- Safe zone around player spawn point.
        if (r ~= ROOM_HEIGHT or c > 6) and math.random(1, 10) == 1 then
            -- generate enemy (only try on a tile)
            local type = math.random(1, 3)
            local params = {
                x = (c - 1) * TILE_SIZE,
                y = (r - 2) * TILE_SIZE,
                hero = self.hero,
                modifier = self.enemyModifier,
            }
            local enemy

            if type == 1 then
                enemy = EnemyMarshmallow(params)
            elseif type == 2 then
                enemy = EnemyGhost(params)
            elseif type == 3 then
                enemy = EnemyCarrot(params)
            end
            enemy:changeState('idle')

            table.insert(rowEnemies, enemy)
        end

        ::continue::
    end

    if not hasGap then
        -- re-try if no gap is generated
        return self:generateRow(tiles, tileType, previousRow, r, columns)
    end

    return rowTiles, rowEnemies, rowObjects
end

-- Generates the level.
function Level:generate(rows, columns)
    local tiles = {}
    local enemies = {}
    local objects = {}

    local previousRow = nil
    local skipRows = 0
    -- each row has same colour, just different variation
    for r = rows, 3, -1 do
        if skipRows > 0 then
            -- skip row generation
            skipRows = skipRows - 1
            goto continue
        else
            skipRows = numberOfRowsToSkip()
        end

        local tileType = Tile.generateRandomType()
        local rowTiles, rowEnemies, rowObjects = self:generateRow(tiles, tileType, previousRow, r, columns)

        table.insert(tiles, r, rowTiles)

        for _, enemy in pairs(rowEnemies) do
            table.insert(enemies, enemy)
        end

        for _, object in pairs(rowObjects) do
            table.insert(objects, object)
        end

        previousRow = r
        ::continue::
    end

    return tiles, enemies, objects
end

function Level:update(dt)
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

            for _, enemy in pairs(self.enemies) do
                -- If enemy is immune to projectile, don't trigger consume.
                if gameObject.target == "enemy" and not enemy.immuneToProjectiles and gameObject:doesCollide(enemy) then
                    if not enemy.immuneToProjectiles and gameObject:consume(enemy) then
                        shouldDestroy = true
                    end
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

    -- remove dead enemies
    local enemiesToRemove = {}

    if not self.levelOver and #self.enemies == 0 then
        local hero = self.hero

        self.levelOver = true

        Timer.after(3, function()
            hero:clearEffects()
            -- transition to next level 3 seconds after all enemies are dead
            GlobalStateStack:pop()
            GlobalStateStack:push(LevelTransitionState(), {
                level = self.level + 1,
                heroStats = {
                    -- increment score
                    score = hero.score + self.level * 100,
                    -- increment maxHP by 1 (max of 10)
                    maxHP = math.min(hero.maxHP + 1, 10),
                    -- increment hp by 1
                    hp = math.min(hero.hp + 1, hero.maxHP + 1, 10),
                    -- increase stats
                    moveSpeed = hero.moveSpeed + 0.05 * TILE_SIZE,
                    meleeDamage = hero.meleeDamage * 1.2,
                    rangedDamage = hero.rangedDamage * 1.2,
                    rangedSpeed = hero.rangedSpeed * 1.1,
                    rangedDistance = hero.rangedDistance * 1.2,
                },
            })
        end)
    end

    for i, enemy in pairs(self.enemies) do
        enemy:update(dt)

        -- collision damage
        if enemy:doesCollide(self.hero) then
            self.hero:removeHP(enemy.collisionDamage)
        end

        if enemy.hp <= 0 then
            -- maybe generate random potion
            local type = math.random(1, 6)
            local x = enemy.x
            local y = enemy.y

            local potion
            if type <= 2 then
                -- 1/3 chance to spawn speed
                potion = Potion.speed(x, y, false, self.hero)
                table.insert(self.gameObjects, potion)
            elseif type == 3 then
                -- 1/6 chance to spawn HP
                potion = Potion.HP(x, y, false, self.hero)
                table.insert(self.gameObjects, potion)
            end

            local hero = self.hero
            -- increment score when killing enemy (based on level)
            hero.score = hero.score + 10 * self.level

            table.insert(enemiesToRemove, i)
        end
    end

    for i = #enemiesToRemove, 1, -1 do
        table.remove(self.enemies, enemiesToRemove[i])
    end

    self.hero:update(dt)

    if DEBUG_MODE and love.keyboard.isDown('k') then
        -- kill all enemies
        self.enemies = {}
    end
end

function Level:render()
    if self.levelOver then
        love.graphics.setFont(GlobalFonts["title-large"])
        love.graphics.printf("Level Cleared", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    end

    -- render all tiles
    for _, row in pairs(self.tiles) do
        for _, tile in pairs(row) do
            tile:render()
        end
    end

    for _, gameObject in pairs(self.gameObjects) do
        gameObject:render()
    end

    for _, enemy in pairs(self.enemies) do
        enemy:render()
    end

    self.hero:render()
end

-- Gets nearest tile from (x, y) coordinates provided.
function Level:getNearestTile(x, y)
    if x < 0 or y < 0 or x > self.width * TILE_SIZE or y > self.height * TILE_SIZE then
        return nil
    end

    local xIndex = math.floor(x / TILE_SIZE) + 1
    local yIndex = math.floor(y / TILE_SIZE) + 1
    local row = self.tiles[yIndex]
    if row == nil then
        return nil
    end
    return row[xIndex]
end
