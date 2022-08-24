LevelTransitionState = Class{ __includes = BaseState }

local transitionDuration = 3

function LevelTransitionState:enter(params)
    self.timer = transitionDuration
    self.params = params
end

function LevelTransitionState:update(dt)
    self.timer = self.timer - dt

    if self.timer < 0 then
        local params = self.params
        -- pop LevelTransitionState, push new PlayState

        GlobalStateStack:pop()
        GlobalStateStack:push(PlayState(), {
            level = params.level,
            heroStats = params.heroStats,
        })
    end
end

function LevelTransitionState:render()
    -- #333333 dark gray
    love.graphics.clear(51 / 255, 51 / 255, 51 / 255, 1)

    -- white
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(GlobalFonts["title-large"])
    if self.params.level ~= BOSS_LEVEL then
        love.graphics.printf("Level " .. self.params.level, 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf("Boss Level", 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(GlobalFonts['title-medium'])
    love.graphics.printf("in " .. math.ceil(self.timer) .. "...", 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
end
