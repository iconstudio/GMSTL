enum RBColor { Black, Red }
enum RBChild { Left, Right, None }

///@function RBNode(value, color, [parent=undefined])
function RBNode(Value, Color) constructor {
	color = Color
	value = Value
	child_type = RBChild.None
	parent = 2 < argument_count ? argument[2] : undefined
	node_left = undefined
	node_right = undefined
	next = undefined

	///@function set_left(node)
	static set_left = function(Node) {
		node_left = Node
		Node.child_type = RBChild.Left
		Node.next = self
		Node.parent = self
	}

	///@function set_right(node)
	static set_right = function(Node) {
		node_right = Node
		Node.child_type = RBChild.Right
		next = Node
		Node.parent = self
	}

	static toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(value)
	}
}

///@function make_rb_node(value, color, [child_type=none], [parent=undefined])
function make_rb_node(Value, Color, Chty, Parent) {
	var NewNode = new RBNode(Value, Color, Parent)
	NewNode.child_type = select_argument(Chty, RBChild.None)
	return NewNode
}

function RedBlack_Tree(): Container() constructor {
	///@function size()
	static size = function() { return inner_size }

	///@function empty()
	static empty = function() { return bool(inner_size == 0) }

	///@function valid(node)
	static valid = function(Node) { return !is_undefined(Node) }

	///@function first()
	static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
	static last = function() { return (new iterator_type(self, size())).pure() }

	///@function front()
	static front = function() { return first().get() }

	///@function back()
	static back = function() { return last().get() }

	///@function minimum([start_node=head])
	static minimum = function() {
		var Result, StartNode = 0 < argument_count ? argument[0] : node_head
		while valid(StartNode) {
			Result = StartNode
			StartNode = StartNode.node_left
		}
		return Result
	}

	///@function maximum([start_node=head])
	static maximum = function() {
		var Result, StartNode = 0 < argument_count ? argument[0] : node_head
		while valid(StartNode) {
			Result = StartNode
			StartNode = StartNode.node_right
		}
		return Result
	}

	///@function find_of(value)
	static find_of = function(Value) {
		if 0 == size()
			return undefined

		var Result, NodeIt = node_head
		while valid(NodeIt) {
			Result = NodeIt
			if check_comparator(Value, NodeIt.value) {
				return Result
			} else {
				if key_comparator(Value, NodeIt.value)
					NodeIt = NodeIt.node_left
				else
					NodeIt = NodeIt.node_right
			}

		}
		return undefined
	}

	///@function count_of(value)
	static count_of = function(Value) {
		if 0 == size()
			return 0

		var Result = 0, NodeIt = node_head
		while valid(NodeIt) {
			if check_comparator(Value, NodeIt.value) {
				Result++
			}

			if key_comparator(Value, NodeIt.value)
				NodeIt = NodeIt.node_left
			else
				NodeIt = NodeIt.node_right

		}
		return Result
	}

	///@function rotate_left(axis_node)
	static rotate_left = function(Node) {
		var Right = Node.node_left
		var LeftofRight = Right.node_right
        Node.set_right(LeftofRight)

        if Node == node_head {
			node_head = Right
		} else {
			var Parent = Node.parent
			if Node.child_type == RBChild.Left
				Parent.set_left(Right)
			else
				Parent.set_right(Right)
		}
        Right.set_left(Node)
	}

	///@function rotate_right(node)
	static rotate_right = function(Node) {
		var Left = Node.node_left
		var RightofLeft = Left.node_right
        Node.set_left(RightofLeft)

        if Node == node_head {
			node_head = Left
		} else {
			var Parent = Node.parent
			if Node.child_type == RBChild.Right
				Parent.set_right(Left)
			else
				Parent.set_left(Left)
		}
        Left.set_right(Node)
	}

	///@function insert_recursive(node, start_node)
	static insert_recursive = function(Node, StartNode) { // They are node.
		if key_inquire_compare(Node, StartNode) {
			var Next = StartNode.node_left
			if !valid(Next) {
				StartNode.set_left(Node)
				show_debug_message(string(StartNode) + "'s LEFT: " + string(Node))
			} else {
				return insert_recursive(Node, Next)
			}
		} else {
			var Next = StartNode.node_right
			if !valid(Next) {
				StartNode.set_right(Node)
				show_debug_message(string(StartNode) + "'s RIGHT: " + string(Node))
			} else {
				return insert_recursive(Node, Next)
			}
		}
		return StartNode
	}

	///@function insert(item)
	///@description Imported from Visual Studio.
	static insert = function(Value) { // This is a pure value.
		var Size = inner_size++
		if 0 == Size {
			node_head = make_rb_node(Value, RBColor.Black, RBChild.None)
			node_head.parent = node_head
			//node_head.node_left = node_head
			//node_head.node_right = node_head
		} else {
			var NewNode = make_rb_node(Value, RBColor.Red, RBChild.None)
			insert_recursive(NewNode, node_head)
			if inner_size < 3 // at least 3 nodes.
				return inner_size

			var Node = NewNode, Aunt = undefined
			for (; Node.parent.color == RBColor.Red;) {
	            if Node.parent.child_type == RBChild.Left {
	                Aunt = Node.parent.parent.node_right

	                if Aunt.color == RBColor.Red { // Recoloring
	                    Node.parent.color = RBColor.Black
	                    Aunt.color = RBColor.Black
	                    Node.parent.parent.color = RBColor.Red

	                    Node = Node.parent.parent
	                } else { // parent's sibling has red and black children
	                    if Node.child_type == RBChild.Right { // rotate right child to left
	                        Node = Node.parent

	                        rotate_left(Node)
	                    }

	                    Node.parent.color = RBColor.Black // propagate red up
	                    Node.parent.parent.color = RBColor.Red
	                    rotate_right(Node.parent.parent)
	                }
	            } else { // fixup red-red in right subtree
	                Aunt = Node.parent.parent.node_left

	                if Aunt.color == RBColor.Red { // Recoloring
	                    Node.parent.color = RBColor.Black
	                    Aunt.color = RBColor.Black
	                    Node.parent.parent.color = RBColor.Red

	                    Node = Node.parent.parent
	                } else { // parent's sibling has red and black children
	                    if Node == Node.parent.node_left { // rotate left child to right
	                        Node = Node.parent
	                        rotate_right(Node)
	                    }

	                    Node.parent.color = RBColor.Black // propagate red up
	                    Node.parent.parent.color = RBColor.Red
	                    rotate_left(Node.parent.parent)
	                }
	            }
			}
			node_head.color = RBColor.Black
		}
		return inner_size
	}

	///@function set_key_comp(compare_function)
	static set_key_comp = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_comp(compare_function)
	static set_check_comp = function(Func) { check_comparator = method(other, Func) }

	type = RedBlack_Tree
	key_comparator = compare_complex_less
	check_comparator = compare_equal
	key_inquire_compare = function(a, b) { return key_comparator(a.value, b.value) }
	check_inquire_compare = function(a, b) { return check_comparator(a.value, b.value) }
	node_head = undefined
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

