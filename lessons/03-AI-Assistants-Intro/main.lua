-- The World's Hardest Game - Recreation
-- Control the red square, avoid blue enemies, collect yellow coins

local player = {
    x = 50,
    y = 50,
    size = 20,
    speed = 200,
    startX = 50,
    startY = 50,
    color = {1, 0, 0} -- Red
}

local enemies = {}
local coins = {}
local checkpoints = {}

local gameState = "menu" -- menu, playing, levelComplete, gameover
local currentLevel = 1
local coinsCollected = 0
local totalCoins = 0
local deaths = 0
local levelStartTime = 0

local levels = {}

-- Level 1
levels[1] = {
    playerStart = {x = 50, y = 50},
    checkpoint = {x = 50, y = 50},
    enemies = {
        {x = 200, y = 100, vx = 0, vy = 150, size = 30, color = {0, 0, 1}},
        {x = 400, y = 200, vx = 150, vy = 0, size = 30, color = {0, 0, 1}},
        {x = 600, y = 300, vx = 0, vy = -150, size = 30, color = {0, 0, 1}},
        {x = 300, y = 400, vx = -150, vy = 0, size = 30, color = {0, 0, 1}},
    },
    coins = {
        {x = 200, y = 200, collected = false},
        {x = 400, y = 300, collected = false},
        {x = 600, y = 500, collected = false},
    },
    goal = {x = 750, y = 550}
}

-- Level 2
levels[2] = {
    playerStart = {x = 50, y = 300},
    checkpoint = {x = 50, y = 300},
    enemies = {
        {x = 150, y = 100, vx = 0, vy = 200, size = 30, color = {0, 0, 1}},
        {x = 150, y = 500, vx = 0, vy = -200, size = 30, color = {0, 0, 1}},
        {x = 300, y = 200, vx = 200, vy = 0, size = 30, color = {0, 0, 1}},
        {x = 300, y = 400, vx = 200, vy = 0, size = 30, color = {0, 0, 1}},
        {x = 500, y = 100, vx = 0, vy = 200, size = 30, color = {0, 0, 1}},
        {x = 500, y = 500, vx = 0, vy = -200, size = 30, color = {0, 0, 1}},
    },
    coins = {
        {x = 200, y = 300, collected = false},
        {x = 400, y = 300, collected = false},
        {x = 600, y = 300, collected = false},
    },
    goal = {x = 750, y = 300}
}

-- Level 3
levels[3] = {
    playerStart = {x = 400, y = 50},
    checkpoint = {x = 400, y = 50},
    enemies = {
        {x = 200, y = 150, vx = 150, vy = 150, size = 30, color = {0, 0, 1}},
        {x = 600, y = 150, vx = -150, vy = 150, size = 30, color = {0, 0, 1}},
        {x = 200, y = 450, vx = 150, vy = -150, size = 30, color = {0, 0, 1}},
        {x = 600, y = 450, vx = -150, vy = -150, size = 30, color = {0, 0, 1}},
        {x = 400, y = 300, vx = 0, vy = 0, size = 40, color = {0, 0, 1}},
    },
    coins = {
        {x = 100, y = 100, collected = false},
        {x = 700, y = 100, collected = false},
        {x = 100, y = 500, collected = false},
        {x = 700, y = 500, collected = false},
    },
    goal = {x = 400, y = 550}
}

-- Level 4 - Moving walls
levels[4] = {
    playerStart = {x = 50, y = 300},
    checkpoint = {x = 50, y = 300},
    enemies = {
        {x = 200, y = 0, vx = 0, vy = 180, size = 30, color = {0, 0, 1}},
        {x = 200, y = 600, vx = 0, vy = -180, size = 30, color = {0, 0, 1}},
        {x = 400, y = 0, vx = 0, vy = 180, size = 30, color = {0, 0, 1}},
        {x = 400, y = 600, vx = 0, vy = -180, size = 30, color = {0, 0, 1}},
        {x = 600, y = 0, vx = 0, vy = 180, size = 30, color = {0, 0, 1}},
        {x = 600, y = 600, vx = 0, vy = -180, size = 30, color = {0, 0, 1}},
    },
    coins = {
        {x = 150, y = 150, collected = false},
        {x = 350, y = 300, collected = false},
        {x = 550, y = 450, collected = false},
    },
    goal = {x = 750, y = 300}
}

