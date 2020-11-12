/*
	Constructors:
		Stack()
		Stack(Arg)
		Stack(Arg0, Arg1, ...)
		Stack(Builtin-Array)
		Stack(Builtin-List)
		Stack(Builtin-Stack)
		Stack(Container)
		Stack(Iterator-Begin, Iterator-End)

	Initialize:
		new Stack()

*/
function Stack(): Container() constructor {
#region public
	///@function size()
	static size = function() { return ds_stack_size(raw) }

	///@function empty()
	static empty = function() { return ds_stack_empty(raw) }

	///@function clear()
	static clear = function() { ds_stack_clear(raw) }

	///@function back()
	static back = function() { return ds_stack_top(raw) }

	///@function top()
	static top = function() { return ds_stack_top(raw) }

	///@function push(value)
	static push = function(Value) { ds_stack_push(raw, Value) }

	///@function push_back(value)
	static push_back = function(Value) { ds_stack_push(raw, Value) }

	///@function pop()
	static pop = function() { ds_stack_pop(raw) }

	///@function pop_back()
	static pop_back = function() { return ds_stack_pop(raw) }

	///@function read(data_string)
	static read = function(Str) { ds_stack_read(raw, Str) }

	///@function write()
	static write = function() { return ds_stack_write(raw) }

	///@function destroy()
	static destroy = function() { ds_stack_destroy(raw); gc_collect() }

	static type = Stack
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = undefined

	///@function (index)
	static _Under_iterator_get = undefined

	///@function function(value)
	static _Under_iterator_add = push

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = undefined

	///@function (index)
	static _Under_iterator_prev = undefined

	raw = ds_stack_create()
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push_back(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < inner_size; ++i) push_back(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_stack) {
				// (*) Built-in Stack
				ds_stack_copy(raw, Item)
			} else if is_struct(Item) {
				if instanceof(Item) == "Stack" {
					// (*) Copy Constructor
					ds_queue_copy(raw, Item.data())
				} else if is_iterable(Item) {
					// (*) Container
					assign(Item.first(), Item.last())
				}
			} else {
				// (*) Arg
				push_back(Item)
			}
		} else {
			// (*) Iterator-Begin, Iterator-End
			if argument_count == 2 {
				if is_struct(argument[0]) and is_iterator(argument[0])
				and is_struct(argument[1]) and is_iterator(argument[1]) {
					assign(argument[0], argument[1])
					exit
				}
			}
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) push_back(argument[i])
		}
	}
}