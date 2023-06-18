pico-8 cartridge // http://www.pico-8.com
version 38
__lua__

---------- page 0 ----------
-- game engine

function _init()
    -- grid info (x_buff, y_buff, x_len, y_len)
    size_of_grid(8, 8, 14, 8)

    -- sprite data (x, y, dim, screen_dim)
    manage_sprite_data(8, 0, 8, 8)

    -- enable mouse and buttons (0x5f2d, lmb, rmb)
    poke(0x5f2d, 0x1, 0x2)

    -- initialize grid (x, y, tile types)
    init_grid(sz.x_len, sz.y_len, 5)

    -- initialize selected tile (-1 = no tile selected)
    initialize_selected_tile(-1)
end

function _update()
    -- set mouse position (x, y)
    set_mouse_pos(stat(32), stat(33))

    -- check for left mouse button (stat, mouse button)
    set_lmb(stat(34), 0x1)

    -- set selected tile (mouse button, clicked tile)
    set_selected_tile(lmb, get_clicked_tile())
end

function _draw()
    -- clear screen (color)
    cls(2)

    -- draw grid (grid x_length, grid y_length, dimension, screen dimension, x_buffer, y_buffer, sprite_data, grid_data, print_color)
    draw_grid(sz.x_len, sz.y_len, sprite_data.dim, sprite_data.screen_dim, sz.x_buff, sz.y_buff, sprite_data, grid, 7)

    highlight_selected_tile(selected_tile, sz.x_len, sz.x_buff, sz.y_buff, color)

    draw_ui()

    -- check grid (grid x_length, grid y_length, grid_data, x_buffer, y_buffer)
    check_grid(sz.x_len, sz.y_len, grid, sz.x_buff, sz.x_buff)

    --draw cursor (mouse stat, x stat, y stat, sprite 1, sprite 2, sprite dim x, sprite dim y)
    draw_cursor(stat(34), stat(32), stat(33), 16, 18, 2, 2)
    draw_debug()
end

-------- end page 0 --------
-->8
---------- page 1 ----------
-- helper functions

--[[
    checks if there is as least _count rows above this tile
    _tile: tile index
    _x_len: the width of the grid
    _count: minimum ammount of rows, default is 1
]]
function rows_above(_tile, _x_len, _count)
    local count = _count or 1
    return flr(_tile / _x_len) >= count
end

--[[
    checks if there is as least _count rows below this tile
    _tile: tile index
    _x_len: the width of the grid
    _y_len: the height of the grid
    _count: minimum ammount of rows, default is 1
]]
function rows_below(_tile, _x_len, _y_len, _count)
    local count = _count or 1
    return flr(_tile / _x_len) < _y_len - count
end

--[[
    checks if there is at least _count columns to the right this tile
    _tile: tile index
    _x_len: the width of the grid
    _count: minimum ammount of columns, default is 1
]]
function columns_right(_tile, _x_len, _count)
    local count = _count or 1
    return _tile % _x_len < _x_len - count
end

--[[
    checks if there is at least _count columns to the left of this tile
    _tile: tile index
    _x_len: the width of the grid
    _count: minimum ammount of columns, default is 1
]]
function columns_left(_tile, _x_len, _count)
    local count = _count or 1
    return _tile % _x_len >= count
end

