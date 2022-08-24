GameOverState = Class{ __includes = BaseState }

function GameOverState:enter(params)
    self.win = params.win
    self.score = params.score
end

function GameOverState:update(_)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("return") then
        love.audio.play(GlobalSounds['select'])
        GlobalStateStack:pop()
    end
end

function GameOverState:render()
    -- #333333 dark gray
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["title-large"])
    local text
    if self.win then
        text = "You Won"
    else
        text = "You Died"
    end
    love.graphics.printf(text, 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GlobalFonts['title-medium'])
    love.graphics.printf("Score of " .. self.score, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(GlobalFonts['title-medium'])
    love.graphics.printf("Press Enter to restart...", 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
end
