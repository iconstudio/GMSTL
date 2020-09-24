function BinarySearch_Tree(): Binary_Tree() constructor {
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
		if 0 == size()
			return undefined

		var CompVal, Index = 0, Size = size(), Result = 0
		while Index < Size {
			CompVal = at(Index)
			if check_comparator(Value, CompVal) {
				Result++
			} else {
				if key_comparator(Value, CompVal)
					Index = left(Index)
				else
					Index = right(Index)
			}
		}
		return Result
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

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_comparator = method(other, Func) }

	///@function set_check_compare(compare_function)
	static set_check_compare = function(Func) { check_comparator = method(other, Func) }

	type = BinarySearch_Tree
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

