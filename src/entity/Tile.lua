Tile = Class{}

local function generateRandomID()
    return math.random(10, 18)
end

function Tile:init(params)
    self.x = (params.c - 1) * TILE_SIZE
    self.y = (params.r - 1) * TILE_SIZE

    self.height = params.height or TILE_SIZE / 2
    self.width = params.width or TILE_SIZE

    self.id = params.id or generateRandomID()
end

function Tile.generateRandomType()
    return math.random(4, 6)
end

function Tile.generateRandomVariation()
    return math.random(1, 3)
end

function Tile:render()
    -- because tile image is 32 * 32 (but tile size in the game is 16 * 16)
    local scale_x = 0.5
    local scale_y = 0.25

    love.graphics.draw(GlobalTextures['tiles'], GlobalFrames['tiles'][self.id], self.x, self.y, 0, scale_x, scale_y)

    if DEBUG_MODE then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(GlobalFonts["small"])
        love.graphics.printf(self.x .. " " .. self.y, self.x, self.y, TILE_SIZE, "left")

        -- tile bounding box
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
end
