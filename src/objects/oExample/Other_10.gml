/// @description Create a surface
preview_surface = surface_create(room_width, room_height)
surface_set_target(preview_surface)
draw_set_halign(0)
draw_set_valign(0)

var caption = ""
var parsed = accumulate(test1.first(), test1.last(), "", parser)
caption = "test1: " + parsed
caption += "\nIs sorted: " + string(is_sorted(test1.first(), test1.last()))
caption += "\nbsearch(11): " + string(binary_search(test1.first(), test1.last(), 11))

parsed = accumulate(test2.first(), test2.last(), "", parser)
caption += "\n\ntest2: " + parsed
caption += "\nIs sorted: " + string(is_sorted(test2.first(), test2.last()))
caption += "\nbsearch(2): " + string(binary_search(test2.first(), test2.last(), 2))

parsed = accumulate(test_sum.first(), test_sum.last(), "", parser)
caption += "\n\nSeed: " + string(random_get_seed())
caption += "\ntest_sum (shuffled): " + parsed

parsed = accumulate(test_tree.first(), test_tree.last(), "", parser)
caption += "\n\nTree: " + parsed

draw_text(8, 8, caption)

surface_reset_target()
