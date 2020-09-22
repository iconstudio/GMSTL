/*
	Constructors:
		GM_Priority()
		GM_Priority(Arg)
		GM_Priority(GM_Priority)
		GM_Priority(Priority_Queue)
		GM_Priority(Container)
		GM_Priority(Builtin-Array)
		GM_Priority(Builtin-List)
		GM_Priority(Builtin-Map)
		GM_Priority(Builtin-Priority)
		GM_Priority(Arg0, Arg1, ...)

	Initialize:
		new GM_Priority()

	Usage:
		function Build(Type, Priority, Upgradable) constructor {
			type = Type
			priority = Priority
			upg_enabled = Upgradable
		}

		AI_Buildorder = new Priority_Queue(function(build_1, build_2) {
			return bool(build1.priority < build2.priority)
		})

		AI_Buildorder.push(new Build(Bldg.Terran.command_center, 150, false))
		repeat 9
			AI_Buildorder.push(new Build(Unit.Terran.scv, 80, false))
		AI_Buildorder.push(new Build(Bldg.Terran.supply_depot, 80, false))
		
	
*/
function GM_Priority(): Container() constructor {
	///@function size()
	static size = function() { return ds_priority_size(raw) }

	///@function empty()
	static empty = function() { return ds_priority_empty(raw) }

	///@function priority_of(value)
	static priority_of = function(Value) { return ds_priority_find_priority(raw, Value) }

	///@function top()
	static top = function() { return ds_priority_find_max(raw) }

	///@function tail()
	static tail = function() { return ds_priority_find_min(raw) }

	///@function front()
	static front = function() { return ds_priority_find_max(raw) }

	///@function back()
	static back = function() { return ds_priority_find_min(raw) }

	///@function insert(value)
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

	///@function push(value)
	static push = function(Value) { return insert(Value) }

	///@function erase_of(value)
	static erase_of = function(Value) { ds_priority_delete_value(raw, Value) }

	///@function pop()
	static pop = function() { ds_priority_delete_max(raw) }

	///@function pop_front()
	static pop_front = function() { return ds_priority_delete_max(raw) }

	///@function size()
	static pop_back = function() { return ds_priority_delete_min(raw) }

	///@function clear()
	static clear = function() { ds_priority_clear(raw) }

	///@function read(data_string)
	static read = function(Str) { ds_priority_read(raw, Str) }

	///@function write()
	static write = function() { return ds_priority_write(raw) }

	///@function size()
	static destroy = function() { ds_priority_destroy(raw); gc_collect() }

	type = GM_Priority
	raw = ds_priority_create()

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) insert(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_map) {
				// (*) Built-in Map
				var Size = ds_map_size(Item)
				if 0 < Size {
					var MIt = ds_map_find_first(Item)
					while true {
						insert(MIt, ds_map_find_value(Item, MIt))
						MIt = ds_map_find_next(Item, MIt)
						if is_undefined(MIt)
							break
					}
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_priority) {
				// (*) Built-in Priority
				ds_priority_copy(raw, Item)
			} else if is_struct(Item) {
				if is_iterable(Item) {
					// (*) Container
					foreach(Item.first(), Item.last(), insert)
				}
			} else {
				// (*) Arg
				push(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}
