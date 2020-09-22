/*
	Constructors:
		Heap_Tree()
		Heap_Tree(Arg)
		Heap_Tree(Arg0, Arg1, ...)
		Heap_Tree(Builtin-Array)
		Heap_Tree(Builtin-List)
		Heap_Tree(Container)
		Heap_Tree(Iterator-Begin, Iterator-End)

	Initialize:
		new Heap_Tree()
*/
function Heap_Tree(): List() constructor {
	///@function left(index)
	///@description smaller
	static left = function(Index) { return Index * 2 + 1 }

	///@function right(index)
	///@description larger
	static right = function(Index) { return Index * 2 + 2 }

	///@function index_of(value)
	static index_of = function(Value) { return ds_list_find_index(raw, Value) }

	///@function find_parent(index)
	static find_parent = function(Index) { return floor((Index - 1) * 0.5) }

	///@function contains(value)
	static contains = function(Value) { return index_of(Value) != -1 }

	///@function valid(index)
	static valid = function(Index) { return bool(is_real(Index) and 0 <= Index and Index < size() and at(Index) != node_null) }

	///@function top()
	static top = function() { return front() }

	///@function 
	static __set = function(Index, Value) {
		var Size = size()
		if Index < Size {
			ds_list_set(raw, Index, Value)
		} else {
			var Times = Index - Size
			repeat Times
				push_back(node_null)
			push_back(Value)
		}
		return self
	}

	///@function insert(value)
	static insert = function(Value) {
		if 0 == size() {
			push_back(Value)
			return 0
		}

		var Index = size(), PriorValue, Parent
		__set(Index, Value)
		while 0 < Index {
			PriorValue = at(Index)
			Parent = find_parent(Index)
			if key_comparator(PriorValue, at(Parent)) {
				__set(Index, at(Parent))
				__set(Parent, PriorValue)
				Index = Parent
			} else {
				break
			}
		}
		return Parent
	}

	///@function pop_front()
	static pop_front = function() { // overwrite
		var Size = size()
		var Index = 0, Left = left(Index), Right = right(Index), Minimum, MinPosition
		
		var HeadValue = at(0)
		__set(0, back())
		pop_back()

		while Left < Size {
			Minimum = at(Left)
			MinPosition = Left

			if Right < Size and key_comparator(at(Right), Minimum) {
				Minimum = at(Right)
				MinPosition = Right
			}

			if at(Index) < Minimum
				break

			var Temp = at(Index)
			__set(Index, at(MinPosition))
			__set(MinPosition, Temp)

			Index = MinPosition
			Left = left(Index)
			Right = right(Index)
		}
		return HeadValue
	}

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_comparator = method(other, Func) }

	node_null = { NULL: true }
	type = Heap_Tree
	key_comparator = compare_less

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

