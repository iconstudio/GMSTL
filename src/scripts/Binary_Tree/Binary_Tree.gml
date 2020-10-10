///@function 
function Tree_node_trait() constructor {
	value = undefined
	parent = undefined
	node_left = undefined
	node_right = undefined
	node_next = undefined
	node_previous = undefined

	///@function set_parent(node)
	static set_parent = function(Node) { parent = Node }

	///@function set_left(node)
	static set_left = function(Node) {
		node_left = Node
		if !is_undefined(Node) {
			Node.parent = self
			return true
		}
		return false
	}

	///@function set_right(node)
	static set_right = function(Node) {
		node_right = Node
		if !is_undefined(Node) {
			Node.parent = self
			return true
		}
		return false
	}

	///@function find_leftest()
	static find_leftest = function() {
		var Result = self, Next = node_left
		while !is_undefined(Next) {
			Result = Next
			Next = Next.node_left
		}
		return Result
	}

	///@function find_rightest()
	static find_rightest = function() {
		var Result = self, Next = node_right
		while !is_undefined(Next) {
			Result = Next
			Next = Next.node_right
		}
		return Result
	}

	///@function 
	static _Under_destroy = function() {
		if !is_undefined(parent) {
			if self == parent.node_left {
				parent.node_left = undefined
			} else if self == parent.node_right {
				parent.node_right = undefined
			}
		}

		if !is_undefined(node_left) {
			node_left.parent = undefined
		}

		if !is_undefined(node_right) {
			node_right.parent = undefined
		}
	}

	static toString = function() { return string(value) }
}

///@function 
function Tree_node(): Tree_node_trait() constructor {
	///@function set_parent(node)
	static set_parent = function(Node) { _Under_set_parent(Node) }

	///@function set_left(node)
	static set_left = function(Node) { return _Under_set_left(Node) }

	///@function set_right(node)
	static set_right = function(Node) { return _Under_set_right(Node) }

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

	///@function destroy()
	static destroy = function() {
		if !is_undefined(node_previous) {
			if !is_undefined(node_next) {
				throw "Deleting a node in between of two nodes is not allowed in Full binary tree!"
			}
			node_previous.set_next(undefined)
		}
		_Under_destroy()

		return node_previous
	}
}

///@function 
function Binary_tree_trait(): Container() constructor {
	///@function 
	static _Under_cash_allocate = function() {
		cash = 0
		cash = array_create(cash_size, undefined)
	}

	///@function 
	static _Under_make_node = function() { return new value_type() }

	node_head = undefined
	node_tail = undefined
	cash_size = 64
	cash = array_create(cash_size, undefined)
	static value_type = Tree_node
}

function Binary_tree(): Binary_tree_trait() constructor {
#region public
	///@function size()
	static size = function() { return inner_size }

	///@function empty()
	static empty = function() { return bool(inner_size == 0) }

	///@function valid(Index)
	static valid = function(Index) { return bool(0 <= Index and Index < inner_size) }

	///@function clear()
	static clear = function() {
		if !is_undefined(node_head) {
			_Under_clear(node_head)
		}
		node_head = undefined
		inner_size = 0
		gc_collect()
	}

	///@function front()
	static front = function() { return node_head }

	///@function back()
	static back = function() { return node_tail }

	///@function first()
	static first = function() { return Iterator(node_head) }

	///@function last()
	static last = function() { return undefined }

	///@function make_node(value)
	static make_node = function(Value) {
		var Node = _Under_make_node()
		Node.value = Value
		return Node
	}

	///@function insert(value)
	static insert = function(Value) {
		var Index = inner_size, NewNode = make_node(Value)
		if Index < cash_size
			cash[Index] = Value // memoization

		if 0 == Index { // hardcoded
			node_head = NewNode
			node_inserter_parent = NewNode
			node_leftest = NewNode
		} else if 1 == Index {
			node_head.set_left(NewNode)
			node_head.set_next(NewNode)
			node_leftest = NewNode
		} else if 2 == Index {
			node_head.set_right(NewNode)
			node_tail.set_next(NewNode) // node_head.node_left
			node_inserter_parent = node_tail
		} else {
			var Height = log2(Index + 1) // the size is not increased yet

			if is_undefined(node_inserter_parent.node_left) {
				node_inserter_parent.set_left(NewNode)
				node_tail.set_next(NewNode) // right, or most rightest node
				if frac(Height) == 0 {
					node_leftest = NewNode
				}
			} else if is_undefined(node_inserter_parent.node_right) {
				node_inserter_parent.set_right(NewNode)
				node_tail.set_next(NewNode) // left node

				var CurrHeight = floor(Height)
				var NextHeight = floor(log2(Index + 2))
				if CurrHeight != NextHeight
					node_inserter_parent = node_leftest
				else
					node_inserter_parent = node_inserter_parent.node_next
			} else {
				throw "Cannot found any valid child nodes to insert in!"
			}
		}

		node_tail = NewNode
		return inner_size++
	}

	///@function push_back(value)
	static push_back = function(Value) { insert(Value) }

	///@function pop_back()
	static pop_back = function() {
		if 0 == inner_size {
			return undefined
		} else {
			var Result
			if 1 == inner_size {
				Result = cash[0]
				delete node_head
				node_head = undefined
				node_tail = undefined
				cash[0] = undefined
				inner_size--
			} else if 1 < inner_size {
				if inner_size <= cash_size {
					Result = cash[inner_size - 1]
					cash[inner_size - 1] = undefined
				} else {
					Result = node_tail.value
				}

				var Butt = node_tail.parent
				if node_tail == node_leftest {
					node_leftest = Butt
					node_inserter_parent = Butt
				} else if node_tail == Butt.node_left { // back
					node_inserter_parent = node_inserter_parent.node_previous
				}

				var Prev = node_tail.node_previous
				Prev.set_next(undefined)
				node_tail.destroy()
				delete node_tail
				node_tail = Prev
				inner_size--
			}
			return Result
		}
	}

	///@function location(value)
	static location = function(Value) { return find(first(), last(), Value) }

	///@function contains(value)
	static contains = function(Value) { return !is_undefined(location(Value)) }

	static type = Binary_tree
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = function(Index, Value) { return Index.value = Value; return self }

	///@function (index)
	static _Under_iterator_get = function(Index) { return Index.value }

	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = function(Index) { return Index.node_next }

	///@function (index)
	static _Under_iterator_prev = function(Index) { return Index.node_previous }

	///@function 
	static _Under_at = function(Index) {
		if valid(Index) {
			if Index < cash_size {
				return cash[Index]
			} else {
				var Target, It = node_tail, Max = Index - cash_size + 1
				repeat Max {
					Target = It.node_next
					if is_undefined(Target)
						break
					It = Target
				}
				return It.value
			}
		} else {
			return undefined
		}
	}

	///@function 
	static _Under_clear = function(Node) {
		var Left = Node.node_left, Right = Node.node_right
		if !is_undefined(Left)
			_Under_clear(Left)

		if !is_undefined(Right)
			_Under_clear(Right)

		delete Node
	}

	inner_size = 0
	node_inserter_parent = undefined
	node_leftest = undefined
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