-- get the last item in a table
function get_last(_table)
    return _table[#_table]
end

-- draws or enables drawing of debug information
function draw_debug()
    debug_clicked_tile()
end

-- hilights a tile on the grid
function highlight_tile(_tile, _x_len, _x_buff, _y_buff, _color)
    rect(
        _tile % _x_len * sprite_data.screen_dim + _x_buff,
        flr(_tile / _x_len) * sprite_data.screen_dim + _y_buff,
        _tile % _x_len * sprite_data.screen_dim + _x_buff + sprite_data.screen_dim - 1,
        flr(_tile / _x_len) * sprite_data.screen_dim + _y_buff + sprite_data.screen_dim - 1,
        _color
    )
end

-- hilights a group of tiles on the grid (make sure it's horizontal or vertical)
function highlight_tile_group(_tiles, _x_len, _x_buff, _y_buff, _color)
    rect(
        _tiles[1] % _x_len * sprite_data.screen_dim + _x_buff,
        flr(_tiles[1] / _x_len) * sprite_data.screen_dim + _y_buff,
        get_last(_tiles) % _x_len * sprite_data.screen_dim + _x_buff + sprite_data.screen_dim - 1,
        flr(get_last(_tiles) / _x_len) * sprite_data.screen_dim + _y_buff + sprite_data.screen_dim - 1,
        _color
    )
end

-- set selected tile (mouse button, clicked tile)
function set_selected_tile(mb, get_clicked)
    if mb then
        selected_tile = get_clicked
    end
    return selected_tile
end

-- check for left mouse button (stat, mouse button)
function set_lmb(stat, mb)
    lmb = band(stat, mb) == mb
end

-- initialize selected tile (selected tile)
function initialize_selected_tile(st)
    selected_tile = st
end

-- set mouse position
function set_mouse_pos(x_stat, y_stat)
    mouse_x = x_stat
    mouse_y = y_stat
end

-- grid info
function size_of_grid(_x_buff, _y_buff, _x_len, _y_len)
    sz = {
        x_buff = _x_buff,
        y_buff = _y_buff,
        x_len = _x_len,
        y_len = _y_len
    }
end

-- sprite data
function manage_sprite_data(_x, _y, _dim, _screen_dim)
    sprite_data = {
        { x = _x, y = _y },
        { x = _x * 2, y = _y },
        { x = _x * 3, y = _y },
        { x = _x * 4, y = _y },
        { x = _x * 5, y = _y },
        { x = _x * 6, y = _y },
        { x = _x * 7, y = _y },
        { x = _x * 8, y = _y },
        dim = _dim,
        screen_dim = _screen_dim
    }
end

function debug_clicked_tile()
    print(stat(34))
    if get_clicked_tile() != -1 then
        print("" .. get_clicked_tile() .. ":" .. grid[get_clicked_tile()], 0, 0, 7)
    else
        print("[nil]", 0, 0, 7)
    end
end

-- draw cursor (mouse stat, x stat, y stat, sprite 1, sprite 2, sprite dim x, sprite dim y)
function draw_cursor(mouse_stat, x_stat, y_stat, sprite_1, sprite_2, sprite_dim_x, sprite_dim_y)
    if mouse_stat == 1 then
        spr(sprite_1, x_stat - 1, y_stat - 1, sprite_dim_x, sprite_dim_y)
    else
        spr(sprite_2, x_stat - 1, y_stat - 1, sprite_dim_x, sprite_dim_y)
    end
end

function get_clicked_tile()
    if lmb then
        tile_x = flr((mouse_x - sz.x_buff) / sprite_data.screen_dim)
        tile_y = flr((mouse_y - sz.y_buff) / sprite_data.screen_dim)
        tile_index = tile_y * sz.x_len + tile_x

        -- return the tile index if it's valid
        if mouse_x >= sz.x_buff
                and mouse_x < sz.x_len * sprite_data.dim + sz.x_buff
                and mouse_y >= sz.y_buff
                and mouse_y < sz.y_len * sprite_data.dim + sz.y_buff then
            return tile_index
        end
    end

    return -1
end

-- draw grid (grid x_length, grid y_length, dimension, screen dimension, x_buffer, y_buffer, sprite_data, grid_data, print_color)
function draw_grid(_x_len, _y_len, _dim, _screen_dim, _x_buff, _y_buff, _sprite_data, _grid_data, _print_color)
    for i = 0, _x_len * _y_len - 1 do
        if true then
            sspr(
                _sprite_data[_grid_data[i]].x,
                _sprite_data[_grid_data[i]].y,
                _dim,
                _dim,
                i % _x_len * _screen_dim + _x_buff,
                flr(i / _x_len) * _screen_dim + _y_buff,
                _screen_dim, _screen_dim
            )
        end

        print(_grid_data[i], i % _x_len * _sprite_data.screen_dim + _x_buff + 1, flr(i / _x_len) * _sprite_data.screen_dim + _y_buff + 1, _print_color)
    end

    -- sspr(sprite x, sprite y, sprite width, sprite height, screen x, screen y, scale x, scale y)
    -- sspr(sprite_data[grid[i]].x, sprite_data[gird[i]].y, sprite_data.width, sprite_data.height, i % sz.x_len * 8 + sz.x_buff, flr(i / sz.x_len) * 8 + sz.y_buff, 1, 1)
    -- spr(sprite index, screen x, screen y, # sprite width, # sprite height)
end

-- hilight clicked tile
function highlight_selected_tile(_tile, _x_len, _x_buff, _y_buff, color)
    if _tile != -1 then
        highlight_tile(_tile, _x_len, _x_buff, _y_buff, color)
    end
end

function draw_ui()
    -- draw boarders
    rect(8, 73, 119, 120, 4)
    rectfill(9, 74, 10, 75, rnd(3))
    rectfill(117, 74, 118, 75, rnd(3))
end

function init_grid(x_len, y_len, tile_types)
    grid = {}
    for i = 0, x_len * y_len - 1 do
        grid[i] = flr(rnd(tile_types)) + 1
    end
end

-- checking matching horizontal sequential tiles
function horizontal_matches(_x_len, _y_len, _grid, _possible_solutions)
    -- go through all grid tiles
    for i = 0, _x_len * _y_len - 1 do
        -- exclude the right most column
        if i % _x_len != _x_len - 1 then
            -- if the tile to the right is the same color
            if _grid[i] == _grid[i + 1] then
                -- if the tile to the left isn't the same color or it's the left most tile
                if _grid[i] != _grid[i - 1] or i % _x_len == 0 then
                    -- make new table with the two tile indexs
                    local possible_solution = { i, i + 1 }
                    local j = 2
                    -- check the following tiles, if it's the same color, add to the table
                    while (i + j) % _x_len != 0 and _grid[i] == _grid[i + j] do
                        add(possible_solution, i + j)
                        j += 1
                    end
                    add(_possible_solutions, possible_solution)
                end
            end
        end
    end

    return _possible_solutions
end

-- checking matching vertical sequential tiles
function vertical_matches(_x_len, _y_len, _grid, _possible_solutions)
    -- checking vertical matches
    for i = 0, _x_len * _y_len - _x_len - 1 do
        -- check if tile below is the same color
        if _grid[i] == _grid[i + _x_len] then
            -- if the tile above matches this one then skip
            if _grid[i] != _grid[i - _x_len] then
                -- make new table with the two tile indexs
                local possible_solution = { i, i + _x_len }
                local j = _x_len * 2
                -- check the following tiles, if it's the same color, add to the table
                while _grid[i] == _grid[i + j] do
                    add(possible_solution, i + j)
                    j += _x_len
                end
                add(_possible_solutions, possible_solution)
            end
        end
    end

    return _possible_solutions
end

function valid_2_tile_solution(i, _horizontal, _possible_solutions, _grid, _x_len, _y_len)
    local valid = false

    if i > _horizontal then
        -- if the connecting tiles are vertical

        local tile_index = _possible_solutions[i][1]
        local tile_type = _grid[tile_index]
        -- the first item will be the top most tile so if there's a same tile x2 over the top of the first tile

        -- so if the top tile has at least 2 tiles above it
        if rows_above(tile_index, _x_len, 2) then
            -- if there is a matching tile two spaces above the top tile
            if _grid[tile_index - 2 * _x_len] == tile_type then
                -- check the left and right of the tile above the top tile

                -- check right
                if columns_right(tile_index, _x_len) then
                    if _grid[tile_index - _x_len + 1] == tile_type then
                        valid = true
                    end
                end

                -- check left
                if columns_left(tile_index, _x_len) then
                    if _grid[tile_index - _x_len - 1] == tile_type then
                        valid = true
                    end
                end
            end
        end

        tile_index = get_last(_possible_solutions[i])
        -- the last item will be the right most tile so if there's a same tile x2 over to the right of the first tile

        -- so if the bottom tile has at least 2 tiles below it
        if columns_right(tile_index, _x_len, 2) then
            -- if there is a matching tile two spaces below the bottom tile
            if _grid[tile_index + 2 * _x_len] == tile_type then
                -- check the left and right of the tile below the bottom tile

                -- check right
                if tile_index % _x_len < _x_len - 1 then
                    if _grid[tile_index + _x_len + 1] == tile_type then
                        valid = true
                    end
                end

                -- check left
                if tile_index % _x_len >= 1 then
                    if _grid[tile_index + _x_len - 1] == tile_type then
                        valid = true
                    end
                end
            end
        end
    else
        -- if horizontal

        local tile_index = _possible_solutions[i][1]
        local tile_type = _grid[tile_index]
        -- the first item will be the left most tile so if there's a same tile x2 over to the left of the first tile
        -- so if the first tile has at least 2 tiles to the left of it
        if tile_index % _x_len >= 2 then
            -- check the tile over by two
            if _grid[tile_index - 2] == tile_type then
                -- check the top and bottom for the tile to the left of the first tile

                -- if there is a row above
                if flr(tile_index / _x_len) >= 1 then
                    if _grid[tile_index - 1 - _x_len] == tile_type then
                        valid = true
                    end
                end
                -- if there is a row below
                if flr(tile_index / _x_len) < _y_len - 1 then
                    if _grid[tile_index - 1 + _x_len] == tile_type then
                        valid = true
                    end
                end
            end
        end

        tile_index = get_last(_possible_solutions[i])
        -- the last item will be the right most tile so if there's a same tile x2 over to the right of the first tile
        -- so if the last tile has at least 2 tiles to the right of it
        if tile_index % _x_len < _x_len - 2 then
            -- check the tile over by two
            if _grid[tile_index + 2] == tile_type then
                -- check the top and bottom for the tile to the right of the last tile

                -- if there is a row above
                if flr(tile_index / _x_len) >= 1 then
                    -- check that the above tile is the same
                    if _grid[tile_index + 1 - _x_len] == tile_type then
                        valid = true
                    end
                end
                -- if there is a row below
                if flr(tile_index / _x_len) < _y_len - 1 then
                    -- check that the below tile is the same
                    if _grid[tile_index + 1 + _x_len] == tile_type then
                        valid = true
                    end
                end
            end
        end
    end

    return valid
end

function valid_3_tile_solution(i, _horizontal, _possible_solutions, _x_len, _grid, _y_len)
    local valid = false

    --======================================================================================
    -- if the connecting tiles are vertical
    if i > _horizontal then
        local curr_tile = _possible_solutions[i][1]

        -- check if there is a left and right column
        local left = columns_left(curr_tile, _x_len)
        local right = columns_right(curr_tile, _x_len)

        local tile_type = _grid[curr_tile]

        --=================================================================
        -- [the first item will be the top most tile so check to the top, left, and right of the first tile]
        -- check above by 2
        if rows_above(curr_tile, _x_len, 2) then
            if (_grid[curr_tile - _x_len * 2] == tile_type) valid = true
        end
        -- if there is one row above
        if rows_above(curr_tile, _x_len) then
            local above_tile = curr_tile - _x_len

            -- check left
            if left then
                if (_grid[above_tile - 1] == tile_type) valid = true
            end

            -- check right
            if right then
                if (_grid[above_tile + 1] == tile_type) valid = true
            end
        end
        --=================================================================

        curr_tile = get_last(_possible_solutions[i])

        --=================================================================
        -- [the last item will be the bottom most tile so check the bottom, left, and right of the last tile]
        -- check below by 2
        if rows_below(curr_tile, _x_len, _y_len, 2) then
            if (_grid[curr_tile + _x_len * 2] == tile_type) valid = true
        end

        -- if there is one rows below
        if rows_below(curr_tile, _x_len, _y_len) then
            local below_tile = curr_tile + _x_len

            -- check left
            if left then
                if (_grid[below_tile - 1] == tile_type) valid = true
            end

            -- check right
            if right then
                if (_grid[below_tile + 1] == tile_type) valid = true
            end
        end
        --=================================================================

        --==================================================================================
    else
        --==================================================================================
        -- if the connecting tiles are horizontal

        local curr_tile = _possible_solutions[i][1]

        -- check if there's a above and below row
        local above = rows_above(curr_tile, _x_len)
        local below = rows_below(curr_tile, _x_len, _y_len)

        local tile_type = _grid[curr_tile]

        --=================================================================
        -- [the first tile will be the left most tile so check to the left, top, and bottom of the first tile]
        -- check to the left by 2
        if columns_left(curr_tile, _x_len, 2) then
            if (_grid[curr_tile - 2] == tile_type) valid = true
        end

        -- if there is one columns to the left
        if columns_left(curr_tile, _x_len) then
            local left_tile = curr_tile - 1

            -- check up
            if above then
                if (_grid[left_tile - _x_len] == tile_type) valid = true
            end

            -- check down
            if below then
                if (_grid[left_tile + _x_len] == tile_type) valid = true
            end
        end
        --=================================================================

        curr_tile = get_last(_possible_solutions[i])

        --=================================================================
        -- [the last tile will be the right most tile so check the right, top, and bottom of the last tile]
        -- check to the right by 2
        if columns_right(curr_tile, _x_len, 2) then
            if (_grid[curr_tile + 2] == tile_type) valid = true
        end

        -- if there is one colum to the right
        if columns_right(curr_tile, _x_len) then
            local right_tile = curr_tile + 1

            -- check up
            if above then
                if (_grid[right_tile - _x_len] == tile_type) valid = true
            end

            -- check down
            if below then
                if (_grid[right_tile + _x_len] == tile_type) valid = true
            end
        end
        --=================================================================
    end
    --======================================================================================

    return valid
end

--[[
    check for matching tiles and possible solutions
    returns:
   -1: error in function
    0: grid has possible solution with nothing matching
    1: gird has no possible solutions with nothing matching
[table]: table of correct tiles
]]
function check_grid(_x_len, _y_len, _grid, _x_buff, _y_buff)
    local possible_solutions = {}
    local solution_tiles = {}

    possible_solutions = horizontal_matches(_x_len, _y_len, _grid, possible_solutions)

    -- track when vertical matches start
    local horizontal = #possible_solutions

    possible_solutions = vertical_matches(_x_len, _y_len, _grid, possible_solutions)

    -- go though the possible solutions and find ones that are or could be playable moves
    for i = 1, #possible_solutions do
        local solvable = false

        if #possible_solutions[i] == 2 then
            -- check all 2 length connected tiles to see if it has a solution
            if valid_2_tile_solution(i, horizontal, possible_solutions, _grid, _x_len, _y_len) then
                solvable = true
            end
        elseif #possible_solutions[i] == 3 then
            -- check all 3 length connected tiles to see if it has a solution
            if valid_3_tile_solution(i, horizontal, possible_solutions, _x_len, _grid, _y_len) then
                solvable = true
            end
        else
            -- this is already a solution so add it to solutions
            solvable = true
        end

        if solvable then
            -- color = 9

            highlight_tile_group(possible_solutions[i], _x_len, _x_buff, _y_buff, 10)
        else
            -- the error is probably coming from the change in size so the index is shifted when one of them is deleted
            --deli(possible_solutions, i + 1)
            -- color = 0
        end
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
00000000ccccccccbbbbbbbb88888888eeeeeeee999999990000000000000000000000000007d000000000000007d00000000000000000000000000000077000
00000000ccccccccbbbbbbbb88888888eeeeeeee9999999900000000000000000000000000777d0000777d0000777d0000700000000007000070070000777700
00700700ccccccccbbbbbbbb88888888eeeeeeee99999999000000000000000000000000077777d000777d00077777d007777770077777700777777007777770
00077000ccccccccbbbbbbbb88888888eeeeeeee9999999900000000000000000000000000777d0000777d0000777d0077777770077777777777777777777777
00077000ccccccccbbbbbbbb88888888eeeeeeee9999999900000000000000000000000000777d0000777d0000777d00d77777700777777dd777777dd777777d
00700700ccccccccbbbbbbbb88888888eeeeeeee9999999900000000000000000000000000777d00077777d0077777d00d7dddd00dddd7d00d7dd7d00d7777d0
00000000ccccccccbbbbbbbb88888888eeeeeeee9999999900000000000000000000000000777d0000777d0000777d0000d0000000000d0000d00d0000d77d00
00000000ccccccccbbbbbbbb88888888eeeeeeee99999999000000000000000000000000000000000007d0000007d000000000000000000000000000000dd000
01100001110000000110000011100000000000000000000000000000000000000000000000000000011d111d0000000000000000000000000000000000000000
177101167710000017710011677100000000000000000000000000000000000000000000011d111d0cc1c7c10000000000000000000000000000000000000000
1777167167710000177711671677100000000000000000000000000000000000000000000cc1c7c19ac17cc10000000000000000000000000000000000000000
1677716777771000016777167777100000000000000000000000000000000000000000009ac17cc19a7aaaaa0000000000000000000000000000000000000000
0167777777577100001677777757710000000000000000000000000000000000000000009a7aaaaa9a7aaaaa0000000000000000000000000000000000000000
0016777757757100000177775775710000000000000000000000000000000000000000009a7010109a9101010000000000000000000000000000000000000000
0011677775777100000167777577710000000000000000000000000000000000000000009a91ddd1aa50ddd00000000000000000000000000000000000000000
001556777777711000155777777771100000000000000000000000000000000000000000aa501010055101010000000000000000000000000000000000000000
00156677777717710015677777771771000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00016677777777710001677777777771000000000000000000000000000000000000000000082000000a90000000000000000000000000000000000000000000
00001666661776100000166661777610000000000000000000000000000000000000000000082000000a90000000000000000000000000000000000000000000
00000111116761000000011116776100000000000000000000000000000000000000000000082000000a90000000000000000000000000000000000000000000
00000000156610000000000156671000000000000000000000000000000000000000000000082000000a90000000000000000000000000000000000000000000
00000000155100000000000155510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000011000000000000011100000000000000000000000000000000000000000000000082000000a90000000000000000000000000000000000000000000
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
