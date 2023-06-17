pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

---------- page 0 ----------
-- game engine
tile_types = 5
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
    { x = 16, y = 0 },
    { x = 24, y = 0 },
    { x = 32, y = 0 },
    { x = 40, y = 0 },
    { x = 48, y = 0 },
    { x = 56, y = 0 },
    { x = 64, y = 0 },
    dim = 8,
    screen_dim = 8
}
function _init()
    -- enable mouse and buttons
    poke(0x5f2d, 0x1, 0x2)
    -- initialize grid
    init_grid()
end

function _update()
    local clicked_tile = get_clicked_tile()
    if clicked_tile ~= nil then
        -- handle the click event, e.g., remove the tile
        print("clicked on tile: " .. clicked_tile)
    end
end

function _draw()
    cls(12)
    draw_grid()
    check_grid()

    --draw cursor
    spr(0, stat(32) - 1, stat(33) - 1)
    print(stat(34))
    if get_clicked_tile() != -1 then
        print("" .. get_clicked_tile() .. ":" .. grid[get_clicked_tile()], 0, 0, 7)
    else
        print("[nil]", 0, 0, 7)
    end

    draw_ui()
end

-------- end page 0 --------
-->8
---------- page 1 ----------
-- helper functions

function get_clicked_tile()
    mouse_x = stat(32)
    mouse_y = stat(33)
    left_button = band(stat(34), 0x1) == 0x1

    if left_button then
        tile_x = flr((mouse_x - sz.x_buff) / sp.screen_dim)
        tile_y = flr((mouse_y - sz.y_buff) / sp.screen_dim)
        tile_index = tile_y * sz.x_len + tile_x

        -- return the tile index if it's valid
        if mouse_x >= sz.x_buff
                and mouse_x <= sz.x_len * sp.dim + sz.x_buff
                and mouse_y >= sz.y_buff
                and mouse_y <= sz.y_len * sp.dim + sz.y_buff then
            return tile_index
        end
    end

    return -1
