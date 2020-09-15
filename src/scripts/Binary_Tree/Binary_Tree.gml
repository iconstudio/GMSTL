function Binary_Tree(Params): List(Params) constructor {
	///@function iterator_at(index)
	function iterator_at(Index) { return (new iterator_type(self, Index)).pure() }

	///@function left(index)
	function left(Index) { return (new iterator_type(self, Index * 2 + 1)).pure() }

	///@function right(index)
	function right(Index) { return (new iterator_type(self, Index * 2 + 2)).pure() }

	///@function set_left(index, value)
  function set_left(Index, Value) { set(Index * 2 + 1, Value) return self }

	///@function set_right(index, value)
  function set_right(Index, Value) { set(Index * 2 + 2, Value) return self }

	///@function at_left(index)
	function at_left(Index) { return at(Index * 2 + 1) }

	///@function at_right(index)
	function at_right(Index) { return at(Index * 2 + 2) }

	///@function set_comparator(compare_function)
	function set_comparator(Func) {
		comparator = method(other, Fun)
	}

	comparator = compare_less
}
