///@function 
function Tree_Node_Tratit() {
	value = undefined
	parent = undefined
	node_left = undefined
	node_right = undefined
	node_next = undefined
	node_previous = undefined

	///@function 
	static underlying_set_parent = function(Node) { parent = Node }

	///@function 
	static underlying_set_left = function(Node) {
		node_left = Node
		if !is_undefined(Node) {
			Node.parent = self
			return true
		}
		return false
	}

	///@function 
	static underlying_set_right = function(Node) {
		node_right = Node
		if !is_undefined(Node) {
			Node.parent = self
			return true
		}
		return false
	}
}

///@function 
function Tree_Node() constructor {
	Tree_Node_Tratit()

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

	///@function find_leftest()
	static find_leftest = function() {
		var Result = self, Next = left
		while !is_undefined(Next) {
			Result = Next
			Next = Next.left
		}
		return Result
	}

	///@function find_rightest()
	static find_rightest = function() {
		var Result = self, Next = right
		while !is_undefined(Next) {
			Result = Next
			Next = Next.right
		}
		return Result
	}

	///@function 
	static underlying_destroy = function() {
		if !is_undefined(node_previous) {
			Node.node_previous = self
			return true
		}
		return false
	}
}

///@function 
function Binary_Tree_Trait() {
	node_head = undefined
	node_tail = undefined
	cash = array_create(64, undefined)

	///@function 
	static underlying_make_node = function() { return new Tree_Node() }

	///@function 
	static underlying_sequence_by_index_recursive = function(Index) {
		if Index < 64 and cash[Index] != undefined
			return cash[Index]

		var Result = undefined
		if 0 == Index {
			Result = node_head
		} else if 1 == Index {
			Result = node_head.left
		} else if 2 == Index {
			Result = node_head.right
		} else {
			var ParentIndex = floor((Index - 1) * 0.5)
			if Index < 0
				return undefined

			var Parent = underlying_sequence_by_index_recursive(ParentIndex)
			if is_undefined(Parent)
				return undefined

			var ParentLeftIndex = ParentIndex * 2 + 1
			var ResultIndex = Index - ParentLeftIndex
			switch ResultIndex {
			    case 0:
					Result = Parent.left
			        break
			    case 1:
					Result = Parent.right
			        break
			}
		}
		if Index < 64 and cash[Index] == undefined // memoization
			cash[Index] = Result
		return Result
	}

	///@function 
	static underlying_sequence_by_index = function(Index) { // from node_head to left to right
		var Result = underlying_sequence_by_index_recursive(Index)
		//cash = 0
		//cash = array_create(64, undefined)
		gc_collect()
		return Result
	}

	///@function 
	static underlying_sequence_by_sort = function(Index) { // from leftest
		var First = node_head.find_leftest()
		
		var Node, Leftest = Node.find_leftest()
		if Leftest == Node {
			
		}
	}

	///@function 
	static underlying_sequence_by_depth = function(Index) { // left first
	}
}

function Binary_Tree(): Container() constructor {
	Binary_Tree_Trait()

#region public
	///@function size()
	static size = function() { return inner_size }

	///@function empty()
	static empty = function() { return bool(inner_size == 0) }

	///@function valid(node)
	static valid = function(Node) { return !is_undefined(Node) }

	///@function clear()
	static clear = function() { node_head = undefined; inner_size = 0; gc_collect() }

	///@function front()
	static front = function() { return node_head }

	///@function back()
	static back = function() { return node_tail }

	///@function first()
	static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
	static last = function() { return size() }

	///@function make_node(value)
	static make_node = function(Value) {
		var Node = underlying_make_node()
		Node.value = Value
		return Node
	}

	///@function insert_recursive(node, start_node)
	static insert_recursive = function(Node, StartNode) {
		
	}

	///@function insert(item)
	static insert = function(Value) {
		var NewNode = make_node(Value)
		node_tail = NewNode
		var Size = inner_size
		if Size < 64 and cash[Size] == undefined // memoization
			cash[Size] = Value

		if 0 == Size {
			node_head = NewNode
		} else if 1 == Size {
			node_head.set_left(NewNode)
			node_head.set_next(NewNode)
		} else if 2 == Size {
			node_head.set_right(NewNode)
			node_head.left.set_next(NewNode)
		} else {
			var a = underlying_sequence_by_index(Index)
			
			insert_recursive(NewNode, node_head)
		}

		return inner_size++
	}

	///@function move_children(index, destination)
	static move_children = function(Index, Target) {
		var Left = left(Index), Right = right(Index)
		var LeftChk = valid(Left), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, NODE_NULL)

		if LeftChk {
			move_children(Left, left(Target))
		}
		if RightChk {
			move_children(Right, right(Target))
		}
		set(Target, Value)
	}

	///@function move_children_of_left(index, destination)
	static move_children_of_left = function(Index, Target) {
		var Left = left(Index), LeftChk = valid(Left)
		var Value = at(Index)
		set(Index, NODE_NULL)

		if LeftChk
			move_children(Left, left(Target))

		set(Target, Value)
	}

	///@function move_children_of_right(index, destination)
	static move_children_of_right = function(Index, Target) {
		var Right = right(Index), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, NODE_NULL)

		if RightChk
			move_children(Right, right(Target))

		set(Target, Value)
	}

	///@function erase_at(index)
	/*
			Splice the case of erasing a key from the Tree.
			
			case 1: a leaf node
				Just remove it.
			
			case 2: the node has one child
				Remove it and pull up its children.
			
			case 3: the node has two children
				Replace it with smallest one and remove the original smallest one.
	*/
	static erase_at = function(Index) {
		if valid(Index) {
			var Left = left(Index), Right = right(Index)
			var LeftChk = valid(Left), RightChk = valid(Right)
			deallocate(Index)

			if !LeftChk and !RightChk { // has no child
			} else if LeftChk and !RightChk { // on left
				move_children(Left, Index)
			} else if !LeftChk and RightChk { // on right
				move_children(Right, Index)
			} else { // two children
				var Result = Left, LeftofLeft = left(Left)
				while true {
					if !valid(LeftofLeft) {
						break
					}
					Result = LeftofLeft // the smallest
					LeftofLeft = left(Result) 
				}
				set(Index, at(Result))
				erase_at(Result)
			}

			gc_collect()
		}
	}

	///@function location(value)
	static location = function(Value) {
		var Result = ds_list_find_index(raw, Value)
		if Result == -1
			return undefined
		else
			return Result
	}

	///@function contains(value)
	static contains = function(Value) {
		return !is_undefined(find_of(Value))
	}

	///@function set_deallocator(destroy_function)
	static set_deallocator = function(Func) { deallocator = method(other, Func) }

	///@function deallocate(index)
	static deallocate = function(Index) {
		var Elem = at(Index)
		if !is_undefined(deallocator)
			deallocator(Elem)
		set(Index, undefined)
	}

	type = Binary_Tree
#endregion

#region private
	inner_size = 0
	deallocator = undefined
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

