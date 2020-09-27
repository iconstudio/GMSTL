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

function BinarySearch_tree(): Binary_tree() constructor {
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

	///@function insert_recursive(value, hint)
	static insert_recursive = function(Value, Hint) {
		if !valid(Hint) {
			set(Hint, Value)
			return Hint
		} else {
			var CompVal = at(Hint)
			if key_comparator(Value, CompVal)
				return insert_recursive(Value, left(Hint))
			else
				return insert_recursive(Value, right(Hint))
		}
	}

	///@function insert(item)
	static insert = function(Value) {
		if 0 == size() {
			push_back(Value)
			return 0
		}

		if key_comparator(Value, head())
			return insert_recursive(Value, left(0))
		else
			return insert_recursive(Value, right(0))
	}

	///@function move_children(index, destination)
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

	///@function move_children_of_left(index, destination)
	static move_children_of_left = function(Index, Target) {
		var Left = left(Index), LeftChk = valid(Left)
		var Value = at(Index)
		set(Index, undefined)

		if LeftChk
			move_children(Left, left(Target))

		set(Target, Value)
	}

	///@function move_children_of_right(index, destination)
	static move_children_of_right = function(Index, Target) {
		var Right = right(Index), RightChk = valid(Right)
		var Value = at(Index)
		set(Index, undefined)

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

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_compare(compare_function)
	static set_check_compare = function(Func) { check_comparator = method(other, Func) }

	type = BinarySearch_tree
	value_type = BSTree_node
	key_comparator = compare_less
	check_comparator = compare_equal

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

