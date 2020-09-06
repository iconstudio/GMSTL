/*
	Constructors:
		Queue()
		Queue(Arg)
		Queue(Queue)
		Queue(Builtin-Array)
		Queue(Builtin-List)
		Queue(Builtin-Queue)
		Queue(Iterable-Container)
		Queue(Arg0, Arg1, ...)

	Initialize:
		new Queue
		set_value_type(type)

	Usage:
		
*/
function Queue(): Container() constructor {
	type = Queue
	raw = ds_queue_create()
	inner_size = 0

	///@function push(value)
	function push(Val) { ds_queue_enqueue(raw, Val) }

	///@function push_back(value)
	function push_back(Val) { ds_queue_enqueue(raw, Val) }

	///@function pop()
	function pop() { ds_queue_dequeue(raw) }

	///@function pop_front()
	function pop_front() { return ds_queue_dequeue(raw) }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

	///@function back()
  function back() {
		return ds_queue_tail(raw)
	}

	///@function front()
  function front() { 
		return ds_queue_head(raw)
	}

	function size() {
		return ds_queue_size(raw)
	}

	function empty() {
		return ds_queue_empty(raw)
	}

	function clear() {
		ds_queue_clear(raw)
	}

	///@function read(data_string)
	function read(Str) {
		ds_queue_read(raw, Str)
	}

	function write() {
		return ds_queue_write(raw)
	}

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) {
				if is_iterable(Item) {
					// (*) Iterable-Container
					for (var It = Item.ibegin(); It != Item.iend(); ++It) {
						push(Item.get(It))
					}
				} else if instanceof(Item) == "Queue" {
					// (*) Queue
					ds_queue_copy(raw, Item.data())
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) {
					push(Item[i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_queue) {
				// (*) Built-in Queue
				ds_queue_copy(raw, Item)
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) {
					push(Item[| i])
				}
			} else {
				// (*) Arg
				push(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) {
				push(argument[i])
			}
		}
	}
}
