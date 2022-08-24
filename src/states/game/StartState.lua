StartState = Class{ __includes = BaseState }

function StartState:enter()
    self.highlighted = 1
    self.selections = {
        {
            text = "Play",
            callback = function()
                GlobalStateStack:push(LevelTransitionState(), {
                    level = 1,
                })
            end,
        },
        {
            text = "Quit",
            callback = function()
                love.event.quit(0)
            end,
        },
    }
end

function StartState:update(_)
    if love.keyboard.wasPressed('up') then
        love.audio.play(GlobalSounds['select'])
        self.highlighted = self.highlighted + 1
        if self.highlighted > #self.selections then
            self.highlighted = 1
        end
    elseif love.keyboard.wasPressed('down') then
        love.audio.play(GlobalSounds['select'])
        self.highlighted = self.highlighted - 1
        if self.highlighted < 1 then
            self.highlighted = #self.selections
        end
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        love.audio.play(GlobalSounds['select'])
        -- triggers callback function
        self.selections[self.highlighted].callback()
    end
end

function StartState:render()
    -- #333333 dark gray
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["title-large"])
    love.graphics.printf("50 deaths", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')

    for i, selection in ipairs(self.selections) do
        -- white
        love.graphics.setColor(1, 1, 1, 1)
        if self.highlighted == i then
            -- #3333ff blue
            love.graphics.setColor(51 / 255, 51 / 255, 255 / 255, 1)
        end
        local heightModifier = (i - 1) * 24
        love.graphics.setFont(GlobalFonts['title-medium'])
        love.graphics.printf(selection.text, 0, VIRTUAL_HEIGHT / 2 + 16 + heightModifier, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end
