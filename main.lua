--[[
    50 Deaths entrypoint.

    Author: See Toh Jin Wei (seetohjinwei on GitHub)
]]

-- these are for debugging purposes (to save time)
DEBUG_MODE = false
SPEED_HACK = false

require 'src/Dependencies'

function love.load()
    love.window.setTitle('50 Deaths')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    love.keyboard.keysPressed = {}

    GlobalStateStack = StateStack()
    -- push start state onto the stack
    GlobalStateStack:push(StartState())
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if DEBUG_MODE and key == 'escape' then
        love.event.quit(0)
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    GlobalStateStack:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    GlobalStateStack:render()
    push:finish()
end
