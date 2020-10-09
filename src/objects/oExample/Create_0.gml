function print(container) { foreach(container.first(), container.last(), show_debug_message) }
function parser(init, value) {
	if "" == init
		return string(value)
	else
		return init + ", " + string(value)
}

draw_set_circle_precision(48)
draw_set_font(fontExample)
randomize()
//random_set_seed(4160491905)

test1 = new List(4, 2, 8, 13, 11, 9) // 6
test2 = new Array(3, 3.5, 26, 7, 10, 15, 5, 4.5) // 8
test_sum = new List()

sort(test1.first(), test1.last())
stable_sort(test2.first(), test2.last())
merge(test1.first(), test1.last(), test2.first(), test2.last(), test_sum.first())
random_shuffle(test_sum.first(), test_sum.last())

//BinarySearch_tree
tree_indicator_start_pos = [room_width * 0.5, room_height * 0.2]
tree_indicator_node_radius = 16

tree_indicator_node_link_length_begin = 190
tree_indicator_node_link_length_end = tree_indicator_node_radius * 3
tree_indicator_node_link_angle_begin = 8
tree_indicator_node_link_angle_end = 75
test_tree = new RedBlack_Tree(test_sum)
test_tree.insert(5)
test_tree.insert(12)
test_tree.insert(7)
test_tree.insert(16)

repeat 60
	test_tree.insert(irandom(80))

tree_head = test_tree.node_head
tree_size = test_tree.size()
tree_scaler = ceil(log2(tree_size))

function rbtree_print(Cont, NodeStart, Msg) {
	Msg = select_argument(Msg, "[" + string(NodeStart) + "]\t")
	show_debug_message(Msg)

	var LeftNode = NodeStart.node_left, RightNode = NodeStart.node_right
	var LeftChk = !is_undefined(LeftNode), RightChk = !is_undefined(RightNode)

	if LeftChk {
		rbtree_print(Cont, LeftNode, "LEFT(" + string(NodeStart) + ") -> [" + string(LeftNode) + "]\t")
	}

	if RightChk {
		rbtree_print(Cont, RightNode, "RIGHT(" + string(NodeStart) + ") -> [" + string(RightNode) + "]\t")
	}
}

function draw_rbtree_node(Dx, Dy, Node) {
	Dx = floor(Dx)
	Dy = floor(Dy)
	draw_set_color($101010)
	draw_circle(Dx, Dy, tree_indicator_node_radius, false)
	if Node.color == RBColor.Red
		draw_set_color($ff)
	else
		draw_set_color($ffffff)
	draw_circle(Dx, Dy, tree_indicator_node_radius, true)
	draw_set_color($ffffff)
	draw_text(Dx, Dy, Node.value)
}

function draw_rbtree_init() {
	draw_rbtree(tree_indicator_start_pos[0], tree_indicator_start_pos[1], tree_head, 0)
}

function draw_rbtree(Dx, Dy, Node, Height) {
	var LeftNode = Node.node_left, RightNode = Node.node_right
	var LeftChk = !is_undefined(LeftNode), RightChk = !is_undefined(RightNode)

	var Indicator_ratio = Height / tree_scaler
	var Length_ratio = min(1, Indicator_ratio * 0.5)
	var Angle_ratio = min(1, Indicator_ratio * Indicator_ratio * 1.7)
	var Length = lerp(tree_indicator_node_link_length_begin, tree_indicator_node_link_length_end, Length_ratio)
	var Angle = lerp(tree_indicator_node_link_angle_begin, tree_indicator_node_link_angle_end, Angle_ratio)
	var Llx = lengthdir_x(1, 180 + Angle), Lly = lengthdir_y(1, 180 + Angle), Nx, Ny
	var Scolor, Ecolor, Alen = Length - tree_indicator_node_radius

	if LeftChk {
		Nx = Dx + Llx * Length
		Ny = Dy + Lly * Length
		if LeftNode.node_next == Node {
			draw_set_color($adf8350)
			var Ax = Nx - Llx * Alen
			var Ay = Ny - Lly * Alen
			draw_line_width(Dx + Llx * 30, Dy + Lly * 30, Nx, Ny, 4)
			draw_arrow(Nx, Ny, Ax, Ay, 18)
		} else {
			if Node.color == RBColor.Red
				Scolor = $ff
			else
				Scolor = $101010
			if LeftNode.color == RBColor.Red
				Ecolor = $ff
			else
				Ecolor = $101010
			draw_set_color($ffffff)
			draw_line_width(Dx, Dy, Nx, Ny, 6)
			draw_line_width_color(Dx, Dy, Nx, Ny, 4, Scolor, Ecolor)
		}

		draw_rbtree(Nx, Ny, LeftNode, Height + 1)
	}

	if RightChk {
		Nx = Dx - Llx * Length
		Ny = Dy + Lly * Length
		if Node.node_next == RightNode {
			draw_set_color($adf8350)
			var Ax = Dx - Llx * Alen
			var Ay = Dy + Lly * Alen
			draw_line_width(Dx, Dy, Nx + Llx * 30, Ny - Lly * 30, 4)
			draw_arrow(Dx, Dy, Ax, Ay, 18)
		} else {
			if Node.color == RBColor.Red
				Scolor = $0000ff
			else
				Scolor = $101010
			if RightNode.color == RBColor.Red
				Ecolor = $0000ff
			else
				Ecolor = $101010
			draw_set_color($ffffff)
			draw_line_width(Dx, Dy, Nx, Ny, 6)
			draw_line_width_color(Dx, Dy, Nx, Ny, 4, Scolor, Ecolor)
		}

		draw_rbtree(Nx, Ny, RightNode, Height + 1)
	}

	draw_rbtree_node(Dx, Dy, Node)
}

