/*
	Constructors:
		Priority_Deque()
		Priority_Deque(Arg)
		Priority_Deque(Priority_Deque)
		Priority_Deque(Paired-Container)
		Priority_Deque(Map)
		Priority_Deque(Priority_Queue)
		Priority_Deque(Builtin-Paired-Array)
		Priority_Deque(Builtin-Paired-List)
		Priority_Deque(Builtin-Map)
		Priority_Deque(Builtin-Priority)
		Priority_Deque(Arg0, Arg1, ...)

	Initialize:
		new Priority_Deque();

	Usage:
		AI_Target_Filter = new Priority_Deque()
		AI_Target_Filter.set_procedure(function(Target) {
			return bool(Target.hp / Target.hp_max <= 0.4)
		})
	
*/
function Priority_Deque(): Container() constructor {
	///@function set_procedure(function)
	function set_procedure(Func) { procedure = method(other, Func) }

	///@function push(value)
	function push(Value) { ds_priority_add(raw, Value, procedure(Value)) }

	///@function insert(pair)
	function insert(Pair) { ds_priority_add(raw, Pair[1], Pair[0]) }

	///@function emplace(tuple)
	function emplace(Params) { insert(construct(Params)) }

	///@function pop()
	function pop() { ds_priority_delete_max(raw) }

	///@function size()
	function pop_back() { return ds_priority_delete_min(raw) }

	///@function pop_front()
	function pop_front() { return ds_priority_delete_max(raw) }

  ///@function tail()
	function tail() { return ds_priority_find_min(raw) }

  ///@function top()
	function top() { return ds_priority_find_max(raw) }

  ///@function back()
	function back() { return ds_priority_find_min(raw) }

  ///@function front()
	function front() { return ds_priority_find_max(raw) }

	///@function size()
	function size() { return ds_priority_size(raw) }

	///@function empty()
	function empty() { return ds_priority_empty(raw) }

	///@function clear()
	function clear() { ds_priority_clear(raw) }

	///@function seek(value)
	function seek(Value) { return ds_priority_find_priority(raw, Value) }

	///@function abandon(value)
	function abandon(Value) { ds_priority_delete_value(raw, Value) }

	///@function read(data_string)
	function read(Str) { ds_priority_read(raw, Str) }

	///@function write()
	function write() { return ds_priority_write(raw) }

	///@function size()
	function destroy() { ds_priority_destroy(raw) gc_collect() }

	type = Priority_Deque
	raw = ds_priority_create()
	procedure = function(Pair) { return Pair[0] }

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) {
				if is_iterable(Item) {
					// (*) Iterable-PairedContainer
					for (var It = Item.first(); It != Item.last(); ++It) {
						push(Item.get(It))
					}
				} else if instanceof(Item) == "Map" {
					// (*) Map
					var BucketNumber = Item.bucket_count()
					for (var i = 0; i < BucketNumber; ++i) {
						var Key = Item.get_key(i)
						var Value = Item.at(Key)
						push(Key, Value)
					}
				} else if instanceof(Item) == "Priority_Deque" {
					// (*) Priority Deque
					ds_priority_copy(raw, Item.data())
				} else if instanceof(Item) == "Priority_Queue" {
					// (*) Priority Queue
					
				}
			} else if is_array(Item) {
				// (*) Built-in PairedArray
				for (var i = 0; i < array_length(Item); ++i) {
					push(Item[i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in PairedList
				for (var i = 0; i < ds_list_size(Item); ++i) {
					push(Item[| i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_map) {
				// (*) Built-in Map
				
			} else if !is_nan(Item) and ds_exists(Item, ds_type_priority) {
				// (*) Built-in Priority
				ds_priority_copy(raw, Item)
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
