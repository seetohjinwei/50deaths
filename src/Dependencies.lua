--[[
    List of Dependencies.

    3rd party dependencies are listed on top followed by my source code.
]]

-- 3rd party dependencies below.
-- https://github.com/Ulydev/push
push = require 'lib/push'
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'lib/class'
-- https://github.com/airstruck/knife/blob/master/knife/timer.lua
Timer = require 'lib/timer'

-- My source code dependencies below.
require 'src/constants'
require 'src/Animation'
require 'src/Util'

-- world
require 'src/world/Level'
require 'src/world/BossLevel'

-- states
require 'src/states/StateStack'
require 'src/states/StateMachine'
require 'src/states/BaseState'

require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/game/PauseState'
require 'src/states/game/ContinueState'
require 'src/states/game/GameOverState'
require 'src/states/game/LevelTransitionState'

require 'src/states/entity/EntityBaseState'
require 'src/states/entity/EntityIdleState'
require 'src/states/entity/EntityRunState'

require 'src/states/entity/HeroBaseState'
require 'src/states/entity/HeroAttackState'
require 'src/states/entity/HeroIdleState'
require 'src/states/entity/HeroJumpState'
require 'src/states/entity/HeroRunState'

require 'src/states/entity/BossBaseState'
require 'src/states/entity/BossIdleState'
require 'src/states/entity/BossAttackState'

require 'src/states/entity/MarshmallowIdleState'

require 'src/states/entity/GhostBaseState'
require 'src/states/entity/GhostIdleState'
require 'src/states/entity/GhostAttackState'

require 'src/states/entity/CarrotBaseState'
require 'src/states/entity/CarrotIdleState'
require 'src/states/entity/CarrotAttackState'

-- entity
require 'src/entity/Entity'
require 'src/entity/Hero'
require 'src/entity/Tile'

require 'src/entity/Enemy'
require 'src/entity/Boss'
require 'src/entity/EnemyMarshmallow'
require 'src/entity/EnemyGhost'
require 'src/entity/EnemyCarrot'

-- game objects
require 'src/gameobject/GameObject'
require 'src/gameobject/Potion'
require 'src/gameobject/Fireball'
require 'src/gameobject/CarrotProjectile'

local defaultFont = "fonts/sf-atarian-system.regular.ttf"
local titleFont = "fonts/rubber-biscuit.bold.ttf"

GlobalTextures = {
    ['tiles'] = love.graphics.newImage('graphics/ground.png'),
    ['potion-hp'] = love.graphics.newImage('graphics/potions/pt1.png'),
    ['potion-jump'] = love.graphics.newImage('graphics/potions/pt3.png'),
    ['potion-speed'] = love.graphics.newImage('graphics/potions/pt4.png'),
    ['fireball'] = love.graphics.newImage('graphics/fireball.png'),
    ['enemy-carrot'] = love.graphics.newImage('graphics/enemies/carrot.png'),
    ['enemy-ghost'] = love.graphics.newImage('graphics/enemies/ghost.png'),
    ['enemy-marshmallow'] = love.graphics.newImage('graphics/enemies/marshmallow.png'),
    ['heart'] = love.graphics.newImage('graphics/heart.png'),
    ['heart2'] = love.graphics.newImage('graphics/heart2.png'),
}

-- add hero-attack
local heroAttackFrames = {}
for i = 0, 2 do
    table.insert(heroAttackFrames, love.graphics.newImage('graphics/hero/attack_' .. i ..'.png'))
end

-- add hero-idle
local heroIdleFrames = {}
for i = 0, 3 do
    table.insert(heroIdleFrames, love.graphics.newImage('graphics/hero/idle_' .. i ..'.png'))
end

-- add hero-jump
local heroJumpFrames = {}
for i = 0, 3 do
    table.insert(heroJumpFrames, love.graphics.newImage('graphics/hero/jump_' .. i ..'.png'))
end

-- add hero-run
local heroRunFrames = {}
for i = 0, 5 do
    table.insert(heroRunFrames, love.graphics.newImage('graphics/hero/run_' .. i ..'.png'))
end

HeroQuad = love.graphics.newQuad(8, 9, 16, 16, 40, 29)

-- Entity Definitions
ENTITY_DEFS = {
    ['hero'] = {
        animations = {
            ['attack'] = {
                interval = 0.15,
                texture = heroAttackFrames,
            },
            ['idle'] = {
                interval = 0.15,
                texture = heroIdleFrames,
            },
            ['jump'] = {
                interval = 0.15,
                texture = heroJumpFrames,
            },
            ['run'] = {
                interval = 0.15,
                texture = heroRunFrames,
            },
        }
    },
    ['enemy-marshmallow'] = {
        animations = {
            ['idle'] = {
                interval = 0.3,
                texture = 'enemy-marshmallow',
                frames = {1, 2},
            }
        }
    },
    ['enemy-ghost'] = {
        animations = {
            ['idle'] = {
                interval = 0.1,
                texture = 'enemy-ghost',
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},
            }
        }
    },
    ['enemy-carrot'] = {
        animations = {
            ['idle'] = {
                interval = 0.1,
                texture = 'enemy-carrot',
                frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20},
            }
        }
    },
}

GlobalFrames = {
    ['tiles'] = GenerateQuads(GlobalTextures['tiles'], 32, 32),
    ['enemy-carrot'] = GenerateQuads(GlobalTextures['enemy-carrot'], 606, 506),
    ['enemy-ghost'] = GenerateQuads(GlobalTextures['enemy-ghost'], 439, 554),
    ['enemy-marshmallow'] = GenerateQuads(GlobalTextures['enemy-marshmallow'], 350.5, 204),
}

GlobalFonts = {
    ['small'] = love.graphics.newFont(defaultFont, 10),
    ['medium'] = love.graphics.newFont(defaultFont, 16),
    ['large'] = love.graphics.newFont(defaultFont, 32),
    ['title-medium'] = love.graphics.newFont(titleFont, 16),
    ['title-large'] = love.graphics.newFont(titleFont, 32),
}

for _, font in pairs(GlobalFonts) do
    -- makes fonts look sharper
    font:setFilter("nearest", "nearest")
end

GlobalSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['jump-land'] = love.audio.newSource('sounds/jump-land.wav', 'static'),
    ['fireball'] = love.audio.newSource('sounds/fireball.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.mp3', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['punch'] = love.audio.newSource('sounds/punch.wav', 'static'),
}

-- jump is a bit too loud
GlobalSounds['jump']:setVolume(0.5)
