pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

---------- page 0 ----------
-- game engine
candy_types = 5 -- assuming 5 types of candies
grid = {}
sz = {
    x_buff = 8,
    y_buff = 8,
    x_max = 14,
    y_max = 8
}
function _init()
    structure_grid()
end

function _update()
end

function _draw()
    cls(12)
    draw_grid()

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
    for i = 0, sz.x_max * sz.y_max - 1 do
        spr(grid[i], i % sz.x_max * 8 + sz.x_buff, flr(i / sz.x_max) * 8 + sz.y_buff, 1, 1)
    end
end

function draw_ui()
    rect(8, 73, 119, 120, 4)
    rectfill(9, 74, 10, 75, rnd(3))
    rectfill(117, 74, 118, 75, rnd(3))
end

function structure_grid()
    for i = 0, sz.x_max * sz.y_max do
        grid[i] = rnd(5) + 1
    end
end

--[[
    check for matching tiles and possible solutions
    returns:
    -1: error in function
     0: grid has possible solution with nothing matching
     1: grid has a match
     2: gird has no possible solutions with nothing matching
]]
function check_grid()
    checkedTiles = {}
    possibleSolutions = {}
    solutionTiles = {}
    --[[a possible solution has to consist of two matching tiles and what direction they are pointing in,
        since we will only be checking horizontal and vertical
        {tile number, direction}, {32, vertical}, {5, horizontal}

        how do we deal with an L shaped connection?
        have a solutions group that consists of the tiles that are part of the solution and remove those tiles independent of which match they are part of
        so basically all the tiles in the solutions list will be moved at the end of the turn
        going though the possible solutions list, it will check against both the grid tiles and solution tiles to find solutions,
        but only tiles that aren't already in the solution tiles will be added to solution tiles

        once a solution is found for possible solutions tile, remove them from the possible solutions list and put them into solutions tile list

        instead of tracking the direction just put the adjacent tile into the second slot so it works like {32, 33} and {5, 5+x_max}
        but how do we deal with multiples like a cross an L shape or a T shape?
        we can just go from tile to tile and check only right and bottom connections this way it won't have an execive ammount of duplicates but should be able to check everything
        for example with the sidways T shape it will see the top two and check up and down from that, and do the same for the rest]]
    for i = 0, sz.x_max * sz.y_max do
    end
end
-------- end page 1 --------
-->8
---------- page 2 ----------

-------- end page 2 --------

__gfx__
0000000000eeee0000555500005555000033330000dddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111100111111001111110011111100111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700e188aa1f51bbbb1d51eeee16318ccc12d199991f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000e1888a1f51bbcb1d51eaaa16318c8c12d1eee91f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000e18a8a1f51cbbb1d51aaea16318ccc12d1e9ee1f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700e1888a1f51cccc1d51aaaa163188cc12d1eeee1f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011111100111111001111110011111100111111000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ffff0000dddd00006666000022220000ffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000
