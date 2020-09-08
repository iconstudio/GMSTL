/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Multimap)
		Multimap(Builtin-PairedArray)
		Multimap(Builtin-PairedList)
		Multimap(Builtin-Map)
		Multimap(Builtin-PriorityQueue)
		Multimap(Iterable-PairedContainer)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap
		set_value_type(type)

	Usage:
		
		
*/
function Priority_Queue(): Container() constructor {
	type = Priority_Queue
	raw = ds_priority_create()
	

	///@function push(value)
	function push(Val) { ds_stack_push(raw, Val) }

	///@function push_back(value)
	function push_back(Val) { ds_stack_push(raw, Val) }

	///@function pop()
	function pop() { ds_stack_pop(raw) }

	///@function pop_back()
	function pop_back() { return ds_stack_pop(raw) }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

	///@function top()
  function top() {
		return ds_stack_top(raw)
	}

	function size() {
		return ds_priority_size(raw)
	}

	function empty() {
		return ds_priority_empty(raw)
	}

	function clear() {
		ds_priority_clear(raw)
	}

	///@function read(data_string)
	function read(Str) {
		ds_priority_read(raw, Str)
	}

	function write() {
		return ds_priority_write(raw)
	}
}
