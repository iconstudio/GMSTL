function Heap_Tree(): Binary_Tree() constructor {
	///@function insert(item)
	static insert = function(Value) {
		if 0 == size() {
			push_back(Value)
			return 0
		}

		var Index = size(), PriorValue, Parent
		set(Index, Value)
		while 0 < Index {
			PriorValue = at(Index)
			Parent = find_parent(Index)
			if key_comparator(PriorValue, at(Parent)) {
				set(Index, at(Parent))
				set(Parent, PriorValue)
				Index = Parent
			} else {
				break
			}
		}
	}

	///@function erase_head()
	static erase_head = function() { // overwrite
		var Size = size()
		var Index = 0, Left = left(Index), Right = right(Index), Minimum, MinPosition
		
		var HeadValue = at(0)
		set(0, back())
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
			set(Index, at(MinPosition))
			set(MinPosition, Temp)

			Index = MinPosition
			Left = left(Index)
			Right = right(Index)
		}
	}

	///@function set_key_comp(compare_function)
	static set_key_comp = function(Func) { key_comparator = method(other, Func) }

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

