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

function BSTree_location() {
	node = undefined
	dir = BSTree_child.none // 0: self, 1: left, 2: right
}

function BinarySearch_tree(): Binary_tree() constructor {
#region public
	///@function 
	static underlying_insert = function(Hint, Value) {
		if is_undefined(Hint) {
			
		} else {
			
		}

		var Position = Hint.node, Node_direction = Hint.dir
		switch Node_direction {
			case BSTree_child.none:
			
				break

			case BSTree_child.left:
			
				break

			case BSTree_child.right:
			
				break
		}
	}

	///@function insert_at(hint, value)
	static insert_at = function(Hint, Value) {
		if !valid(Hint) {
			//Hint.value = Value
			return Hint
		} else {
			var CompVal = at(Hint)
			if key_comparator(Value, CompVal)
				return insert_at(Hint.node_left, Value, )
			else
				return insert_at(right(Hint),Value, )
		}
	}

	///@function 
	static extract = function(Node) { return Node.value }

	///@function insert(value)
	static insert = function(Value) {
		var NewNode = make_node(Value)
		if 0 == size() {
			node_head = NewNode
			return node_head
		}

		if key_comparator(Value, extract(node_head))
			return insert_at(Value, left(0))
		else
			return insert_at(Value, right(0))
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

	///@function find_of(value)
	static find_of = function(Value) {
		if 0 == size()
			return undefined

		var CompVal, Index = 0, Size = size()
		while Index < Size {
			CompVal = at(Index)
			if check_comparator(Value, CompVal) {
				return Index
			} else {
				if key_comparator(Value, CompVal)
					Index = left(Index)
				else
					Index = right(Index)
			}
		}
		return undefined
	}

	///@function count_of(value)
	static count_of = function(Value) {
	}

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_compare(compare_function)
	static set_check_compare = function(Func) { check_comparator = method(other, Func) }

	static type = BinarySearch_tree
	static value_type = BSTree_node
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function 
	static move_children = function(Index, Target) {
		var Left = left(Index), Right = right(Index)
		var LeftChk = valid(Left), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, undefined)

		if LeftChk {
			move_children(Left, left(Target))
		}
		if RightChk {
			move_children(Right, right(Target))
		}
		set(Target, Value)
	}

	///@function 
	static move_children_of_left = function(Index, Target) {
		var Left = left(Index), LeftChk = valid(Left)
		var Value = at(Index)
		set(Index, undefined)

		if LeftChk
			move_children(Left, left(Target))

		set(Target, Value)
	}

	///@function 
	static move_children_of_right = function(Index, Target) {
		var Right = right(Index), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, undefined)

		if RightChk
			move_children(Right, right(Target))

		set(Target, Value)
	}

	key_comparator = compare_less
	check_comparator = compare_equal
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

