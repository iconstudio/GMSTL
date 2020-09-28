enum RBColor { Black, Red }

///@function 
function RBNode_Trait() constructor {
	Tree_Node_Tratit()
	color = RBColor.Red
}

///@function RBNode(value, color, [parent=undefined])
function RBNode(Value, Color) constructor {
	Tree_Node_Tratit()

	value = Value
	color = Color
	parent = 2 < argument_count ? argument[2] : undefined
	node_next = undefined
	node_previous = undefined

	///@function set_left(node)
	static set_left = function(Node) {
		node_left = Node
		node_previous = Node
		if !is_undefined(Node) {
			Node.node_next = self
			Node.parent = self
		}
	}

	///@function set_right(node)
	static set_right = function(Node) {
		node_right = Node
		node_next = Node
		if !is_undefined(Node) {
			Node.node_previous = self
			Node.parent = self
		}
	}

	static toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(value)
	}
}

///@function make_rb_node(value, color, [parent=undefined])
function make_rb_node(Value, Color, Parent) {
	return (new RBNode(Value, Color, Parent))
}

function RedBlack_Tree(): Container() constructor {
#region public
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
		var Right = Node.node_right
		var MoveTemp = Right.node_left
		if valid(MoveTemp)
			Node.set_right(MoveTemp)

		var Parent = Node.parent
		Right.parent = Parent // can be undefined.
		if Node == node_head {
			node_head = Right
		} else if valid(Parent) {
			if Node == Parent.node_left
				Parent.set_left(Right)
			else
				Parent.set_right(Right)
		}
		Right.set_left(Node)
	}

	///@function rotate_right(node)
	static rotate_right = function(Node) {
		var Left = Node.node_left
		var MoveTemp = Left.node_right
		if valid(MoveTemp)
			Node.set_left(MoveTemp)

		var Parent = Node.parent
		Left.parent = Parent // can be undefined.
		if Node == node_head {
			node_head = Left
		} else if valid(Parent) {
			if Node == Parent.node_right
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
			} else {
				return insert_recursive(Node, Next)
			}
		} else {
			var Next = StartNode.node_right
			if !valid(Next) {
				StartNode.set_right(Node)
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
			node_head = make_rb_node(Value, RBColor.Black)
		} else {
			var NewNode = make_rb_node(Value, RBColor.Red)
			insert_recursive(NewNode, node_head)

			var Node = NewNode, Aunt = undefined
			for (; Node.parent.color == RBColor.Red;) { // both are red.
				if !valid(Node.parent.parent)
					break

				if Node.parent == Node.parent.parent.node_left {
					Aunt = Node.parent.parent.node_right

					if valid(Aunt) and Aunt.color == RBColor.Red { // Recoloring
						Node.parent.color = RBColor.Black
						Aunt.color = RBColor.Black
						Node.parent.parent.color = RBColor.Red

						Node = Node.parent.parent
					} else if Aunt.color == RBColor.Black { // parent's sibling has red and black children
						if Node == Node.parent.node_right { // rotate right child to left
							Node = Node.parent
							rotate_left(Node)
						}

						Node.parent.color = RBColor.Black // propagate red up
						Node.parent.parent.color = RBColor.Red
						rotate_right(Node.parent.parent)
					}
				} else { // fixup red-red in right subtree
					Aunt = Node.parent.parent.node_left

					if valid(Aunt) and Aunt.color == RBColor.Red { // Recoloring
						Node.parent.color = RBColor.Black
						Aunt.color = RBColor.Black
						Node.parent.parent.color = RBColor.Red

						Node = Node.parent.parent
					} else if Aunt.color == RBColor.Black { // parent's sibling has red and black children
						if Node.parent == Node.parent.parent.node_left { // rotate left child to right
							Node = Node.parent
							rotate_right(Node)
						}

						Node.parent.color = RBColor.Black // propagate red up
						Node.parent.parent.color = RBColor.Red
						rotate_left(Node.parent.parent)
					}
				}
				if valid(Node) or !valid(Node.parent)
					break
			}
			node_head.color = RBColor.Black
		}
		return inner_size
	}

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_inquire_compare = method(other, Func) }

	///@function set_check_compare(compare_function)
	static set_check_compare = function(Func) { check_inquire_compare = method(other, Func) }

	static type = RedBlack_Tree
	static iterator_type = Bidirectional_iterator
	node_head = undefined
#endregion

#region private
	key_inquire_compare = compare_complex_less
	check_inquire_compare = compare_equal
	key_comparator = function(a, b) { return key_inquire_compare(a.value, b.value) }
	check_comparator = function(a, b) { return check_inquire_compare(a.value, b.value) }
	
	inner_size = 0

	// ** Contructor **
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

