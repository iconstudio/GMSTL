function Tree(): Container() constructor {
	comparator = compare_equal

	///@function set_comparator(compare_function)
	function set_comparator(Fun) {
		comparator = method(other, Fun)
	}
}
