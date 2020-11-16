enum RBColor { Black, Red }

///@function RBTree_node(storage)
function RBTree_node(Storage): BSTree_node(Storage) constructor {
	color = RBColor.Red

	static type = RBTree_node

	static toString = function() {
		return (color == RBColor.Black ? "Black: " : "Red: ") + string(data)
	}
}

function RedBlack_tree(): BinarySearch_tree() constructor {
#region public
	///@function insert(value)
	static insert = function(Key) { return Iterator(_Under_try_insert(node_pointer_head, Key)) }

	///@function insert_at(index, value)
	static insert_at = function(Hint, Key) { return Iterator(_Under_try_insert(first_of(Hint), Key)) }

	///@function erase_at(index)
	static erase_at = function(Key) { _Under_erase_and_fix(first_of(Key)) }

	///@function erase_iter(iterator)
	static erase_iter = function(It) { if It.storage == self _Under_erase_and_fix(It.index) }

	static type = RedBlack_tree
	static value_type = RBTree_node
#endregion

#region private
	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = insert_at

	///@function 
	static _Under_try_insert = function(Location, Key) {
		if is_undefined(Location) {
			return undefined
		} else if Location == node_pointer_head and is_undefined(node_head) {
			inner_size = 1
			node_head = new value_type(self).set_key(Key)
			node_head.color = RBColor.Black
			return node_head
		} else {
			if Location == node_pointer_head
				return _Under_insert_and_fix(node_head, Key)
			 else
				return _Under_insert_and_fix(Location, Key)
		}
	}

	///@function 
	static _Under_rotate_left = function(Node) {
		var Succesor = Node.node_right
		Node.node_right = Succesor.node_left

		if !is_undefined(Succesor.node_left) {
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

		if !is_undefined(Succesor.node_right) {
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
	static _Under_insert_and_fix = function(Hint, Value) {
		if is_undefined(Hint)
			return undefined

		var Node = _Under_insert_at_node(Hint, Value) // increasing size
		if is_undefined(Node)
			return undefined

		var NewNode = Node
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
		if 1 < inner_size {
			node_leftest = node_head.find_leftest()
			node_rightest = node_head.find_rightest()
		}
		return NewNode
	}

	///@function 
	static _Under_inserter = _Under_insert_and_fix

	///@function 
	/*
			Splice the case of erasing a data from the Tree.
			
			case 1: a red node
				Just remove this.
			
			case 2: the black node has only one red child
				Remove this, pull up and blacken the child
			
			case 3: the node has two children
				
	*/
	static _Under_erase_and_fix = function(Node) {
		if is_undefined(Node)
			return undefined

		var Result = Node.node_next

		var NodeErased = Node // node to erase
		var NodePointer = NodeErased
		var Fix_node // the node to recolor as needed
		var Fix_nodeparent // parent of Fix_node (which may be nil)

		if is_undefined(NodePointer.node_left) {
			Fix_node = NodePointer.node_right // stitch up right subtree
		} else if is_undefined(NodePointer.node_right) {
			Fix_node = NodePointer.node_left // stitch up left subtree
		} else { // two subtrees, must lift successor node to replace erased
			NodePointer = Node // NodePointer is successor node
			Fix_node = NodePointer.node_right // Fix_node is only subtree
		}
		var Fix_available = is_undefined(Fix_node)

		if NodePointer == NodeErased { // at most one subtree, relink it
			Fix_nodeparent = NodeErased.parent

			if node_head == NodeErased {
				node_head = Fix_node; // link down from root
			} else if Fix_nodeparent.node_left == NodeErased {
				Fix_nodeparent.set_left(Fix_node) // link down to left
			} else {
				Fix_nodeparent.set_right(Fix_node) // link down to right
			}

			if node_leftest == NodeErased
				node_leftest = Fix_available ? Fix_nodeparent : Fix_node.find_leftest()

			if node_rightest == NodeErased
				node_rightest = Fix_available ? Fix_nodeparent : Fix_node.find_rightest()

		} else { // erased has two subtrees, NodePointer is successor to erased
			NodePointer.set_left(NodePointer)
			//NodeErased.node_left.parent = NodePointer // link left up
			//NodePointer.node_left = NodeErased.node_left // link successor down

			if NodePointer == NodeErased.node_right {
				Fix_nodeparent = NodePointer // successor is next to erased
			} else { // successor further down, link in place of erased
				Fix_nodeparent = NodePointer.parent // parent is successor's
				Fix_nodeparent.set_left(Fix_node) // link fix down
				NodePointer.set_left(NodeErased.node_right)
				//NodePointer.node_right = NodeErased.node_right; // link next down
				//NodeErased.node_right.parent = NodePointer; // right up
			}

			if node_head == NodeErased {
				node_head = NodePointer // link down from root
			} else if NodeErased.parent.node_left == NodeErased {
				NodeErased.parent.node_left = NodePointer // link down to left
			} else {
				NodeErased.parent.node_right = NodePointer // link down to right
			}

			NodePointer.parent = NodeErased.parent // link successor up
 
			var TempColor = NodePointer.color
			NodePointer.color = NodeErased.color
			NodeErased.color = TempColor
		} // else

		if (NodeErased.color == RBColor.Black) { // erasing black link, must recolor/rebalance tree
			for (; Fix_node != node_head && Fix_node.color == RBColor.Black; Fix_nodeparent = Fix_node.parent) {
				if (Fix_node == Fix_nodeparent.node_left) { // fixup left subtree
					NodePointer = Fix_nodeparent.node_right;
					if (NodePointer.color == RBColor.Red) { // rotate red up from right subtree
						NodePointer.color = RBColor.Black;
						Fix_nodeparent.color = RBColor.Red;
						rotate_left(Fix_nodeparent);
						NodePointer = Fix_nodeparent.node_right;
					}

					if (NodePointer.Is_nil) {
						Fix_node = Fix_nodeparent; // shouldn't happen
					} else if (NodePointer.node_left.color == RBColor.Black
								&& NodePointer.node_right.color == RBColor.Black) { // redden right subtree with black children
						NodePointer.color = RBColor.Red;
						Fix_node = Fix_nodeparent;
					} else { // must rearrange right subtree
						if (NodePointer.node_right.color == RBColor.Black) { // rotate red up from left sub-subtree
							NodePointer.node_left.color = RBColor.Black;
							NodePointer.color = RBColor.Red;
							rotate_right(NodePointer);
							NodePointer = Fix_nodeparent.node_right;
						}

						NodePointer.color = Fix_nodeparent.color;
						Fix_nodeparent.color = RBColor.Black;
						NodePointer.node_right.color = RBColor.Black;
						rotate_left(Fix_nodeparent);
						break; // tree now recolored/rebalanced
					}
				} else { // fixup right subtree
					NodePointer = Fix_nodeparent.node_left;
					if (NodePointer.color == RBColor.Red) { // rotate red up from left subtree
						NodePointer.color = RBColor.Black;
						Fix_nodeparent.color = RBColor.Red;
						rotate_right(Fix_nodeparent);
						NodePointer = Fix_nodeparent.node_left;
					}

					if (NodePointer.Is_nil) {
						Fix_node = Fix_nodeparent; // shouldn't happen
					} else if (NodePointer.node_right.color == RBColor.Black
								&& NodePointer.node_left.color == RBColor.Black) { // redden left subtree with black children
						NodePointer.color = RBColor.Red;
						Fix_node = Fix_nodeparent;
					} else { // must rearrange left subtree
						if (NodePointer.node_left.color == RBColor.Black) { // rotate red up from right sub-subtree
							NodePointer.node_right.color = RBColor.Black;
							NodePointer.color = RBColor.Red;
							rotate_left(NodePointer);
							NodePointer = Fix_nodeparent.node_left;
						}

						NodePointer.color = Fix_nodeparent.color;
						Fix_nodeparent.color = RBColor.Black;
						NodePointer.node_left.color = RBColor.Black;
						rotate_right(Fix_nodeparent);
						break; // tree now recolored/rebalanced
					}
				}
			}

			Fix_node.color = RBColor.Black // stopping node is black
		}

		if 0 < inner_Size
			inner_Size--

		return Result
		
		if is_undefined(Node) {
			return undefined
		} else if Node.color == RBColor.Red {
			// case 1
			var Succesor = _Under_erase_node(Node)
			Succesor.color = RBColor.Black
			return Succesor
		} else {
			var Left = Node.node_left, Right = Node.node_right
			var LeftChk = !is_undefined(Left), RightChk = !is_undefined(Right)
			var Left_IsRed = LeftChk and Left.color == RBColor.Red
			var Right_IsRed = RightChk and Right.color == RBColor.Red
			var Succesor = _Under_erase_node(Node)
			Succesor.color = RBColor.Black

			if LeftChk ^^ RightChk and (Left_IsRed or Right_IsRed) {
				// case 2
				return Succesor
			} else {
				Left = Succesor.node_left
				Right = Succesor.node_right
				LeftChk = !is_undefined(Left)
				RightChk = !is_undefined(Right)
				Left_IsRed = LeftChk and Left.color == RBColor.Red
				Right_IsRed = RightChk and Right.color == RBColor.Red
				var Parent = Succesor.parent
				var Is_head = (Succesor == node_head)
				var Parent_IsRed = !Is_head and Parent.color == RBColor.Red
				var Node_on_Left = (Succesor == Parent.node_left)

				var Cousin
				if Node_on_Left
					Cousin = Parent.node_right
				else
					Cousin = Parent.node_left
				var Cousin_is_alive = !is_undefined(Cousin)
				var Cousin_is_red = (Cousin_is_alive and Cousin.color == RBColor.Red)
				// Every nil node is BLACK.
				var Cousin_is_black = (Cousin_is_alive and Cousin.color == RBColor.Black) or (!Cousin_is_alive)

				if Cousin_is_alive {
					var CousinSib
					if Node_on_Left {
						CousinSib = Cousin.node_right
						_Under_rotate_left(Parent)
					} else {
						CousinSib = Cousin.node_left
						_Under_rotate_right(Parent)
					}
					if is_undefined(CousinSib)
						CousinSib.color = RBColor.Black
					if Parent_IsRed
						Cousin.color = RBColor.Red
					else
						Cousin.color = RBColor.Black
				}
				
				if Parent_IsRed {
					if Cousin_is_red {
						Parent.color = RBColor.Black
						Cousin.color = RBColor.Red
					}
					return Succesor
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