rbtree_print(test_tree, tree_head)
event_user(0)
show_debug_message("")

/*
show_debug_message("")

test_tree.erase_at(2)
test_tree.erase_at(11)
test_tree.erase_at(8)
test_tree.erase_at(26)
node_tree_print(test_tree, test_tree.node_head)
show_debug_message(test_tree.front())
show_debug_message(test_tree.back())

//var Loc = test_tree.location(26)
//show_debug_message("Loc: " + string(Loc.get()))

show_debug_message("\n")
/*
var count_dem = count_if(test_sum.first(), test_sum.last(), function(Value) {
	return !is_undefined(Value) and frac(Value) != 0
})
show_debug_message("Count of Demical: " + string(count_dem))

show_debug_message("\nPartitions")
my_value = 3
test_predicate = function(Value) { // It can use its member fields.
	return (Value mod my_value == 0)
}
var part_point = partition(test_sum.first(), test_sum.last(), test_predicate)
var is_parted = is_partitioned(test_sum.first(), test_sum.last(), test_predicate)
print(test_sum)
show_debug_message("Is parted: " + string(is_parted))
show_debug_message("Parted on: " + string(part_point.index))

var nth = 8
show_debug_message("\nNth Sorting (" + string(nth) + ")")
random_shuffle(test_sum.first(), test_sum.last())
var nth_interator = iterator_advance(test_sum.first(), nth)
var nth_value = nth_interator.get()
nth_element(test_sum.first(), nth_interator, test_sum.last())
show_debug_message("Rearranged On: " + string(nth_interator.index))
show_debug_message("The Stand Value: " + string(nth_value))

var nth_result_iterator = iterator_advance(test_sum.first(), nth)
var nth_result_value = nth_result_iterator.get()
show_debug_message("The " + string(nth) + "th Iterator: " + string(nth_result_iterator.index))
show_debug_message("The " + string(nth) + "th Value: " + string(nth_result_value))
print(test_sum)

show_debug_message("\nTransform a List into a paired List")
test_mapped_list = new List("D", "E", "A", "T", "H", "K", "N", "I", "G", "H", "T")
// Transform into paired-container
transform(test_mapped_list.first(), test_mapped_list.last(), test_mapped_list.first(), function (Value) {
	return [Value, irandom(3)]
})
test_mapped_list.push_back(["@", "1st"])
test_mapped_list.push_back(["@", "2nd"])
test_mapped_list.push_back(["@", "3rd"])
test_mapped_list.push_back(["@", "4th"])
test_mapped_list.push_back(["@", "5th"])
test_mapped_list.push_back(["AA", "AA"])
test_mapped_list.push_back(["AB", "AB"])
test_mapped_list.push_back(["CT", "CT_1"])
test_mapped_list.push_back(["CT", "CT_2"])
test_mapped_list.push_back(["CT", "CT_3"])
test_mapped_list.push_back(["CT", "CT_4"])
test_mapped_list.push_back(["CT", "CT_5"])
test_mapped_list.push_back(["CT", "CT_6"])
test_mapped_list.push_back(["CZ", "CZ"])
test_mapped_list.push_back(["AC", "AC"]) // 17
show_debug_message("Map")
test_map = new Map(test_mapped_list)
print(test_map)

show_debug_message("\nUnordered_Map")
test_unomap = new Unordered_map(test_mapped_list)
print(test_unomap)

show_debug_message("\nMultimap")
test_multimap = new Multimap(test_mapped_list)
test_multimap.insert(1, 10)
test_multimap.insert(2, 15)
test_multimap.insert(10, 50)
test_multimap.insert(11, 55)
test_multimap.insert(12, 60)
test_multimap.insert(0, new Wrapper("0-1st"))
test_multimap.insert(0, new Wrapper("0-2nd"))
test_multimap.insert(0, new Wrapper("0-3rd"))
test_multimap.insert(1, new Wrapper("1-1st"))
test_multimap.insert(1, new Wrapper("1-2nd"))
test_multimap.insert(1, new Wrapper("1-3rd"))

var i, TempPair, Key, Values
for (i = 0; i < test_multimap.bucket_count(); ++i) {
	TempPair = test_multimap.at(i)
	Key = TempPair[0]
	Values = TempPair[1] // List
	show_debug_message("Values with key " + string(Key) + ": ")
	print(Values)
}
