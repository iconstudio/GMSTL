global.__TLNULL = new (function() constructor {NULL = true})()
#macro NODE_NULL global.__TLNULL
function Binary_Tree(): List() constructor {
	///@function make_left(index)
	///@description smaller
	static make_left = function(Index) { return Index * 2 + 1 }

	///@function make_right(index)
	///@description larger
	static make_right = function(Index) { return Index * 2 + 2 }

	///@function at_left(index)
	static at_left = function(Index) { return at(make_left(Index)) }

	///@function at_right(index)
	static at_right = function(Index) { return at(make_right(Index)) }

	///@function head()
	static head = function() { return front() }

	///@function left(index)
	static left = function(Index) { return (new iterator_type(self, make_left(Index))).pure() }

	///@function right(index)
	static right = function(Index) { return (new iterator_type(self, make_right(Index))).pure() }

//todo: Map처럼 at과 seek을 분리.

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
		var Size = size(), CompVal = at(Hint)
		if Size <= Hint or CompVal == NODE_NULL {
			set(Hint, Value)
			return Hint
		}

		if comparator(Value, CompVal)
			return insert_recursive(Value, make_left(Hint))
		else
			return insert_recursive(Value, make_right(Hint))
	}

	///@function insert(item)
  static insert = function(Value) {
		if size() == 0 {
			push_back(Value)
			return 0
		}

		if comparator(Value, head())
			return insert_recursive(Value, make_left(0))
		else
			return insert_recursive(Value, make_right(0))
	}

	///@function push(value)
  static push = function(Value) { insert(Value) }

	///@function contains(value)
  static contains = function(Value) { return binary_search(first(), last(), Value, comparator) }

	///@function set_comparator(compare_function)
	function set_comparator(Func) { comparator = method(other, Func) }

	type = Binary_Tree
	comparator = compare_less

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