end

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

        print(grid[i], i % sz.x_len * sp.screen_dim + sz.x_buff + 1, flr(i / sz.x_len) * sp.screen_dim + sz.y_buff + 1, 7)
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
    for i = 0, sz.x_len * sz.y_len - 1 do
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
    possible_solutions = {}
    solution_tiles = {}

    -- checking horizontal matches
    for i = 0, sz.x_len * sz.y_len - 1 do
        -- exclude the right most column
        if i % sz.x_len != sz.x_len - 1 then
            -- if the tile to the right is the same color
            if grid[i] == grid[i + 1] then
                -- if the tile to the left isn't the same color or it's the left most tile
                if grid[i] != grid[i - 1] or i % sz.x_len == 0 then
                    -- make new table with the two tile indexs
                    possible_solution = { i, i + 1 }
                    j = 2
                    -- check the following tiles, if it's the same color, add to the table
                    while grid[i] == grid[i + j] and (i + j) % sz.x_len != 0 do
                        add(possible_solution, i + j)
                        j += 1
                    end
                    add(possible_solutions, possible_solution)
                end
            end
        end
    end

    -- track when vertical matches start
    vertical = #possible_solutions

    -- checking vertical matches
    for i = 0, sz.x_len * sz.y_len - sz.x_len - 1 do
        -- check if tile below is the same color
        if grid[i] == grid[i + sz.x_len] then
            -- if the tile above matches this one then skip
            if grid[i] != grid[i - sz.x_len] then
                -- make new table with the two tile indexs
                possible_solution = { i, i + sz.x_len }
                j = sz.x_len * 2
                -- check the following tiles, if it's the same color, add to the table
                while grid[i] == grid[i + j] do
                    add(possible_solution, i + j)
                    j += sz.x_len
                end
                add(possible_solutions, possible_solution)
            end
        end
    end

    --deli(possible_solutions, 1) starts at 1 not 0

    for i = 1, #possible_solutions do
        color = 0

        if #possible_solutions[i] == 2 then
            solvable = false
            if i < vertical then
                -- if horizontal
                -- the first item will be the left most tile so check to the left, top, and bottom of the first tile
                -- the last item will be the right most tile so check the right, top, and bottom of the last tile
            else
                -- if vertical
                -- the first item will be the top most tile so check to the top, left, and right of the first tile
                -- the last item will be the bottom most tile so check the bottom, left, and right of the last tile
            end
            if solvable then color = 7 end
        elseif #possible_solutions[i] == 3 then
            solvable = false
            if i < vertical then
                -- if horizontal
                -- the first item will be the left most tile so check to the left, top, and bottom of the first tile
                -- the last item will be the right most tile so check the right, top, and bottom of the last tile
            else
                -- if vertical
                -- the first item will be the top most tile so check to the top, left, and right of the first tile
                -- the last item will be the bottom most tile so check the bottom, left, and right of the last tile
            end
            if solvable then color = 7 end
        else
            color = 9
        end

        if i < vertical then
            color = 7
        else
            color = 0
        end

        rect(
            possible_solutions[i][1] % sz.x_len * sp.screen_dim + sz.x_buff,
            flr(possible_solutions[i][1] / sz.x_len) * sp.screen_dim + sz.y_buff,
            possible_solutions[i][#possible_solutions[i]] % sz.x_len * sp.screen_dim + sz.x_buff + sp.screen_dim - 1,
            flr(possible_solutions[i][#possible_solutions[i]] / sz.x_len) * sp.screen_dim + sz.y_buff + sp.screen_dim - 1,
            color
        )
    end
end
-------- end page 1 --------
-->8
---------- page 2 ----------
function make_array_of_false(indexes)
    local array = {}
    for i = 0, indexes do
        array[i] = false
    end
    return array
end
---hello world
-------- end page 2 --------

__gfx__
0000000022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0000000022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0070070022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0007700022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0007700022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0070070022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0000000022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
0000000022222222bbbbbbbb8888888811111111aaaaaaaaeeeeeeee44444444dddddddd00000000000000000000000000000000000000000000000000000000
01100001110000000110000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17710116771000001771001167710000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
17771671677100001777116716771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16777167777710000167771677771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01677777775771000016777777577100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00167777577571000001777757757100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00116777757771000001677775777100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00155677777771100015577777777110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00156677777717710015677777771771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00016677777777710001677777777771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001666661776100000166661777610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000111116761000000011116776100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000156610000000000156671000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000155100000000000155510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011000000000000011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88855888855558888555888888555888888558888885588888855888888558888855888888855588888588888855888888555558888558888885888885558888
88858888888588888885588888858888885588888885888888858888888588888885888888858888888588888885558888855888888588888885888888858888
85558666666666666666666666658888885588888855558888558888555588888885558888858888888555888885588888858888885588888855888888855888
55555666666666666666666666655555555555555550055555555555005555555555555555555555555555555555555555555555555555555555555555555555
8558866cccccccc66cccccccc6688855588888c88850900500000500908888585588866666666666666666666668855888888558888888558888885888888858
8888866cccccc7c66cccccc7c668885888888ccc8880799099799099708888588888864444444444444444444468885888888858888888588888555888888858
8888866ccccc7cc66ccccc7cc66885588888ccacc880709999799990708885588888864444444444444444444468885888888855588885588888588888888858
5555566cccccccc66cccccccc665555555555ccc5555099999799999055555555555564444444444444444444465555555555555555555555555555555555555
8855866cccccccc66cccccccc6658888888558c88855099099799099055558888855864444444444444444444465588888558888888555588885888885558888
8885866cccccccc66cccccccc6658888888588b88880999097779099908558888885864444444444444444444465888888858888888588888885888888858888
8855566cccccccc66cccccccc6655888885588bb88809ee0770770ee908588888885864444444444444444444465888888855588888588888885888888855888
555556666666666666666666666555555555555b5550997770707779905555555555564444444444444444444465555555555555555555555555555555555555
5588866cccccccc66cccccccc6688885588888bbb888097777777779088888885588864444444444444444444468888558888888588885555888888855888888
5888866cccccc7c66cccccc7c668888858888fffff88800777777700588888885888864444444444444444444468888858888888588888885888888858888888
5888866ccccc7cc66ccccc7cc665888858888fffff88809447774499055888885888864444444444444444444468888855588888588888885588885558888885
5555566cccccccc66cccccccc665555555555fffff55509977777999905555555555564444444444444444444465555555555555555555555555555555555555
8888866cccccccc66cccccccc668558888ddddddddddd09000000090dddddd588888864444444444444444444468855888888558888855888888558888885588
8888866cccccccc66cccccccc6688588886dddddddddd090ddddd070ddddd6888888864444444444444444444468858888885588888885888888858888888588
5588866cccccccc66cccccccc6688558856666666666607066666606666666885888864444444444444499944468558858888588888885855888858888888588
55555666666666666666666666655555555666666666660666666666666665555555564444444444444499944465555555555555555555555555555555555555
55888666666666666666666666688855888866668888885555888885666688858888864444444444444499944468885588888885588888858888885588558885
88888885888888858888888588888855888886658888888588888885866888858888864444444444444444444468888588888885888888858888888588888885
88888885858885558888885555888885588886655888888588888855866888555558864444444444444444444468888558888855888888855888888558888855
55555555555555555555555555555555555555555555555555555555555555555555564444444444444444444465555555555555555555555555555555555555
88555888888558888885888855558888888558888885588888558888885588888885864444444444444444444465588888558888885588888555888888855888
88855888888588888885888888858888888588888885888888558888888588888885864444444444444444444465888888858888888588888885888888858888
88858888885588888855888888855888885588888555888888855888888558888855864444444444444444444465888888858888888558888885888558858888
55555555555555555555555555555555555555555555555555555555555555555555564444444444444444444465555555555555555555555555555555555555
88885558888888558888885558888858588888588888555888888855888888585888864444444444444444444468855588885558888888555888885588888858
88888858888888588888855888888558888888588888885888888858888888588888864444444444444444444468885888888858888888588888885888888858
88888858888885588888855888888558888855588888885555888858888885588888864444444444444444444468885888888855588888588888855888888558
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88558822222222222222222222858888885555588885588888858888855588888855555888855888888588888555888888555558888558888885888885558888
88858211111111111111111111258888888558888885888888858888888588888885588888858888888588888885888888855888888588888885888888858888
88852111111111111111111111125888888588888855888888558888888558888885888888558888885588888885588888858888885588888855888888855888
55521111111111111111111111112555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88211111111111111111111111111258888885588888885588888858888888588888855888888855888888588888885888888558888888558888885888888858
82111111111111111111111111111128888888588888885888885558888888588888885888888858888855588888885888888858888888588888555888888858
82111111111111111111111111111128888888555888855888885888888888588888885558888558888858888888885888888855588885588888588888888858
52111111111111111111111111111125555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
82111111111111111111111111111128885588888885555888858888855588888855888888855558888588888555888888558888888555588885888885558888
82111111111111111111111111111128888588888885888888858888888588888885888888858888888588888885888888858888888588888885888888858888
82111111111111111111111111111128888555888885888888858888888558888885558888858888888588888885588888855588888588888885888888855888
52111111111111111111111111111125555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
52111111111111111111111111111128588888885888855558888888558888885888888858888555588888885588888858888888588885555888888855888888
52111111111111111111111111111128588888885888888858888888588888885888888858888888588888885888888858888888588888885888888858888888
52111111111111111111111111111125555888885888888855888855588888855558888858888888558888555888888555588888588888885588885558888885
52111111111111111111111111111125555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
82111111111111111111111111111128888885588888558888885588888855888888855888885588888855888888558888888558888855888888558888885588
82111111111111111111111111111128888855888888858888888588888885888888558888888588888885888888858888885588888885888888858888888588
52111111111111111111111111111128588885888888858558888588888885885888858888888585588885888888858858888588888885855888858888888588
52111111111111111111111111111125555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
82111111111111111111111111111125888888855888888588888855885588858888888558888885888888558855888588888885588888858888885588558885
82111111111111111111111111111125888888858888888588888885888888858888888588888885888888858888888588888885888888858888888588888885
52111111111111111111111111111125588888558888888558888885588888555888885588888885588888855888885558888855888888855888888558888855
52211111115111511111111111111225555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
88211111d5555555ddd555d511111288885588888855888885558888888558888855888888558888855588888885588888558888885588888555888888855888
88211111d5ddd5dddd555dd511111288888588888885888888858888888588888885888888858888888588888885888888858888888588888885888888858888
82211166666666666666666651111228888588888885588888858885588588888885888888855888888588855885888888858888888558888885888558858888
5211116ddddddddddddddddd51111125555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
82111155555555555555555551111128888855588888885558888855888888588888555888888855588888558888885888885558888888555888885588888858
82222222222222222222222222222228888888588888885888888858888888588888885888888858888888588888885888888858888888588888885888888858
88888855588888588888855888888558888888555888885888888558888885588888885558888858888885588888855888888855588888588888855888888558
