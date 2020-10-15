enum RBColor { Black, Red }

///@function RBTree_node(storage)
function RBTree_node(Storage): BSTree_node(Storage) constructor {
	BSTree_destroy = destroy
	///@function destroy()
	/*
			Splice the case of erasing a key from the Tree.
			
			case 1: a red node
				Just remove this.
			
			case 2: the black node has only one red child
				Remove this, pull up and blacken the child
			
			case 3: the node has two children
				
	*/
	static destroy = function() {
		var Left = node_left, Right = node_right
		var LeftChk = !is_undefined(Left), RightChk = !is_undefined(Right)
		var Left_IsRed = LeftChk and Left.color == RBColor.Red
		var Right_IsRed = RightChk and Right.color == RBColor.Red
		var Has_one_child = (LeftChk ^^ RightChk)

		var succesor = BSTree_destroy()
		succesor.color = RBColor.Black
		if color == RBColor.Red {
			// case 1
			return succesor
		} else {
			if Has_one_child and (Left_IsRed or Right_IsRed) {
				// case 2
				return succesor
			} else {
				var Is_head = is_undefined(parent)
				var Parent_IsRed = !Is_head and parent.color == RBColor.Red
				
				if Parent_IsRed {
					
				} else {
					if Left_IsRed {
						// case 4-1: 
					} else if Right_IsRed {
						// case 4-2:
					
					} else {
						//
					}
				}
			}
		}
	}

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
	static insert = function(Value) { return Iterator(_Under_insert_and_fix(node_head, Value)) }

	///@function insert_at(index, value)
	static insert_at = function(Key, Value) {
		var Loc = _Under_lower_bound(Key)
		if !is_undefined(Loc)
			return Iterator(_Under_insert_and_fix(Loc, Value))
		else
			return undefined
	}

	///@function insert_iter(iterator, value)
	static insert_iter = function(It, Value) {
		if It.storage == self
			return insert_at(It.index, Value)
		else
			return undefined
	}

	///@function erase_at(index)
	static erase_at = function(Key) {
		var Where = _Under_lower_bound(Key)
		if !is_undefined(Where)
			_Under_erase_node(Where)
	}

	///@function erase_iter(iterator)
	static erase_iter = function(It) {
		if It.storage == self
			_Under_erase_node(It.index)
	}

	static type = RedBlack_Tree
	static value_type = RBTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function 
	static _Under_rotate_left = function(Node) {
		var Succesor = Node.node_right
		Node.node_right = Succesor.node_left

		if valid(Succesor.node_left) {
			Succesor.node_left.parent = Node
		}

		Succesor.set_parent(Node.parent)
		if Node == node_head {
			node_head = Succesor
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

		if valid(Succesor.node_right) {
			Succesor.node_right.parent = Node
		}

		Succesor.set_parent(Node.parent)
		if Node == node_head {
			node_head = Succesor
		} else if Node == Node.parent.node_right {
			Node.parent.set_right(Succesor)
		} else {
			Node.parent.set_left(Succesor)
		}

		Succesor.set_right(Node)
	}

	///@function 
	static _Under_insert_and_fix = function(Node, Value) {
		Node = _Under_insert_at_node(Node, Value) // increasing size
		if inner_size == 1 {
			Node.color = RBColor.Black
			return Node
		}

		var Grandparent, Parent_on_Left = false, Aunt = undefined, Aunt_is_alive, Aunt_is_red, Aunt_is_black
		while !is_undefined(Node.parent) and Node.parent.color == RBColor.Red {
			Grandparent = Node.parent.parent
			Parent_on_Left = (Node.parent == Grandparent.node_left)

			if Parent_on_Left
				Aunt = Grandparent.node_right
			else
				Aunt = Grandparent.node_left
			Aunt_is_alive = valid(Aunt)
			Aunt_is_red = (Aunt_is_alive and Aunt.color == RBColor.Red)
			// Every nil node is BLACK.
			Aunt_is_black = (Aunt_is_alive and Aunt.color == RBColor.Black) or (!Aunt_is_alive)

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

	///@function 
	static _Under_erase_node = function(Node) {
		
	}

	///@function 
	static _Under_upper_bound_from_lower = function(Lower) {
		var Node = Lower, NodePrev = Lower, Key = _Under_extract_key(Lower), CompKey
		while !is_undefined(Node) {
			CompKey = _Under_extract_key(Node)
			if Key != CompKey {
				return Node
			} else {
				Node = Node.node_right
			}
		}
		return undefined
	}

	key_inquire_compare = compare_complex_less
	check_inquire_compare = compare_equal
	check_comparator = function(a, b) { return check_inquire_compare(a.value, b.value) }
	static node_nil = {
		parent: undefined,
		color: RBColor.Black
	}
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

