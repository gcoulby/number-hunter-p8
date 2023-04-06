numbers = {}
delay = 20
counter = 0
cursor_pos = {i=1, j=1}
number_length = 5
score = 0
time = 0
time_limit = 30
game_started = false
menu_pos = 0
highscore = 0
in_menu = false
cartdata("gcou_number_hunter")

function startMusic(n)
    if(stat(57) == false) then
        music(n)
    end
end

function stopMusic()
    if(stat(57)== true) then
        music(-1)
    end
end

function create_random_number()
    local o = {}
    o.__index = self
    setmetatable(o, self)
    o.n = {}
    for i=1,number_length do
        o.n[i] = flr(rnd(9))
    end
    o.grid_pos = {i=flr(rnd(14-number_length+1)) + 1, j=flr(rnd(14-number_length+1)) + 1}
    o.set_grid_pos = function()
        o.grid_pos = {i=flr(rnd(14-number_length+1)) + 1, j=flr(rnd(14-number_length+1)) + 1}
    end
    return o
end

function generate_numbers(rnd_1)
    for i=1,14 do
        numbers[i] = {}
        for j=1,14 do
            if i == rnd_1.grid_pos.i and j == rnd_1.grid_pos.j then
                numbers[i][j] = rnd_1.n[1]
            elseif i == rnd_1.grid_pos.i and j == rnd_1.grid_pos.j + 1 and number_length > 1  then
                numbers[i][j] = rnd_1.n[2]
            elseif i == rnd_1.grid_pos.i and j == rnd_1.grid_pos.j + 2 and number_length > 2 then
                numbers[i][j] = rnd_1.n[3]
            elseif i == rnd_1.grid_pos.i and j == rnd_1.grid_pos.j + 3 and number_length > 3 then
                numbers[i][j] = rnd_1.n[4]
            elseif i == rnd_1.grid_pos.i and j == rnd_1.grid_pos.j + 4 and number_length > 4 then
                numbers[i][j] = rnd_1.n[5]
            else
                numbers[i][j] = flr(rnd(9))
            end
        end
    end
end

function print_numbers()
    for i=1,14 do
        for j=1,14 do
            if i == rnd_a.grid_pos.i and j == rnd_a.grid_pos.j then
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            elseif i == rnd_a.grid_pos.i and j == rnd_a.grid_pos.j + 1 and number_length > 1 then
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            elseif i == rnd_a.grid_pos.i and j == rnd_a.grid_pos.j + 2 and number_length > 2 then
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            elseif i == rnd_a.grid_pos.i and j == rnd_a.grid_pos.j + 3 and number_length > 3 then
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            elseif i == rnd_a.grid_pos.i and j == rnd_a.grid_pos.j + 4 and number_length > 4 then
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            else
                print(numbers[i][j], ((j)*8) + 2, ((i+1)*8) + 1, 12)
            end
        end
    end
end

function set_score(s)
    score = s
    if score < 0 then
        score = 0
    elseif score > dget(0) then
        if score < 32767 then
            dset(0, score)
            highscore = score
        else
            dset(0, 32767)
            highscore = 32767
        end
    end
end

function success()
    sfx(16)
    score += (time) + (menu_pos * 10)
    set_score(score)
    reset()
end

function fail()
    sfx(17)
    score -= time_limit + (menu_pos * 5)
    set_score(score)
    reset()
end

function move_cursor()
    
    if btnp(0) then
        sfx(18)
        cursor_pos.i -= 1
        if cursor_pos.i < 1 then
            cursor_pos.i = 1
        end
    elseif btnp(1) then
        sfx(18)
        cursor_pos.i += 1
        if cursor_pos.i > (14 - number_length) + 1 then
            cursor_pos.i = (14 - number_length) + 1
        end
    elseif btnp(2) then
        sfx(18)
        cursor_pos.j -= 1
        if cursor_pos.j < 1 then
            cursor_pos.j = 1
        end
    elseif btnp(3) then
        sfx(18)
        cursor_pos.j += 1
        if cursor_pos.j > 14  then
            cursor_pos.j = 14
        end
    elseif btnp(4) then
        if cursor_pos.i == rnd_a.grid_pos.j and cursor_pos.j == rnd_a.grid_pos.i then
            success()
        else
            fail()
        end
    end
end

function draw_cursor()
    rect((cursor_pos.i*8)-1, ((cursor_pos.j+1)*8)-1, (cursor_pos.i*8) -1 + (number_length * 8), ((cursor_pos.j+1)*8)-1+ 8, 12)
end

function reset()
    time = time_limit + (menu_pos * 5)
    rnd_a = create_random_number()
    generate_numbers(rnd_a)
end

function _init()
    cls()
end


function _update()
    if not game_started then
        coresume(splashScreen)
        if costatus(splashScreen) == "dead" then
            in_menu = true
            if(btnp(0) or btnp(2)) then
                menu_pos = menu_pos - 1
                if menu_pos < 0 then
                    menu_pos = 4
                end
            end
            if(btnp(1) or btnp(3)) then
                menu_pos = menu_pos + 1
                if menu_pos > 4 then
                    menu_pos = 0
                end
            end
            if btnp(4) then
                if menu_pos == 0 then
                    number_length = 5
                elseif menu_pos == 1 then
                    number_length = 4
                elseif menu_pos == 2 then
                    number_length = 3
                elseif menu_pos == 3 then
                    number_length = 2
                elseif menu_pos == 4 then
                    number_length = 1
                end
                reset()
                
                game_started = true
            end
        end
    else
        if counter % delay == 0 then
            counter = 0
            
            -- rnd_a.set_grid_pos()
            generate_numbers(rnd_a)
            time -= 1
            if time == 0 then
                time = time_limit
                fail()
            end
        end
        counter += 1
        move_cursor()
    end
end

function draw_menu()
    cls()
    
    rectfill(8, menu_pos*8+15, 98, menu_pos*8+21, 1)
    print("welcome to number hunt!", 8, 0, 12)
    print("-----------------------", 8, 8, 12)
    print("very easy (find 5)", 8, 16, 12)
    print("easy (find 4)", 8, 24, 12)
    print("medium (find 3)", 8, 32, 12)
    print("hard (find 2)", 8, 40, 12)
    print("very hard (find 1)", 8, 48, 12)

    
    print("select level with ⬆️ and ⬇️", 8, 64, 12)
    print("then press 🅾️ to start", 8, 72, 12)
end

function _draw()
    if not  game_started then
        if in_menu then
            draw_menu()
        end
    else
        cls()
        startMusic(0)
        s = ""
        for i=1,number_length do
            s = s..rnd_a.n[i]
        end
        print("target: "..s, 8, 0, 12)
        print("scr: "..score, 8, 8, 12)
        print("time: "..time, 88, 0, 12)
        local hs = dget(0)
        if hs < 32767 then
            print("hi-scr: "..hs, 68, 8, 12)
            
        else
            print("hi-scr:★★★", 68, 8, 12)
        end
        
        map(0,0)
        draw_cursor()
        print_numbers()
    end
    
end
