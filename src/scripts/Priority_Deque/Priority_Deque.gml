/*
	Constructors:
		Priority_Deque()
		Priority_Deque(Arg)
		Priority_Deque(Priority_Deque)
		Priority_Deque(Iterable-PairedContainer)
		Priority_Deque(Map)
		Priority_Deque(Builtin-PairedArray)
		Priority_Deque(Builtin-PairedList)
		Priority_Deque(Builtin-Map)
		Priority_Deque(Builtin-Priori)
		Priority_Deque(Arg0, Arg1, ...)

	Initialize:
		new Priority_Deque
		set_value_type(type)

	Usage:
		
*/
function Priority_Deque(): Container() constructor {
	type = Priority_Deque
	raw = ds_priority_create()

	///@function push(priority, value)
	function push(Pri, Val) { ds_priority_add(raw, Val, Pri) }

	///@function pop()
	function pop() { ds_priority_delete_max(raw) }

	///@function pop_back()
	function pop_back() { return ds_priority_delete_max(raw) }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

	///@function get(value)
	function get(Val) { return ds_priority_find_priority(raw, Val) }

	///@function tail()
  function tail() { return ds_priority_find_min(raw) }

	///@function top()
  function top() { return ds_priority_find_max(raw) }

  function back() { return ds_priority_find_min(raw) }

  function front() { return ds_priority_find_max(raw) }

	function size() { return ds_priority_size(raw) }

	function empty() { return ds_priority_empty(raw) }

	function clear() { ds_priority_clear(raw) }

	///@function remove(value)
	function remove(Val) { ds_priority_delete_value(raw, Val) }

	function destroy() {
		ds_priority_destroy(raw)
		raw = undefined
	}

	///@function read(data_string)
	function read(Str) { ds_priority_read(raw, Str) }

	function write() { return ds_priority_write(raw) }
}
