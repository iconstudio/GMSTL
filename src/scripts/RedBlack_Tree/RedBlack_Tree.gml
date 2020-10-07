enum RBColor { Black, Red }

///@function RBTree_node(storage)
function RBTree_node(Storage): BSTree_node(Storage) constructor {
	static toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(value)
	}

	///@function insert(value)
	static insert = function(Value){
		var Info = _Under_insert(Value)
		var Node = Info[0], Position = Info[1]
		
	}

	color = RBColor.Red
	node_nil = Storage.node_nil

	static type = RBTree_node
}

function RedBlack_Tree(): BinarySearch_tree() constructor {
#region public
	///@function valid(element)
	static valid = function(Node) { return !is_undefined(Node) and Node != node_nil }

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

	///@function insert(value)
	///@description Imported from Visual Studio.
	static insert = function(Value) { // This is a pure value.
		var NewNode = _Under_insert(node_head, Value) // increasing size
		show_debug_message("Value: " + string(Value))
		if 2 < inner_size {
			var Node = NewNode, Aunt = undefined, Aunt_is_alive, Aunt_is_red, Aunt_is_black
			for (; valid(Node.parent) and valid(Node.parent.parent) and Node.parent.color == RBColor.Red;) { // both are red.

				if Node.parent == Node.parent.parent.node_left {
					Aunt = Node.parent.parent.node_right
					Aunt_is_alive = valid(Aunt)
					Aunt_is_red = (Aunt_is_alive and Aunt.color == RBColor.Red)
					Aunt_is_black = !Aunt_is_alive or (Aunt_is_alive and Aunt.color == RBColor.Red)

					if Aunt_is_red { // Recoloring
						Node.parent.color = RBColor.Black
						Aunt.color = RBColor.Black
						Node.parent.parent.color = RBColor.Red

						Node = Node.parent.parent
					} else if Aunt_is_black { // parent's sibling has red and black children
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
					Aunt_is_alive = valid(Aunt)
					Aunt_is_red = (Aunt_is_alive and Aunt.color == RBColor.Red)
					Aunt_is_black = !Aunt_is_alive or (Aunt_is_alive and Aunt.color == RBColor.Red)

					if Aunt_is_black { // Recoloring
						Node.parent.color = RBColor.Black
						Aunt.color = RBColor.Black
						Node.parent.parent.color = RBColor.Red

						Node = Node.parent.parent
					} else if Aunt_is_black { // parent's sibling has red and black children
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
		}

		node_head.color = RBColor.Black
		return Iterator(NewNode)
	}

	static type = RedBlack_Tree
	static value_type = RBTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	key_inquire_compare = compare_complex_less
	check_inquire_compare = compare_equal
	check_comparator = function(a, b) { return check_inquire_compare(a.value, b.value) }
	static node_nil = {}
#endregion

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

