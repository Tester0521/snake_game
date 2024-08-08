local termios = require("input_module")

local odd = function (size) local x = math.random(size) if x % 2 == 0 then return x end return x + 1 end
local sleep = function (a) local sec = tonumber(os.clock() + a) while (os.clock() < sec) do end end

local width, height = 40, 20  
local snake = { {x = 10, y = 10} }  
local direction = "right"  
local food = {x = odd(width), y = odd(height)}  
local game_over = false

termios.enable_raw_mode()

local render = function ()
    os.execute("clear")  
    for y = 1, height do
        for x = 1, width do
            local is_snake_part = false
            for _, part in ipairs(snake) do
                if part.x == x and part.y == y then
                    is_snake_part = true
                    break
                end
            end
            if is_snake_part then
                io.write("o")  
            elseif food.x == x and food.y == y then
                io.write("@")  
            else
                io.write(".") 
            end
        end
        io.write("\n")
    end
end

local move_snake = function ()
    local head = {x = snake[1].x, y = snake[1].y}
    
    if direction == "right" then
        head.x = head.x + 2
    elseif direction == "left" then
        head.x = head.x - 2
    elseif direction == "up" then
        head.y = head.y - 1
    elseif direction == "down" then
        head.y = head.y + 1
    end

    if head.x < 1 or head.x > width or head.y < 1 or head.y > height then
        game_over = true
        return
    end

    for _, part in ipairs(snake) do
        if part.x == head.x and part.y == head.y then
            game_over = true
            return
        end
    end

    table.insert(snake, 1, head)

    if head.x == food.x and head.y == food.y then
        food.x = odd(width)
        food.y = odd(height)
    else
        table.remove(snake)
    end
end


local get_input = function ()
    local input = termios.read_input() -- io.read(1)


    if input == "w" and direction ~= "down" then
        direction = "up"
    elseif input == "s" and direction ~= "up" then
        direction = "down"
    elseif input == "a" and direction ~= "right" then
        direction = "left"
    elseif input == "d" and direction ~= "left" then
        direction = "right"
    elseif input == "q" then
        game_over = true
    end
end

local
t1 = os.clock()
while not game_over do
    get_input()
    if (os.clock() - t1) < 0.3 then else render() move_snake() t1 = os.clock() end
end

print("Game Over!")

termios.disable_raw_mode()
