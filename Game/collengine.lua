CollEngine = {}

function CollEngine.CheckCollisons(key, dt)
    local canCollide = true

    --Move up
    if key == "w" then
        for i, obj in ipairs(collisionsObjects) do
            if obj.canCollide then
                if player.x+player.sizeX > obj.x and player.x < obj.x+obj.size then
                    if player.y > obj.y+obj.size+player.speed*dt or player.y < obj.y-player.speed*dt then canCollide = true else canCollide = false break end
                end

            end
        end
    end

    --Move down
    if key == "s" then
        for i, obj in ipairs(collisionsObjects) do
            if obj.canCollide then
                if player.x+player.sizeX > obj.x and player.x < obj.x+obj.size then
                    if player.y+player.sizeY+player.speed*dt < obj.y or player.y > obj.y+obj.size-player.speed*dt then canCollide = true else canCollide = false break end
                end
            end
        end
    end

    --Move left
    if key == "a" then
        for i, obj in ipairs(collisionsObjects) do
            if obj.canCollide then
                if player.y+player.sizeY > obj.y and player.y < obj.y+obj.size then
                    if player.x > obj.x+obj.size+player.speed*dt or player.x < obj.x then canCollide = true else canCollide = false break end
                end
            end
        end
    end

    --Move right
    if key == "d" then
        for i, obj in ipairs(collisionsObjects) do
            if obj.canCollide then
                if player.y+player.sizeY > obj.y and player.y < obj.y+obj.size then
                    if player.x+player.sizeX < obj.x-player.speed*dt or player.x > obj.x+obj.size then canCollide = true else canCollide = false break end
                end
            end
        end
    end
    return canCollide
end

function CollEngine.SpawnObject(x, y, mode)
    local obj = {}
    obj.size = 300*0.25
    obj.x = x - 300*0.25/2
    obj.y = y - 300*0.25/2
    obj.canCollide = mode
    table.insert(collisionsObjects, obj)
end

return CollEngine