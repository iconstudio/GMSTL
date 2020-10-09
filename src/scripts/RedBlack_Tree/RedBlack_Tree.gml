enum RBColor { Black, Red }

///@function RBTree_node(storage)
function RBTree_node(Storage): BSTree_node(Storage) constructor {
	///@function insert(value)
	static insert = _Under_insert

	color = RBColor.Red
	node_nil = Storage.node_nil
	static type = RBTree_node

	static toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(value)
	}
}

function RedBlack_Tree(): BinarySearch_tree() constructor {
#region public
	///@function valid(element)
	static valid = function(Node) { return !is_undefined(Node) and Node != node_nil }

	///@function insert(value)
	///@description Imported from Visual Studio.
	static insert = function(Value) { return Iterator(_Under_insert_and_fix(Value)) }

	static type = RedBlack_Tree
	static value_type = RBTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function 
	static _Under_rotate_left = function(Node) {
		var Succesor = Node.node_right
		Node.node_right = Succesor.node_left

		if !is_undefined(Succesor.node_left) {
			Succesor.node_left.parent = Node
		}

		if Node == node_head {
			node_head = Succesor
			Succesor.set_parent(undefined)
		} else if Node == Node.parent.node_left {
			Node.parent.set_left(Succesor)
		} else {
			Node.parent.set_right(Succesor)
		}

		Succesor.set_left(Node)
	}

	///@function 
	static _Under_rotate_right = function(Node) {
		var Succesor = Node.node_left
		Node.node_left = Succesor.node_right

		if !is_undefined(Succesor.node_right) {
			Succesor.node_right.parent = Node
		}

		if Node == node_head {
			node_head = Succesor
			Succesor.set_parent(undefined)
		} else if Node == Node.parent.node_right {
			Node.parent.set_right(Succesor)
		} else {
			Node.parent.set_left(Succesor)
		}

		Succesor.set_right(Node)
	}

	static _Under_insert_and_fix = function(Value) { // This is a pure value.
		var Node = _Under_insert_at_node(node_head, Value) // increasing size
		if inner_size == 1 {
			Node.color = RBColor.Black
			show_debug_message("New Node: " + string(Node))
			return Node
		}
		show_debug_message("New Node: " + string(Node))

		var Grandparent, Parent_on_Left = false, Aunt = undefined, Aunt_is_alive, Aunt_is_red, Aunt_is_black
		while !is_undefined(Node.parent) and Node.parent.color == RBColor.Red {
			Grandparent = Node.parent.parent
			Parent_on_Left = (Node.parent == Grandparent.node_left)

			if Parent_on_Left
				Aunt = Grandparent.node_right
			else
				Aunt = Grandparent.node_left
			Aunt_is_alive = !is_undefined(Aunt)
			Aunt_is_red = (Aunt_is_alive and Aunt.color == RBColor.Red)

			if Aunt_is_red { // Recoloring
				Node.parent.color = RBColor.Black
				Aunt.color = RBColor.Black
				Grandparent.color = RBColor.Red

				Node = Grandparent
			} else { // parent's sibling has red and black children
				if Parent_on_Left { // fixup red-red in left subtree
					if Node == Node.parent.node_right { // rotate right child to left
						Node = Node.parent
						_Under_rotate_left(Node)
					}

					Node.parent.color = RBColor.Black // propagate red up
					Grandparent.color = RBColor.Red
					_Under_rotate_right(Grandparent)
				} else { // fixup red-red in right subtree
					if Node.parent == Grandparent.node_left { // rotate left child to right
						Node = Node.parent
						_Under_rotate_right(Node)
					}

					Node.parent.color = RBColor.Black // propagate red up
					Grandparent.color = RBColor.Red
					_Under_rotate_left(Grandparent)
				}
			}
		}
		node_head.color = RBColor.Black
		return Node
	}

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