-- Level 5 - Chaos
levels[5] = {
    playerStart = {x = 400, y = 300},
    checkpoint = {x = 400, y = 300},
    enemies = {
        {x = 100, y = 100, vx = 200, vy = 0, size = 25, color = {0, 0, 1}},
        {x = 700, y = 100, vx = -200, vy = 0, size = 25, color = {0, 0, 1}},
        {x = 100, y = 500, vx = 200, vy = 0, size = 25, color = {0, 0, 1}},
        {x = 700, y = 500, vx = -200, vy = 0, size = 25, color = {0, 0, 1}},
        {x = 400, y = 50, vx = 0, vy = 200, size = 25, color = {0, 0, 1}},
        {x = 400, y = 550, vx = 0, vy = -200, size = 25, color = {0, 0, 1}},
        {x = 200, y = 300, vx = 0, vy = 150, size = 25, color = {0, 0, 1}},
        {x = 600, y = 300, vx = 0, vy = -150, size = 25, color = {0, 0, 1}},
    },
    coins = {
        {x = 150, y = 150, collected = false},
        {x = 650, y = 150, collected = false},
        {x = 150, y = 450, collected = false},
        {x = 650, y = 450, collected = false},
        {x = 400, y = 300, collected = false},
    },
    goal = {x = 400, y = 550}
}

local function loadLevel(levelNum)
    if not levels[levelNum] then
        gameState = "victory"
        return
    end
    
    local level = levels[levelNum]
    currentLevel = levelNum
    
    -- Reset player
    player.x = level.playerStart.x
    player.y = level.playerStart.y
    player.startX = level.playerStart.x
    player.startY = level.playerStart.y
    
    -- Load enemies
    enemies = {}
    for i, e in ipairs(level.enemies) do
        table.insert(enemies, {
            x = e.x,
            y = e.y,
            startX = e.x,
            startY = e.y,
            vx = e.vx,
            vy = e.vy,
            size = e.size,
            color = e.color
        })
    end
    
    -- Load coins
    coins = {}
    for i, c in ipairs(level.coins) do
        table.insert(coins, {
            x = c.x,
            y = c.y,
            collected = false,
            size = 15
        })
    end
    
    coinsCollected = 0
    totalCoins = #coins
    levelStartTime = love.timer.getTime()
end

local function resetToCheckpoint()
    player.x = levels[currentLevel].checkpoint.x
    player.y = levels[currentLevel].checkpoint.y
    deaths = deaths + 1
    
    -- Reset enemies to starting positions
    local level = levels[currentLevel]
    for i, e in ipairs(enemies) do
        e.x = level.enemies[i].x
        e.y = level.enemies[i].y
    end
end

local function checkCollision(x1, y1, size1, x2, y2, size2)
    return x1 < x2 + size2 and
           x1 + size1 > x2 and
           y1 < y2 + size2 and
           y1 + size1 > y2
end

function love.load()
    love.window.setTitle("The World's Hardest Game")
end

function love.update(dt)
    if gameState ~= "playing" then
        return
    end
    
    -- Player movement
    local moveSpeed = player.speed * dt
    if love.keyboard.isDown("w", "up") then
        player.y = math.max(0, player.y - moveSpeed)
    end
    if love.keyboard.isDown("s", "down") then
        player.y = math.min(love.graphics.getHeight() - player.size, player.y + moveSpeed)
    end
    if love.keyboard.isDown("a", "left") then
        player.x = math.max(0, player.x - moveSpeed)
    end
    if love.keyboard.isDown("d", "right") then
        player.x = math.min(love.graphics.getWidth() - player.size, player.x + moveSpeed)
    end
    
    -- Update enemies
    local level = levels[currentLevel]
    for i, enemy in ipairs(enemies) do
        enemy.x = enemy.x + enemy.vx * dt
        enemy.y = enemy.y + enemy.vy * dt
        
        -- Bounce off walls
        if enemy.x <= 0 or enemy.x + enemy.size >= love.graphics.getWidth() then
            enemy.vx = -enemy.vx
            enemy.x = math.max(0, math.min(enemy.x, love.graphics.getWidth() - enemy.size))
        end
        if enemy.y <= 0 or enemy.y + enemy.size >= love.graphics.getHeight() then
            enemy.vy = -enemy.vy
            enemy.y = math.max(0, math.min(enemy.y, love.graphics.getHeight() - enemy.size))
        end
        
        -- Check collision with player
        if checkCollision(player.x, player.y, player.size, enemy.x, enemy.y, enemy.size) then
            resetToCheckpoint()
        end
    end
    
    -- Check coin collection
    for i, coin in ipairs(coins) do
        if not coin.collected then
            if checkCollision(player.x, player.y, player.size, coin.x - coin.size/2, coin.y - coin.size/2, coin.size) then
                coin.collected = true
                coinsCollected = coinsCollected + 1
                -- Update checkpoint when coin is collected
                levels[currentLevel].checkpoint.x = player.x
                levels[currentLevel].checkpoint.y = player.y
            end
        end
    end
    
    -- Check goal
    if coinsCollected == totalCoins then
        local goal = level.goal
        if checkCollision(player.x, player.y, player.size, goal.x - 20, goal.y - 20, 40) then
            gameState = "levelComplete"
        end
    end
