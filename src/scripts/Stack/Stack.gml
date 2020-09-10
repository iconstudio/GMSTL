/*
	Constructors:
		Stack()
		Stack(Arg)
		Stack(Stack)
		Stack(Iterable-Container)
		Stack(Builtin-Array)
		Stack(Builtin-List)
		Stack(Builtin-Stack)
		Stack(Arg0, Arg1, ...)

	Initialize:
		new Stack
		set_value_type(type)

	Usage:
		
*/
function Stack(): Container() constructor {
	///@function push(value)
	function push(Value) { ds_stack_push(raw, Value) }

	///@function push_back(value)
	function push_back(Value) { ds_stack_push(raw, Value) }

	///@function pop()
	function pop() { ds_stack_pop(raw) }

	///@function pop_back()
	function pop_back() { return ds_stack_pop(raw) }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

  ///@function top()
	function top() { return ds_stack_top(raw) }

	///@function size()
	function size() { return ds_stack_size(raw) }

	///@function empty()
	function empty() { return ds_stack_empty(raw) }

	///@function clear()
	function clear() { ds_stack_clear(raw) }

	///@function read(data_string)
	function read(Str) { ds_stack_read(raw, Str) }

	///@function write()
	function write() { return ds_stack_write(raw) }

	///@function destroy()
	function destroy() { ds_stack_destroy(raw) gc_collect() }

	type = Stack
	raw = ds_stack_create()

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) {
				if instanceof(Item) == "Stack" {
					// (*) Copy Constructor
					ds_queue_copy(raw, Item.data())
				} else if is_iterable(Item) {
					// (*) Iterable-Container
					foreach(Item.first(), Item.last(), function(Val) { push(Val) })
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) {
					push(Item[| i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_stack) {
				// (*) Built-in Stack
				ds_stack_copy(raw, Item)
			} else {
				// (*) Arg
				push(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) push(argument[i])
		}
	}
}