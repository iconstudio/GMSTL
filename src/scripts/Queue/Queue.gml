/*
	Constructors:
		Queue()
		Queue(Arg)
		Queue(Arg0, Arg1, ...)
		Queue(Builtin-Array)
		Queue(Builtin-List)
		Queue(Builtin-Queue)
		Queue(Container)
		Queue(Iterator-Begin, Iterator-End)

	Initialize:
		new Queue()

*/
function Queue(): Container() constructor {
#region public
	///@function size()
	static size = function() { return ds_queue_size(raw) }

	///@function empty()
	static empty = function() { return ds_queue_empty(raw) }

	///@function clear()
	static clear = function() { ds_queue_clear(raw) }

	///@function front()
	static front = function() {  return ds_queue_head(raw) }

	///@function back()
	static back = function() { return ds_queue_tail(raw)}

	///@function top()
	static top = function() { return ds_queue_head(raw) }

	///@function tail()
	static tail = function() { return ds_queue_tail(raw) }

	///@function push(value)
	static push = function(Value) { ds_queue_enqueue(raw, Value) }

	///@function push_back(value)
	static push_back = function(Value) { ds_queue_enqueue(raw, Value) }

	///@function assign(begin, end)
	static assign = function(First, Last) { clear(); foreach(First, Last, push_back) }

	///@function pop()
	static pop = function() { ds_queue_dequeue(raw) }

	///@function pop_front()
	static pop_front = function() { return ds_queue_dequeue(raw) }

	///@function read(data_string)
	static read = function(Str) { ds_queue_read(raw, Str) }

	///@function write()
	static write = function() { return ds_queue_write(raw) }

	///@function destroy()
	static destroy = function() { ds_queue_destroy(raw); gc_collect() }

	static type = Queue
#endregion

#region private
	raw = ds_queue_create()
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
				for (var i = 0; i < ds_list_size(Item); ++i) push_back(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_queue) {
				// (*) Built-in Queue
				ds_queue_copy(raw, Item)
			} else if is_struct(Item) {
				if instanceof(Item) == "Queue" {
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
