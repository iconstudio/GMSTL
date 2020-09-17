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

	///@function contains(value)
  static contains = function(Value) { return !is_undefined(bucket(Value)) }

	///@function valid(index)
  static valid = function(Index) { return bool(Index < size() and at(Index) != NODE_NULL) }

	///@function head()
	static head = function() { return front() }

	///@function set(index, value)
  static set = function(Index, Value) {
		var Size = size()
		if Index < Size {
			ds_list_set(raw, Index, Value)
		} else {
			var Times = Index - Size - 1
			repeat Times
				push_back(NODE_NULL)
			push_back(Value)
		}
		return self
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

	///@function push(value)
  static push = function(Value) { insert(Value) }

	///@function erase_at(index)
	static erase_at = function(Index) {
		
	}

	///@function set_key_comp(compare_function)
	function set_key_comp(Func) { key_comparator = method(other, Func) }

	///@function set_check_comp(compare_function)
	function set_check_comp(Func) { check_comparator = method(other, Func) }

	type = Binary_Tree
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

