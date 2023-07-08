function love.load()
    require"/collengine"
    --love.window.maximize()
    love.window.setMode(1200, 900)
    love.window.setTitle("Really cool game")

    love.graphics.setDefaultFilter ( "nearest" , "nearest", 1)

    imgs = {}
    imgs.background = love.graphics.newImage('imgs/map.png')
    imgs.player = love.graphics.newImage('imgs/player.png')
    imgs.handgun = love.graphics.newImage('imgs/handgun.png')
    imgs.bullet = love.graphics.newImage('imgs/bullet.png')
    imgs.ammobox = love.graphics.newImage('imgs/ammobox.png')
    imgs.keyE = love.graphics.newImage('imgs/e-key.png')
    imgs.box = love.graphics.newImage('imgs/wood.png')

    player = {}
    player.x = love.graphics.getWidth()/2
    player.y = love.graphics.getHeight()/2
    player.sizeX = 43
    player.sizeY = 43
    player.speed = 220
    player.action = false
    player.magazine = 7
    player.ammo = 10
    player.actionbuild = false

    collisionsObjects = {}
    Bullets = {}
    AmmoBoxes = {}
end

--hold a gun
function love.keypressed(key)
    if key == "1" then 
        player.action = not player.action 
        player.actionbuild = false 
    end
    if key == "b" then 
        player.actionbuild = not player.actionbuild
        player.action = false 
    end
    if key == "q" then SpawnAmmo() end
    if key == "r" then ReloadAmmo() end

    --Grab ammobox
    for i, ammo in ipairs(AmmoBoxes) do
        if CalculateDistance(player.x, player.y, ammo.x, ammo.y) < imgs.ammobox:getWidth() and key == "e" then
            table.remove(AmmoBoxes, i)
            player.ammo = player.ammo + math.random(2, 10)
        end
    end
end

function love.mousepressed(x, y, button)
    if button == 1 and player.action == true and player.magazine > 0 then SpawnBullet() end
    if button == 1 and player.actionbuild == true then CollEngine.SpawnObject(x, y, true) end
end

function love.update(dt)
    love.window.setTitle("FPS: "..love.timer.getFPS())

    --WASD movement
    if love.keyboard.isDown("w") and CollEngine.CheckCollisons("w", dt) then
        player.y = player.y - player.speed*dt
    end
    if love.keyboard.isDown("a") and CollEngine.CheckCollisons("a", dt) then
        player.x = player.x - player.speed*dt
    end
    if love.keyboard.isDown("s") and CollEngine.CheckCollisons("s", dt) then
        player.y = player.y + player.speed*dt
    end
    if love.keyboard.isDown("d") and CollEngine.CheckCollisons("d", dt) then
        player.x = player.x + player.speed*dt
    end

    --sprint
    if love.keyboard.isDown("lshift") then
        player.speed = 480
    else
        player.speed = 220
    end

    for i, bull in ipairs(Bullets) do
        bull.x = bull.x + math.cos(bull.rot) *bull.speed*dt
        bull.y = bull.y + math.sin(bull.rot) *bull.speed*dt
        if bull.x < 0 or bull.y < 0 or bull.x > love.graphics.getWidth() or bull.y > love.graphics.getHeight() then
            table.remove(Bullets, i)
        end
    end
end

function love.draw()
    love.graphics.draw(imgs.background, 0, 0, nil, 2.5, 1.5)

    --Draw bullets
    for i, bull in ipairs(Bullets) do
        love.graphics.draw(imgs.bullet, bull.x, bull.y, bull.rot, 0.1, 0.1, imgs.player:getWidth()/2-100, imgs.player:getHeight()/2-50)
    end

    --Draw ammoboxes
    for i, ammo in ipairs(AmmoBoxes) do
        love.graphics.draw(imgs.ammobox, ammo.x, ammo.y, nil, 0.5, 0.5, imgs.ammobox:getWidth()/2, imgs.ammobox:getHeight()/2)

        if CalculateDistance(player.x, player.y, ammo.x, ammo.y) < imgs.ammobox:getWidth() then
            love.graphics.draw(imgs.keyE, ammo.x-imgs.ammobox:getWidth()/2*0.25, ammo.y-imgs.ammobox:getHeight()/2*0.25, nil, 0.25, 0.25, imgs.ammobox:getWidth()/2, imgs.ammobox:getHeight()/2)
        end
    end

    for i, bb in ipairs(collisionsObjects) do
        love.graphics.draw(imgs.box, bb.x, bb.y, nil, 0.25, 0.25)
    end

    --Draw gun
    if player.action == true then
        love.graphics.draw(imgs.handgun, player.x, player.y, GetMouseAngel(), 0.15, 0.15, imgs.player:getWidth()/2-100, imgs.player:getHeight()/2-50)
    end
    if player.actionbuild == true then
        love.graphics.setColor(255, 255, 255, 0.5)
        love.graphics.draw(imgs.box, love.mouse.getX()-300*0.25/2, love.mouse.getY()-300*0.25/2, nil, 0.25, 0.25)
        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.draw(imgs.box, player.x, player.y, GetMouseAngel(), 0.15, 0.15, imgs.player:getWidth()/2-100, imgs.player:getHeight()/2-50)
    end
    --Draw player
    love.graphics.draw(imgs.player, player.x, player.y, GetMouseAngel(), 1.5, 1.5, imgs.player:getWidth()/2, imgs.player:getHeight()/2)

    love.graphics.print(player.magazine .. "/7 <>".. player.ammo, 0, 0)
end

function GetMouseAngel() --player
    return math.atan2(player.y - love.mouse.getY(), player.x - love.mouse.getX()) + math.pi
end

function SpawnBullet() --gun shooting
    local bullet = {}
    bullet.speed = 1200
    bullet.rot = GetMouseAngel()
    bullet.x = player.x
    bullet.y = player.y
    table.insert(Bullets, bullet)
    player.magazine = player.magazine - 1
end

function CalculateDistance(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function SpawnAmmo()
    local ammobox = {}
    ammobox.x = math.random(0, love.graphics.getWidth())
    ammobox.y = math.random(0, love.graphics.getHeight())
    ammobox.count = 10
    table.insert(AmmoBoxes, ammobox)
end

function ReloadAmmo()
    local need = 7 - player.magazine
    if player.ammo < 7 and player.magazine < 7 then
        player.magazine = player.magazine + player.ammo
        player.ammo = 0
    else
        player.magazine = player.magazine + need
        player.ammo = player.ammo - need
    end
end

