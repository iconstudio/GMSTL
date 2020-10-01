///@function 
function BSTree_node(): Tree_node_tratit() constructor {
	///@function set_parent(node)
	static set_parent = function(Node) { underlying_set_parent(Node) }

	///@function set_left(node)
	static set_left = function(Node) { return underlying_set_left(Node) }

	///@function set_right(node)
	static set_right = function(Node) { return underlying_set_right(Node) }

	///@function set_next(node)
	static set_next = function(Node) {
		if !is_undefined(node_next) {
			node_next.node_previous = undefined
		}
		node_next = Node
		if !is_undefined(Node) {
			Node.node_previous = self
			return true
		}
		return false
	}

	///@function set_previous(node)
	static set_previous = function(Node) {
		if !is_undefined(node_previous) {
			node_previous.node_next = undefined
		}
		node_previous = Node
		if !is_undefined(Node) {
			Node.node_next = self
			return true
		}
		return false
	}

	///@function set(value)
	static set = function(Value) { value = Value; return self }

	///@function get()
	static get = function() { return value; }

	///@function destroy()
	static destroy = function() {
		if !is_undefined(node_previous) {
			if !is_undefined(node_next) {
				node_previous.set_next(node_next)
			} else {
				node_previous.set_next(undefined)
			}
		}
		underlying_destroy()

		return node_previous
	}
}

enum BSTree_child {
	none = 0,
	left,
	right
}

function BinarySearch_tree(): Binary_tree() constructor {
#region public
	///@function front()
	static front = function() { return node_leftest }

	///@function back()
	static back = function() { return node_rightest }

	///@function first()
	static first = function() { return Iterator(node_leftest) }

	///@function last()
	static last = function() { return undefined }

	///@function insert(value)
	static insert = function(Value) {
		var NewNode = make_node(Value)
		if 0 == inner_size++ {
			node_head = NewNode
			node_leftest = NewNode
			node_rightest = NewNode
			return NewNode
		}

		// hardcoded
		var HeadKey = extract_key(node_head)
		if Value == HeadKey {
			delete NewNode
			return Iterator(node_head)
		} else if key_inquire_comparator(NewNode, HeadKey) {
			if is_undefined(node_head.node_left) { // 1 == size
				node_leftest = NewNode
				node_head.set_left(NewNode)
				NewNode.set_next(node_head)
				return Iterator(NewNode)
			} else {
				var Result = underlying_insert_by_node(node_head.node_left, NewNode)
				if key_inquire_comparator(Value, extract_key(node_leftest))
					node_leftest = Result

				return Iterator(Result)
			}
		} else {
			if is_undefined(node_head.node_right) { // 2 == size
				node_rightest = NewNode
				node_head.set_right(NewNode)
				node_head.set_next(NewNode)
				return Iterator(NewNode)
			} else {
				var Result = underlying_insert_by_node(node_head.node_right, NewNode)
				if !key_inquire_comparator(Value, extract_key(node_rightest))
					node_rightest = Result

				return Iterator(Result)
			}
		}
	}

	///@function insert_at(key, value)
	static insert_at = function(Key, Value) {
		var InsLoc = location(Key)
		if !is_undefined(InsLoc)
			return Iterator(underlying_insert_by_node(InsLoc.index, Value))
		else
			return insert(Value)
	}

	///@function insert_iter(iterator, value)
	static insert_iter = function(It, Value) {
		if It.storage != self
			return undefined
		else
			return Iterator(underlying_insert_by_node(It.index, Value))
	}

	///@function location(value)
	static location = function(Value) {
		if 0 == inner_size
			return undefined

		var Node = node_head, CompVal
		while !is_undefined(Node) {
			CompVal = extract_key(Node)
			if Value == CompVal {
				return Iterator(Node)
			} else {
				if key_inquire_comparator(Value, CompVal)
					Node = Node.node_left
				else
					Node = Node.node_right
			}
		}
		return undefined
	}

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_inquire_comparator = method(other, Func) }

	static type = BinarySearch_tree
	static value_type = BSTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function 
	static extract_key = function(Node) { return Node.value }

	///@function 
	static underlying_insert_by_node = function(Hint, ValueNode) {
		var Value = extract_key(ValueNode), OrgKey = extract_key(Hint)
		if Value == OrgKey {
			return Hint
		} else if key_inquire_comparator(Value, OrgKey) {
			if is_undefined(Hint.node_left) {
				Hint.set_left(ValueNode)
				var Prev = Hint.node_previous
				if !is_undefined(Prev)
					Prev.set_next(ValueNode)
				ValueNode.set_next(Hint)
				return ValueNode
			} else {
				return underlying_insert_by_node(Hint.node_left, ValueNode)
			}
		} else {
			if is_undefined(Hint.node_right) {
				Hint.set_right(ValueNode)
				var Promote = Hint.parent, ProValue, Upheal
				while !is_undefined(Promote) {
					ProValue = extract_key(Promote)
					if key_inquire_comparator(Value, ProValue) {
						ValueNode.set_next(Promote)
						break
					} else {
						Upheal = Promote.parent
						if is_undefined(Upheal)
							break

						Promote = Upheal
					}
				}
				Hint.set_next(ValueNode)
				return ValueNode
			} else {
				return underlying_insert_by_node(Hint.node_right, ValueNode)
			}
		}
	}

	///@function 
	/*
			Splice the case of erasing a key from the Tree.
			
			case 1: a leaf node
				Just remove it.
			
			case 2: the node has one child
				Remove it and pull up its children.
			
			case 3: the node has two children
				Replace it with smallest one and remove the original smallest one.
	*/
	static underlying_erase_node = function(Node) {
		if !is_undefined(Node) {
			var Parent = Node.parent
			var Left = Node.node_left, Right = Node.node_right
			var LeftChk = !is_undefined(Left), RightChk = !is_undefined(Right)

			if !LeftChk and !RightChk { // has no child
				Node.destroy()
				delete Node
			} else if LeftChk and !RightChk { // on left
				if Node == node_head {
					node_head = Left
				} else {
					if Node == Parent.node_left {
						Parent.set_left(Left)
					} else if Node == Parent.node_right {
						Parent.set_right(Left)
					}
				}
				Node.destroy()
				delete Node
			} else if !LeftChk and RightChk { // on right
				if Node == node_head {
					node_head = Right
				} else {
					if Node == Parent.node_left {
						Parent.set_left(Right)
					} else if Node == Parent.node_right {
						Parent.set_right(Right)
					}
				}
				Node.destroy()
				delete Node
			} else { // two children
				var Leftest = Node.find_leftest()
				var Temp = Leftest.get()
				Node.set(Temp)
				underlying_erase_node(Leftest)
			}

			gc_collect()
		}
	}

	node_cashs_count = 0
	node_rightest = undefined
	key_inquire_comparator = compare_less
	key_comparator = function(a, b) {
		var A = extract_key(a), B = extract_key(b)
		if A == B
			return b < a
		else
			return key_inquire_comparator(A, B)
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

