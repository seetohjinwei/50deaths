PauseState = Class{ __includes = BaseState }

function PauseState:enter()
    -- in first 0.5 seconds, do not unpause
    self.timer = 0.5
end

function PauseState:update(dt)
    if self.timer > 0 then
        self.timer = self.timer - dt
        return
    end

    if love.keyboard.isDown("p") then
        love.audio.play(GlobalSounds['select'])
        GlobalStateStack:push(ContinueState())
    end

    if love.keyboard.isDown("q") then
        love.audio.play(GlobalSounds['select'])
        love.event.quit(0)
    end
end

function PauseState:render()
    -- #333333 dark gray
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["title-large"])
    love.graphics.printf("Paused", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GlobalFonts['title-medium'])
    love.graphics.printf("Press P to Unpause", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    love.graphics.printf("Press Q to Quit", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
end
