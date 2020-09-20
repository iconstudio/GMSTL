global.__TLNULL = new (function() constructor {NULL = true})()
#macro NODE_NULL global.__TLNULL
function Binary_Tree(): List() constructor {
	///@function left(index)
	///@description smaller
	static left = function(Index) { return Index * 2 + 1 }

	///@function right(index)
	///@description larger
	static right = function(Index) { return Index * 2 + 2 }

	///@function at_left(index)
	static at_left = function(Index) { return at(left(Index)) }

	///@function at_right(index)
	static at_right = function(Index) { return at(right(Index)) }

	///@function bucket(value)
	static bucket = function(Value) {
		if 0 == size()
			return undefined

		return ds_list_find_index(raw, Value)
	}

	///@function contains(value)
	static contains = function(Value) { return !is_undefined(bucket(Value)) }

	///@function valid(index)
	static valid = function(Index) { return bool(is_real(Index) and 0 <= Index and Index < size() and at(Index) != NODE_NULL) }

	///@function head()
	static head = function() { return front() }

	///@function set(index, value)
	static set = function(Index, Value) {
		var Size = size()
		if Index < Size {
			ds_list_set(raw, Index, Value)
		} else {
			var Times = Index - Size
			repeat Times
				push_back(NODE_NULL)
			push_back(Value)
		}
		return self
	}

	///@function insert(item)
	static insert = function(Value) {
		push_back(Value)
		return size()
	}

	///@function push(value)
	static push = function(Value) { insert(Value) }

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

	///@function set_deallocator(destroy_function)
	static set_deallocator = function(Func) { deallocator = method(other, Func) }

	///@function deallocate(index)
	static deallocate = function(Index) {
		var Elem = at(Index)
		if !is_undefined(deallocator)
			deallocator(Elem)
		set(Index, NODE_NULL)
	}

	type = Binary_Tree
	deallocator = undefined

	// ** Assigning **
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

