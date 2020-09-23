global.__TLNULL = { NULL: true }
#macro NODE_NULL global.__TLNULL

///@function Tree_Node(value)
function Tree_Node(Value) constructor {
	value = Value
	parent = undefined
	node_left = undefined
	node_right = undefined

	///@function set_left(node)
	static set_left = function(Node) {
		node_left = Node
		if !is_undefined(Node) {
			Node.parent = self
		}
	}

	///@function set_right(node)
	static set_right = function(Node) {
		node_right = Node
		if !is_undefined(Node) {
			Node.parent = self
		}
	}
}

function Binary_Tree(): Container() constructor {
	///@function contains(value)
	static contains = function(Value) { return !is_undefined(find_of(Value)) }

	///@function insert(item)
	static insert = function(Value) {
		push_back(Value)
		return size()
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

