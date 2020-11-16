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
	static _Under_insert = function(NewKey) {
		var MyKey = get_key()
		if NewKey == MyKey and !is_multiple {
			//throw "An error occured when inserting a duplicate key!"
			return undefined
		} else {
			var Compare = storage.key_inquire_comparator
			var ValueNode

			if Compare(NewKey, MyKey) { // less
				if is_undefined(node_left) {
					ValueNode = new type(storage).set_key(NewKey)
					set_left(ValueNode)

					if !is_undefined(node_previous)
						node_previous.set_next(ValueNode)
					ValueNode.set_next(self)
				} else {
					return node_left._Under_insert(NewKey)
				}
			} else { // greater
				if is_undefined(node_right) {
					ValueNode = new type(storage).set_key(NewKey)
					set_right(ValueNode)

					var Checker = self, Promote = parent
					while !is_undefined(Promote) {
						if Checker == Promote.node_left {
							ValueNode.set_next(Promote)
							break
						} else {
							Checker = Promote
							Promote = Promote.parent
						}
					}
					set_next(ValueNode)
				} else {
					return node_right._Under_insert(NewKey)
				}
			}
			return ValueNode
		}
	}

	is_multiple = Storage.is_multiple
#endregion

#region public
	///@function insert(value)
	static insert = _Under_insert

	///@function destroy()
	/*
			Splice the case of erasing a data from the Tree.
			
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
			set_data(Leftest.get_data())
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
	static last = function() { return Iterator(node_rightest).go_next().pure() }

	///@function insert(value)
	static insert = function(Key) { Iterator(_Under_try_insert(node_pointer_head, Key)) }

	///@function insert_at(index, value)
	static insert_at = function(Hint, Key) { return Iterator(_Under_try_insert(first_of(Hint), Key)) }

	///@function erase_at(index)
	static erase_at = function(Key) { _Under_try_erase(first_of(Key)) }

	///@function erase_iter(iterator)
	static erase_iter = function(It) { if It.storage == self _Under_try_erase(It.index) }

	///@function first_of(value)
	static first_of = function(Key) {
		if 0 == inner_size
			return undefined

		var Node = node_head, CompKey
		while !is_undefined(Node) {
			CompKey = Node.get_key()
			if Key == CompKey {
				return Node
			} else {
				if key_inquire_comparator(Key, CompKey)
					Node = Node.node_left
				else
					Node = Node.node_right
			}
		}
		return undefined
	}

	///@function last_of_first(lower_bound)
	static last_of_first = function(LowerBound) {
		var Node = LowerBound, Key = LowerBound.get_key(), CompKey
		while !is_undefined(Node) {
			CompKey = Node.get_key()
			if Key != CompKey {
				return Node
			} else {
				Node = Node.node_next
			}
		}
		return undefined
	}

	///@function last_of(data)
	static last_of = function(Key) {
		if 0 == inner_size
			return undefined

		var LowerBound = first_of(Key)
		return last_of_first(LowerBound)
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
	static _Under_iterator_set = function(Node, Value) { return Node.set_data(Value); return self }

	///@function (index)
	static _Under_iterator_get = function(Node) { return Node.get_data() }

	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = insert_at

	///@function (index)
	static _Under_iterator_next = function(Node) { return Node.node_next }

	///@function (index)
	static _Under_iterator_prev = function(Node) { return Node.node_previous }

	///@function 
	static _Under_try_insert = function(Location, Key) {
		if is_undefined(Location) {
			return undefined
		} else if Location == node_pointer_head and is_undefined(node_head) {
			inner_size = 1
			node_head = new value_type(self).set(Key)
			node_leftest = node_head
			return node_head
		} else {
			if Location == node_pointer_head
				return _Under_insert_at_node(node_head, Key)
			 else
				return _Under_insert_at_node(Location, Key)
		}
	}

	///@function 
	static _Under_insert_at_node = function(Node, Key) {
		var Result = Node.insert(Key)
		if !is_undefined(Result) {
			inner_size++
			if is_undefined(Result.node_left)
				node_leftest = Result
			else if is_undefined(Result.node_right)
				node_rightest = Result
		}
		return Result
	}

	///@function 
	static _Under_try_erase = function(Node) {
		if is_undefined(Node)
			exit

		var Result = _Under_erase_node(Node)
		inner_size--
		delete Node
		return Result
	}

	///@function 
	static _Under_erase_node = function(Node) {
		var Successor = Node.destroy()
		if Node == node_head {
			if inner_size == 1 {
				node_head = undefined
				return undefined
			} else {
				node_head = Successor
			}
		} else if Node == node_leftest {
			node_leftest = node_head.find_leftest()
		} else if Node == node_rightest {
			node_rightest = node_head.find_rightest()
		}
		return Successor
	}

	is_multiple = false
	node_rightest = undefined
	static node_pointer_head = {}
	static key_inquire_comparator = compare_less
	static key_comparator = function(a, b) {
		var A = a.data, B = b.data
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
