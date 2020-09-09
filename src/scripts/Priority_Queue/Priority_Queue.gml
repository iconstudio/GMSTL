/*
	Constructors:
		Priority_Queue(comparator)

	Initialize:
		new Priority_Queue(cmpfunc)

	Usage:
		
*/
///@function Priority_Queue(comparator)
function Priority_Queue(Comparator): Container() constructor {
	type = Priority_Queue
	raw = ds_list_create()
	comparator = method(other, Comparator)

	///@function push(value)
	function push(Val) { ds_list_add(raw, Val) }

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
