ContinueState = Class{ __includes = BaseState }

local continueDuration = 3

function ContinueState:enter()
    self.timer = continueDuration
end

function ContinueState:update(dt)
    self.timer = self.timer - dt
    if self.timer < 0 then
        -- pop ContinueState & PauseState
        GlobalStateStack:pop()
        GlobalStateStack:pop()
    end
end

function ContinueState:render()
    -- #333333 dark gray
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["title-large"])
    love.graphics.printf("Continuing", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GlobalFonts['title-medium'])
    love.graphics.printf("in " .. math.ceil(self.timer) .. "...", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
end