end

function love.draw()
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    
    if gameState == "menu" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.printf("THE WORLD'S", 0, 150, love.graphics.getWidth(), "center")
        love.graphics.printf("HARDEST GAME", 0, 220, love.graphics.getWidth(), "center")
        
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("Use WASD or Arrow Keys to move", 0, 320, love.graphics.getWidth(), "center")
        love.graphics.printf("Avoid blue enemies", 0, 360, love.graphics.getWidth(), "center")
        love.graphics.printf("Collect all yellow coins", 0, 400, love.graphics.getWidth(), "center")
        love.graphics.printf("Reach the green goal", 0, 440, love.graphics.getWidth(), "center")
        love.graphics.printf("Press SPACE to start", 0, 500, love.graphics.getWidth(), "center")
        return
    end
    
    if gameState == "victory" then
        love.graphics.setColor(1, 1, 0)
        love.graphics.setFont(love.graphics.newFont(48))
        love.graphics.printf("CONGRATULATIONS!", 0, 200, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("You completed all levels!", 0, 300, love.graphics.getWidth(), "center")
        love.graphics.printf("Total Deaths: " .. deaths, 0, 350, love.graphics.getWidth(), "center")
        love.graphics.printf("Press SPACE to play again", 0, 450, love.graphics.getWidth(), "center")
        return
    end
    
    if gameState == "levelComplete" then
        love.graphics.setColor(0, 1, 0)
        love.graphics.setFont(love.graphics.newFont(36))
        love.graphics.printf("LEVEL " .. currentLevel .. " COMPLETE!", 0, 250, love.graphics.getWidth(), "center")
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press SPACE for next level", 0, 320, love.graphics.getWidth(), "center")
        return
    end
    
    -- Draw playing state
    local level = levels[currentLevel]
    
    -- Draw goal (green square)
    if coinsCollected == totalCoins then
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", level.goal.x - 20, level.goal.y - 20, 40, 40)
        love.graphics.setColor(0, 0.7, 0)
        love.graphics.rectangle("line", level.goal.x - 20, level.goal.y - 20, 40, 40)
    end
    
    -- Draw checkpoint
    love.graphics.setColor(0.5, 0.5, 0.5, 0.3)
    love.graphics.circle("fill", level.checkpoint.x + player.size/2, level.checkpoint.y + player.size/2, 25)
    
    -- Draw coins
    for i, coin in ipairs(coins) do
        if not coin.collected then
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle("fill", coin.x, coin.y, coin.size)
            love.graphics.setColor(0.8, 0.8, 0)
            love.graphics.circle("line", coin.x, coin.y, coin.size)
        end
    end
    
    -- Draw enemies
    for i, enemy in ipairs(enemies) do
        love.graphics.setColor(enemy.color[1], enemy.color[2], enemy.color[3])
        love.graphics.circle("fill", enemy.x + enemy.size/2, enemy.y + enemy.size/2, enemy.size/2)
        love.graphics.setColor(enemy.color[1] * 0.7, enemy.color[2] * 0.7, enemy.color[3] * 0.7)
        love.graphics.circle("line", enemy.x + enemy.size/2, enemy.y + enemy.size/2, enemy.size/2)
    end
    
    -- Draw player
    love.graphics.setColor(player.color[1], player.color[2], player.color[3])
    love.graphics.rectangle("fill", player.x, player.y, player.size, player.size)
    love.graphics.setColor(player.color[1] * 0.7, player.color[2] * 0.7, player.color[3] * 0.7)
    love.graphics.rectangle("line", player.x, player.y, player.size, player.size)
    
    -- Draw UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(20))
    love.graphics.print("Level: " .. currentLevel, 10, 10)
    love.graphics.print("Coins: " .. coinsCollected .. "/" .. totalCoins, 10, 35)
    love.graphics.print("Deaths: " .. deaths, 10, 60)
    
    if coinsCollected < totalCoins then
        love.graphics.setColor(1, 0, 0)
        love.graphics.print("Collect all coins first!", 10, 85)
    end
end

function love.keypressed(key)
    if key == "space" then
        if gameState == "menu" then
            gameState = "playing"
            deaths = 0
            loadLevel(1)
        elseif gameState == "levelComplete" then
            loadLevel(currentLevel + 1)
            gameState = "playing"
        elseif gameState == "victory" then
            gameState = "menu"
            deaths = 0
        end
    end
    
    if key == "r" and gameState == "playing" then
        resetToCheckpoint()
    end
    
    if key == "escape" then
        if gameState == "playing" or gameState == "levelComplete" then
            gameState = "menu"
        else
            love.event.quit()
        end
    end
end
