///@function RBNode(value, color, [parent=undefined])
static RBNode = function(Value, Color, Parent) constructor {
	color = Color
	value = Value
	parent = select_argument(Parent, undefined)
	child_type = RBChild.None
	node_left = undefined
	node_right = undefined
	next = undefined
	toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(value)
	}
}

///@function make_rb_node(value, color, child_type, [parent=undefined], [next=undefined], [left=undefined], [right=undefined])
static make_rb_node = function(Value, Color, Chty, Parent, NNext, Left, Right) {
	var NewNode = new RBNode(Value, Color, Parent)
	NewNode.child_type = select_argument(Chty, RBChild.None)
	NewNode.next = NNext
	NewNode.node_left = Left
	NewNode.node_right = Right
	return NewNode
}

enum RBColor { Black, Red }
enum RBChild { Left, Right, None }

function RedBlack_Tree(): Container() constructor {
	///@function size()
	static size = function() { return inner_size }

	///@function empty()
	static empty = function() { return bool(inner_size == 0) }

	///@function first()
	static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
	static last = function() { return (new iterator_type(self, size())).pure() }

	///@function front()
	static front = function() { return first().get() }

	///@function back()
	static back = function() { return last().get() }

	///@function find_of(value)
	static find_of = function(Value) {
		if 0 == size()
			return undefined

		var CompVal, Index = 0, Size = size()
		while Index < Size {
			CompVal = at(Index)
			if check_comparator(Value, CompVal) {
				return Index
			} else {
				if key_comparator(Value, CompVal)
					Index = left(Index)
				else
					Index = right(Index)
			}
		}
		return undefined
	}

	///@function count_of(value)
	static count_of = function(Value) { return 0 }

	///@function retouch(index)
	static retouch = function(Index) { 
		var Node = at(Index)
		var LeftNode = at_left(Index), RightNode = at_right(Index)
		if LeftNode.color == RED and RightNode.color = RED {
			Node.color = RED
			LeftNode.color = BLACK
			RightNode.color = BLACK
			if 2 < Index { // height is greater than 1.
				var Parent = find_parent(Node)
				if Parent.color == RED
					retouch(find_parent(Parent))
			}
		}
	}

	///@function move_children_of_right(index, destination)
	static move_children_of_right = function(Index, Target) {
		var Right = right(Index), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, NODE_NULL)

		if RightChk
			move_children(Right, right(Target))

		set(Target, Value)
	}

	///@function insert_recursive(node, hint)
	static insert_recursive = function(Node, Hint) { // This is a pure value.
		if !valid(Hint) {
			set(Hint, Node)
			return Hint
		} else {
			if key_inquire_compare(Node, at(Hint))
				return insert_recursive(Node, left(Hint))
			else
				return insert_recursive(Node, right(Hint))
		}
	}

	///@function insert(item)
	static insert = function(Value) { // This is a pure value.
		var Size = size()
		if 0 == Size {
			node_head = new RBNode(Value, RBColor.Black)
			node_smallest = node_head
			node_largest = node_head
			inner_size = 1
			return 1
		} else if 1 == Size { // hardcoded for optimizing
			var NewNode = new RBNode(Value, RED, at(0))
			if key_inquire_compare(NewNode, at(0)) {
				set(1, NewNode)
				return 2
			} else {
				set(2, NewNode)
				return 2
			}
		} else {
			var NewNode = new RBNode(Value, RED, 0)
			var Index = insert_recursive(NewNode, 0)
			show_debug_message("01")
			var PreIndex = find_parent(Index)
			var PrePreIndex = find_parent(PreIndex)
			show_debug_message("02")
			show_debug_message("Pre Index: " + string(PreIndex))
			show_debug_message("Pre Pre Index: " + string(PrePreIndex))
			if valid(PreIndex) and valid(PrePreIndex) { // all hierachy is going on.
				show_debug_message("03")
				var ParentNode = at(PreIndex)
				if ParentNode.color == RED { // parent is red
					show_debug_message("04")
					var GrandLeft = left(PrePreIndex), GrandRight = right(PrePreIndex)
					var UncleIndex = -1, UncleNode
					if GrandLeft == ParentNode
						UncleIndex = GrandRight
					else if GrandRight == ParentNode
						UncleIndex = GrandLeft

					if valid(UncleIndex) {
						UncleNode = at(UncleIndex)
						if UncleNode.color == RED { // The brother of parent is red.
							show_debug_message("05-1")
							retouch(PrePreIndex)
						} else { // The brother of parent is black.
							show_debug_message("05-2")
							var ParentLeft = left(PreIndex), ParentRight = right(PreIndex)
							var GrandParentNode = at(PrePreIndex)
							if Index == ParentRight { // new node is at right of parent.
								show_debug_message("06-1")
								// ** Rotate to Left **
								var MovedNewIndex = right(ParentLeft)
								move_children(PreIndex, ParentLeft)
								move_children_of_right(MovedNewIndex, PreIndex)
								move_children(left(MovedNewIndex), MovedNewIndex)
							} else if Index == ParentLeft { // new node is at left of parent.
								show_debug_message("06-1")
								// ** Rotate to Right **
								GrandParentNode.color = RED
								ParentNode.color = BLACK
								move_children_of_right(PrePreIndex, UncleIndex)
								move_children(ParentRight, left(UncleIndex))
								move_children(PreIndex, PrePreIndex)
							}

							show_debug_message("07")
						}
					}
				}
			}
		}
	}

	///@function set_key_comp(compare_function)
	static set_key_comp = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_comp(compare_function)
	static set_check_comp = function(Func) { check_comparator = method(other, Func) }

	type = RedBlack_Tree
	key_comparator = compare_less
	check_comparator = compare_equal
	key_inquire_compare = function(a, b) { return key_comparator(a.value, b.value) }
	check_inquire_compare = function(a, b) { return check_comparator(a.value, b.value) }
	node_head = undefined
	node_smallest = undefined
	node_largest = undefined
	inner_size = 0

	// ** Assigning **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < inner_size; ++i) insert(Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				foreach(Item.first(), Item.last(), insert)
			} else {
				// (*) Arg
				insert(Item)
			}
		} else {
			// (*) Iterator-Begin, Iterator-End
			if argument_count == 2 {
				if is_struct(argument[0]) and is_iterator(argument[0])
				and is_struct(argument[1]) and is_iterator(argument[1]) {
					foreach(argument[0], argument[1], insert)
					exit
				}
			}
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}

