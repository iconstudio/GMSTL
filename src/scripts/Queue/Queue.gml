/*
	Constructors:
		Queue()
		Queue(Arg)
		Queue(Queue)
		Queue(Iterable-Container)
		Queue(Builtin-Array)
		Queue(Builtin-List)
		Queue(Builtin-Queue)
		Queue(Arg0, Arg1, ...)

	Initialize:
		new Queue

	Usage:
		
*/
function Queue(): Container() constructor {
	///@function size()
	static size = function() { return ds_queue_size(raw) }

	///@function empty()
	static empty = function() { return ds_queue_empty(raw) }

	///@function back()
	static back = function() { return ds_queue_tail(raw)}

	///@function front()
	static front = function() {  return ds_queue_head(raw) }

	///@function push(value)
	static push = function(Value) { ds_queue_enqueue(raw, Value) }

	///@function push_back(value)
	static push_back = function(Value) { ds_queue_enqueue(raw, Value) }

	///@function pop()
	static pop = function() { ds_queue_dequeue(raw) }

	///@function pop_front()
	static pop_front = function() { return ds_queue_dequeue(raw) }

	///@function clear()
	static clear = function() { ds_queue_clear(raw) }

	///@function read(data_string)
	static read = function(Str) { ds_queue_read(raw, Str) }

	///@function write()
	static write = function() { return ds_queue_write(raw) }

	///@function destroy()
	static destroy = function() { ds_queue_destroy(raw) gc_collect() }

	type = Queue
	raw = ds_queue_create()

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) {
				if instanceof(Item) == "Queue" {
					// (*) Copy Constructor
					ds_queue_copy(raw, Item.data())
				} else if is_iterable(Item) {
					// (*) Iterable-Container
					foreach(Item.first(), Item.last(), function(Value) { push(Value) })
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) push(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_queue) {
				// (*) Built-in Queue
				ds_queue_copy(raw, Item)
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
