pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

---------- page 0 ----------
-- game engine
tile_types = 3 -- assuming 5 types of candies
grid = {}
-- grid info
sz = {
    x_buff = 8,
    y_buff = 8,
    x_len = 14,
    y_len = 8
}

-- sprite info
sp = {
    { x = 8, y = 0 },
    { x = 24, y = 0 },
    { x = 40, y = 0 },
    dim = 16,
    screen_dim = 8
}
function _init()
    init_grid()
end

function _update()
end

function _draw()
    cls(12)
    draw_grid()
    check_grid()

    --put pset in a loop for slow
    --blinking in the menu
    pset(0, 0, 3)

    draw_ui()
end

-------- end page 0 --------
-->8
---------- page 1 ----------
-- helper functions
function printsomething()
    print("something")
end

function draw_grid()
    for i = 0, sz.x_len * sz.y_len - 1 do
        --[[spr(
            grid[i],
            i % sz.x_len * 8 + sz.x_buff,
            flr(i / sz.x_len) * 8 + sz.y_buff,
            1, 1
        )]]
        --type = grid[i]
        sspr(
            sp[grid[i]].x,
            sp[grid[i]].y,
            sp.dim,
            sp.dim,
            i % sz.x_len * sp.screen_dim + sz.x_buff,
            flr(i / sz.x_len) * sp.screen_dim + sz.y_buff,
            sp.screen_dim, sp.screen_dim
        )
    end

    -- sspr(sprite x, sprite y, sprite width, sprite height, screen x, screen y, scale x, scale y)
    -- sspr(sp[grid[i]].x, sp[gird[i]].y, sp.width, sp.height, i % sz.x_len * 8 + sz.x_buff, flr(i / sz.x_len) * 8 + sz.y_buff, 1, 1)
    -- spr(sprite index, screen x, screen y, # sprite width, # sprite height)
end

function draw_ui()
    rect(8, 73, 119, 120, 4)
    rectfill(9, 74, 10, 75, rnd(3))
    rectfill(117, 74, 118, 75, rnd(3))
end

function init_grid()
    for i = 0, sz.x_len * sz.y_len do
        grid[i] = flr(rnd(tile_types)) + 1
    end
end

--[[
    check for matching tiles and possible solutions
    returns:
     -1: error in function
      0: grid has possible solution with nothing matching
      1: gird has no possible solutions with nothing matching
[table]: table of correct tiles
]]
function check_grid()
    checked_tiles = {}
    possible_solutions = {}
    solution_tiles = {}
    --[[a possible solution has to consist of two matching tiles and what direction they are pointing in,
        since we will only be checking horizontal and vertical
        {tile number, direction}, {32, vertical}, {5, horizontal}

        how do we deal with an L shaped connection?
        have a solutions group that consists of the tiles that are part of the solution and remove those tiles independent of which match they are part of
        so basically all the tiles in the solutions list will be moved at the end of the turn
        going though the possible solutions list, it will check against both the grid tiles and solution tiles to find solutions,
        but only tiles that aren't already in the solution tiles will be added to solution tiles

        once a solution is found for possible solutions tile, remove them from the possible solutions list and put them into solutions tile list

        instead of tracking the direction just put the adjacent tile into the second slot so it works like {32, 33} and {5, 5+x_len}
        but how do we deal with multiples like a cross an L shape or a T shape?
        we can just go from tile to tile and check only right and bottom connections this way it won't have an execive ammount of duplicates but should be able to check everything
        for example with the sidways T shape it will see the top two and check up and down from that, and do the same for the rest
        and with the solutions it will only add tiles that aren't already in solution_tiles]]

    -- checking horizontal matches
    for i = 0, sz.x_len * sz.y_len - 1 do
        -- exclude the right most column
        if i % sz.x_len != sz.x_len - 1 then
            -- if the tile to the right is the same color
            if grid[i] == grid[i + 1] then
                -- if the tile to the left isn't the same color
                if grid[i] != grid[i - 1] then
                    possible_solution = { i, i + 1 }
                    j = 2
                    -- check the next tile, if it's the same color, add to the table
                    while grid[i] == grid[i + j] do
                        add(possible_solution, i + j)
                        j += 1
                    end
                    add(possible_solutions, possible_solution)
                end
            end
        end
    end

    for i = 0, sz.x_len * sz.y_len - sz.x_len - 1 do
        -- check if tile below is the same color
        -- if the tile above matches this one then skip
        -- make new table with the two tile indexs
        -- continue to add tiles that sequentialy are also of the same color

        if grid[i] == grid[i + sz.x_len] then
            if grid[i] != grid[i - sz.x_len] then
                possible_solution = { i, i + sz.x_len }
                j = sz.x_len * 2
                -- check the next tile, if it's the same color, add to the table
                while grid[i] == grid[i + j] do
                    add(possible_solution, i + j)
                    j += sz.x_len
                end
                add(possible_solutions, possible_solution)
            end
        end
    end

    -- if one possible_solution ends where the other begins then the possible_solution to the left is invalid
    for i = 1, count(possible_solutions) do
        rect(
            possible_solutions[i][1] % sz.x_len * sp.screen_dim + sz.x_buff,
            flr(possible_solutions[i][1] / sz.x_len) * sp.screen_dim + sz.y_buff,
            possible_solutions[i][count(possible_solutions[i])] % sz.x_len * sp.screen_dim + sz.x_buff + sp.screen_dim - 1,
            flr(possible_solutions[i][count(possible_solutions[i])] / sz.x_len) * sp.screen_dim + sz.y_buff + sp.screen_dim - 1,
            0
        )
    end
end
-------- end page 1 --------
-->8
---------- page 2 ----------

-------- end page 2 --------

__gfx__
00000000555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888888888588888888888885888888888888888885888000000000000000000000000000000000000000000000000000000000000000000000000
00700700888888888888588888866666666668888866666666666688000000000000000000000000000000000000000000000000000000000000000000000000
0007700088888888888858888886444444446888886cccccccccc688000000000000000000000000000000000000000000000000000000000000000000000000
0007700055555555555555555556444444446555556cccccccc7c655000000000000000000000000000000000000000000000000000000000000000000000000
0070070088888885888888888886444444446888886ccccccc7cc688000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888885888888888886444444446888886cccccccccc688000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888885888888888886444444446888886cccccccccc688000000000000000000000000000000000000000000000000000000000000000000000000
0000000055555555555555555556444444446555556cccccccccc655000000000000000000000000000000000000000000000000000000000000000000000000
0000000088888888888858888886444444446858886cccccccccc688000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888888888588888864444449468588866666666666688000000000000000000000000000000000000000000000000000000000000000000000000
00000000888888888888588888864444444468588888888888885888000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555555555555555564444444465555555555555555555000000000000000000000000000000000000000000000000000000000000000000000000
00000000888588888888888858864444444468888885888888888888000000000000000000000000000000000000000000000000000000000000000000000000
00000000888588888888888858864444444468888885888888888888000000000000000000000000000000000000000000000000000000000000000000000000
00000000888588888888888858864444444468888885888888888888000000000000000000000000000000000000000000000000000000000000000000000000
