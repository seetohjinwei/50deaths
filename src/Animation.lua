--[[
    This code is pretty much the same as the Animation provided in cs50g pokemon's source code.

    Added support for textures being at table, because the graphics I sourced were not in a spritesheet.
]]

Animation = Class{}

-- if params.texture is a table, params.frames is ignored
function Animation:init(params)
    self.isTable = type(params.texture) == "table"

    self.numberOfFrames = 0
    if self.isTable then
        self.numberOfFrames = #params.texture
    else
        self.numberOfFrames = #params.frames
    end
    self.frames = params.frames
    self.interval = params.interval
    self.texture = params.texture
    self.looping = params.looping or true

    self.timer = 0
    self.currentFrame = 1

    self.iterations = 0
end

function Animation:reset()
    self.timer = 0
    self.currentFrame = 1
    self.iterations = 0
end

function Animation:update(dt)
    -- if not looping, stop after one iteration
    if not self.looping and self.iterations > 0 then
        return
    end

    -- if <= 1 frame, no need to update
    if self.numberOfFrames <= 1 then
        return
    end

    self.timer = self.timer + dt

    if self.timer > self.interval then
        self.timer = self.timer % self.interval

        -- increment currentFrame
        self.currentFrame = math.max(1, (self.currentFrame + 1) % (self.numberOfFrames + 1))

        -- increment iterations count
        if self.currentFrame == 1 then
            self.iterations = self.iterations + 1
        end
    end
end

-- Renders the current frame to the screen.
function Animation:renderCurrentFrame(quad, x, y, r, sx, sy, ox, oy, kx, ky)
    if self.isTable then
        local texture = self.texture[self.currentFrame]
        love.graphics.draw(texture, quad, x, y, r, sx, sy, ox, oy, kx, ky)
    else
        local frame = self.frames[self.currentFrame]
        love.graphics.draw(GlobalTextures[self.texture], GlobalFrames[self.texture][frame], x, y, r, sx, sy, ox, oy, kx, ky)
    end
end
