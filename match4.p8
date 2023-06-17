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

function check_grid()
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

-------- end page 2 --------

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07700770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
