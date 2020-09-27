/*
	Constructors:
		GM_Priority()
		GM_Priority(Arg)
		GM_Priority(Arg0, Arg1, ...)
		GM_Priority(Builtin-Array)
		GM_Priority(Builtin-List)
		GM_Priority(Builtin-Map)
		GM_Priority(Builtin-Priority)
		GM_Priority(Container)
		GM_Priority(Iterator-Begin, Iterator-End)

	Initialize:
		new GM_Priority()

	Usage:
		AI_Target_Filter = new GM_Priority()
		with oEnemy
			other.GM_Priority.push()

		var weakest = AI_Target_Filter.top()

*/
function GM_Priority(): Container() constructor {
#region public
	///@function size()
	static size = function() { return ds_priority_size(raw) }

	///@function empty()
	static empty = function() { return ds_priority_empty(raw) }

	///@function clear()
	static clear = function() { ds_priority_clear(raw) }

	///@function front()
	static front = function() { return ds_priority_find_max(raw) }

	///@function back()
	static back = function() { return ds_priority_find_min(raw) }

	///@function top()
	static top = function() { return ds_priority_find_max(raw) }

	///@function tail()
	static tail = function() { return ds_priority_find_min(raw) }

	///@function insert_at(priority, value)
	static insert_at = function(Priority, Value) { ds_priority_add(raw, Value, Priority) }

	///@function push(value)
	static push = function(Value) { var Pair = argument[0]; return insert_at(Pair[0], Pair[1]) }

	///@function assign(begin, end)
	static assign = function(First, Last) { clear(); foreach(First, Last, push) }

	///@function erase_of(value)
	static erase_of = function(Value) { ds_priority_delete_value(raw, Value) }

	///@function pop()
	static pop = function() { ds_priority_delete_max(raw) }

	///@function pop_front()
	static pop_front = function() { return ds_priority_delete_max(raw) }

	///@function size()
	static pop_back = function() { return ds_priority_delete_min(raw) }

	///@function location(value)
	static location = function(Value) { return ds_priority_find_priority(raw, Value) }

	///@function read(data_string)
	static read = function(Str) { ds_priority_read(raw, Str) }

	///@function write()
	static write = function() { return ds_priority_write(raw) }

	///@function size()
	static destroy = function() { ds_priority_destroy(raw); gc_collect() }

	type = GM_Priority
#endregion

#region private
	raw = ds_priority_create()
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) push(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_map) {
				// (*) Built-in Map
				var Size = ds_map_size(Item)
				if 0 < Size {
					var MIt = ds_map_find_first(Item)
					while true {
						insert_at(MIt, ds_map_find_value(Item, MIt))
						MIt = ds_map_find_next(Item, MIt)
						if is_undefined(MIt)
							break
					}
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_priority) {
				// (*) Built-in Priority Queue
				ds_priority_copy(raw, Item)
			} else if is_struct(Item) {
				if instanceof(Item) == "GM_Priority" {
					// (*) Copy Constructor
					ds_priority_copy(raw, Item.data())
				} else if is_iterable(Item) {
					// (*) Container
					assign(Item.first(), Item.last())
				}
			} else {
				// (*) Arg
				push(Item)
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
			for (var i = 0; i < argument_count; ++i) push(argument[i])
		}
	}
}
