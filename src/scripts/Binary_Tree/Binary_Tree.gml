global.__TLNULL = new (function() constructor {})()
#macro LEAF_NULL __TLNULL

function Binary_Tree(Params): List(Params) constructor {
	///@function iterator_at(index)
	function iterator_at(Index) { return new iterator_type(self, Index) }

	///@function left(index)
	function left(Index) { return Index * 2 + 1 }

	///@function right(index)
	function right(Index) { return Index * 2 + 2 }

	///@function set_left(index, value)
  function set_left(Index, Value) {
		var Size = size(), Dest = left(Index)
		if Dest < Size {
			set(Dest, Value)
		} else {
			var Times = Dest - Size - 1
			repeat Times
				push_back(LEAF_NULL)
			push_back(Value)
		}
		return self
	}

	///@function set_right(index, value)
  function set_right(Index, Value) {
		var Size = size(), Dest = right(Index)
		if Dest < Size {
			set(Dest, Value)
		} else {
			var Times = Dest - Size - 1
			repeat Times
				push_back(LEAF_NULL)
			push_back(Value)
		}
		return self
	}

	///@function at_left(index)
	function at_left(Index) { return at(left(Index)) }

	///@function at_right(index)
	function at_right(Index) { return at(right(Index)) }

	///@function set_comparator(compare_function)
	function set_comparator(Func) { comparator = method(other, Func) }

	comparator = compare_less
}

