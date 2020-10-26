enum BSTree_type {
	none = -1,
	this = 0,
	left,
	right
}

///@function BSTree_node(storage)
function BSTree_node(Storage): Tree_node() constructor {
#region private
///@function 
	static _Under_insert = function(Value) {
		if !is_multiple and Value == value {
			return [self, BSTree_type.none]
		} else {
			var Compare = storage.key_inquire_comparator
			if Compare(Value, value) {
				if is_undefined(node_left) {
					var ValueNode = new type(storage).set(Value)
					set_left(ValueNode)

					if !is_undefined(node_previous)
						node_previous.set_next(ValueNode)
					ValueNode.set_next(self)

					return [ValueNode, BSTree_type.left]
				} else {
					return node_left.insert(Value)
				}
			} else {
				if is_undefined(node_right) {
					var ValueNode = new type(storage).set(Value)
					set_right(ValueNode)

					var Promote = parent, ProValue, Upheal
					while !is_undefined(Promote) {
						ProValue = Promote.value
						if Compare(Value, ProValue) {
							ValueNode.set_next(Promote)
							break
						} else {
							Upheal = Promote.parent
							if is_undefined(Upheal)
								break

							Promote = Upheal
						}
					}
					set_next(ValueNode)

					return [ValueNode, BSTree_type.right]
				} else {
					return node_right.insert(Value)
				}
			}
		}
	}

	is_multiple = Storage.is_multiple
#endregion

#region public
	///@function set(value)
	static set = function(Value) { value = Value; return self }

	///@function get()
	static get = function() { return value }
	
	///@function insert(value)
	static insert = _Under_insert

	///@function destroy()
	/*
			Splice the case of erasing a key from the Tree.
			
			case 1: a leaf node
				Just remove it.
			
			case 2: the node has one child
				Remove it and pull up its children.
			
			case 3: the node has two children
				Replace it with smallest one and remove the original smallest one.
	*/
	static destroy = function() {
		var Left = node_left, Right = node_right
		var LeftChk = !is_undefined(Left), RightChk = !is_undefined(Right)
		var Is_head = is_undefined(parent)
		var Result = undefined

		if LeftChk and RightChk { // two children
			var Leftest = node_next
			var Temp = string(self)
			set(Leftest.value)
			Leftest.destroy()
			delete Leftest
			Result = self
		} else {
			if !is_undefined(node_previous) {
				if !is_undefined(node_next) {
					node_previous.set_next(node_next)
				} else {
					node_previous.set_next(undefined)
				}
			}

			if !LeftChk and !RightChk {
				// has no child
			} else {
				if LeftChk and !RightChk {
					// on left, this is the last element in a sequence.
					Result = Left
				} else if !LeftChk and RightChk {
					// on right
					Result = Right
				}

				if Is_head {
					Result.parent = undefined
				} else {
					if self == parent.node_left
						parent.set_left(Result)
					else if self == parent.node_right
						parent.set_right(Result)
				}
				
			}
			_Under_destroy()
		}

		gc_collect()
		return Result
	}

	storage = Storage
	static type = BSTree_node
#endregion
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
	static insert = function(Value) { Iterator(_Under_insert_at_node(node_head, Value)) }

	///@function insert_at(index, value)
	static insert_at = function(Hint, Key) {
		var Loc = first_of(Hint)
		if !is_undefined(Loc)
			return Iterator(_Under_insert_at_node(Loc, Key))
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
		var Where = first_of(Key)
		if !is_undefined(Where)
			_Under_erase_node(Where)
	}

	///@function erase_iter(iterator)
	static erase_iter = function(It) {
		if It.storage == self
			_Under_erase_node(It.index)
	}

	///@function first_of(value)
	static first_of = function(Key) {
		if 0 == inner_size
			return undefined

		var Node = node_head, CompVal
		while !is_undefined(Node) {
			CompVal = _Under_iterator_get(Node)
			if Key == CompVal {
				return Node
			} else {
				if key_inquire_comparator(Key, CompVal)
					Node = Node.node_left
				else
					Node = Node.node_right
			}
		}
		return undefined
	}

	///@function location(value)
	static location = function(Key) { return Iterator(first_of(Key)) }

	///@function contains(value)
	static contains = function(Key) { return !is_undefined(first_of(Key)) }

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_inquire_comparator = method(other, Func) }

	static type = BinarySearch_tree
	static value_type = BSTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = function(Node, Value) { return Node.value = Value; return self }

	///@function (index)
	static _Under_iterator_get = function(Node) { return Node.value }

	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = insert_at

	///@function (index)
	static _Under_iterator_next = function(Node) { return Node.node_next }

	///@function (index)
	static _Under_iterator_prev = function(Node) { return Node.node_previous }

	///@function 
	static _Under_insert_at_node = function(Node, Value) {
		if 0 == inner_size {
			inner_size++
			node_head = new value_type(self).set(Value)
			return node_head
		}

		if is_undefined(Node)
			return undefined

		var Result = Node.insert(Value)
		var Where = Result[0], Branch = Result[1]

		if Branch != BSTree_type.none {
			inner_size++
			switch Branch {
			    case BSTree_type.left:
			        if is_undefined(node_leftest) or Where.parent == node_leftest
						node_leftest = Where
				break

			    case BSTree_type.right:
			        if is_undefined(node_rightest) or Where.parent == node_rightest
						node_rightest = Where
				break

			    default:
			        throw "Wrong position of node: " + string(Result)
				break
			}
		}
		return Where
	}

	///@function 
	static _Under_erase_node = function(Node) {
		var Successor = Node.destroy()
		if inner_size == 1 {
			node_head = undefined
		} else if Node == node_head {
			node_head = Successor
		} else if Node == node_leftest {
			if is_undefined(Node.node_left)
				node_leftest = node_head.find_leftest()
			else
				node_leftest = Node.node_left
		} else if Node == node_rightest {
			if is_undefined(Node.node_right)
				node_rightest = node_head.find_rightest()
			else
				node_rightest = Node.node_right
		}
		inner_size--
		delete Node
	}

	is_multiple = false
	node_rightest = undefined
	key_inquire_comparator = compare_less
	key_comparator = function(a, b) {
		var A = _Under_iterator_get(a), B = _Under_iterator_get(b)
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
