/*
	Constructors:
		Priority_Deque()
		Priority_Deque(Arg)
		Priority_Deque(Maps)
		Priority_Deque(Priority_Deque)
		Priority_Deque(Priority_Queue)
		Priority_Deque(Container)
		Priority_Deque(Builtin-Array)
		Priority_Deque(Builtin-List)
		Priority_Deque(Builtin-Map)
		Priority_Deque(Builtin-Priority)
		Priority_Deque(Arg0, Arg1, ...)

	Initialize:
		new Priority_Deque()

	Usage:
		AI_Target_Filter = new Priority_Deque()
		AI_Target_Filter.set_procedure(function(Target) {
			return (Target.hp / Target.hp_max) * 20
		})
	
*/
function Priority_Deque(): Container() constructor {
	///@function size()
	static size = function() { return ds_priority_size(raw) }

	///@function empty()
	static empty = function() { return ds_priority_empty(raw) }

	///@function tail()
	static tail = function() { return ds_priority_find_min(raw) }

	///@function top()
	static top = function() { return ds_priority_find_max(raw) }

	///@function back()
	static back = function() { return ds_priority_find_min(raw) }

	///@function front()
	static front = function() { return ds_priority_find_max(raw) }

	///@function set_procedure(function)
	static set_procedure = function(Func) { procedure = method(other, Func) }

	///@function push(value)
	static push = function(Value) { ds_priority_add(raw, Value, procedure(Value)) }

	///@function insert(item)
	static insert = function() {
		var Pri, Value
		if argument_count == 2 {
			Pri = argument[0]
			Value = argument[1]
		} else {
			var Pair = argument[0]
			Pri = Pair[0]
			Value = Pair[1]
		}
		ds_priority_add(raw, Value, Pri)
	}

	///@function pop()
	static pop = function() { ds_priority_delete_max(raw) }

	///@function size()
	static pop_back = function() { return ds_priority_delete_min(raw) }

	///@function pop_front()
	static pop_front = function() { return ds_priority_delete_max(raw) }

	///@function clear()
	static clear = function() { ds_priority_clear(raw) }

	///@function seek(value)
	static seek = function(Value) { return ds_priority_find_priority(raw, Value) }

	///@function abandon(value)
	static abandon = function(Value) { ds_priority_delete_value(raw, Value) }

	///@function read(data_string)
	static read = function(Str) { ds_priority_read(raw, Str) }

	///@function write()
	static write = function() { return ds_priority_write(raw) }

	///@function size()
	static destroy = function() { ds_priority_destroy(raw) gc_collect() }

	type = Priority_Deque
	raw = ds_priority_create()
	procedure = function(Pair) { return real(Pair[0]) }

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
						set(MIt, ds_map_find_value(Item, MIt))
						MIt = ds_map_find_next(Item, MIt)
						if is_undefined(MIt)
							break
					}
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_priority) {
				// (*) Built-in Priority
				ds_priority_copy(raw, Item)
			} else if is_struct(Item) {
				var Type = instanceof(Item)
				if Type == "Map" or Type == "Unordered_Map" {
					// (*) Maps
					foreach(Item.first(), Item.last(), function(Value) {
						insert(Value[1])
					})
				} else if Type == "Priority_Deque" {
					// (*) Priority Deque
					ds_priority_copy(raw, Item.data())
				} else if Type == "Priority_Queue" {
					// (*) Priority Queue
					foreach(Item.cfirst(), Item.clast(), function(Value) {
						push(Value)
					})
				} else if is_iterable(Item) {
					// (*) Container
					foreach(Item.first(), Item.last(), function(Value) {
						push(Value)
					})
				}
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
