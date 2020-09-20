function Heap_Tree(): Binary_Tree() constructor {
	///@function find_parent(index)
	static find_parent = function(Index) { return floor((Index - 1) * 0.5) }

	///@function insert_recursive(value, hint)
	static insert_recursive = function(Value, Hint) {
		var CompVal, Parent = find_parent(Hint)
		while 0 < Hint {
			CompVal = at(Parent)
			if key_comparator(Value, CompVal) {
				set(Hint, CompVal)
				set(Parent, Value)
			} else {
				set(Hint, Value)
				return Hint
			}
			Hint = Parent
			Parent = find_parent(Hint)
		}
	}

	///@function insert(item)
	static insert = function(Value) {
		if 0 == size() {
			push_back(Value)
			return 0
		}

		return insert_recursive(Value, size())
	}

	///@function set_key_comp(compare_function)
	static set_key_comp = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_comp(compare_function)
	static set_check_comp = function(Func) { check_comparator = method(other, Func) }

	type = Heap_Tree
	key_comparator = compare_less
	check_comparator = compare_equal

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

