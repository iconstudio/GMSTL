/*
	Constructors:
		Priority_Deque()
		Priority_Deque(Arg)
		Priority_Deque(Priority_Deque)
		Priority_Deque(Iterable-PairedContainer)
		Priority_Deque(Map)
		Priority_Deque(Priority_Queue)
		Priority_Deque(Builtin-PairedArray)
		Priority_Deque(Builtin-PairedList)
		Priority_Deque(Builtin-Map)
		Priority_Deque(Builtin-Priority)
		Priority_Deque(Arg0, Arg1, ...)

	Initialize:
		new Priority_Deque
		set_value_type(type)

	Usage:
		
*/
function Priority_Deque(): Container() constructor {
	type = Priority_Deque
	raw = ds_priority_create()

	///@function push(values_pair)
	function push(PairedVal) {
		if is_array(PairedVal)
			ds_priority_add(raw, PairedVal[1], PairedVal[0])
		else if is_struct(PairedVal)
			ds_priority_add(raw, PairedVal.second, PairedVal.first)
		else if argument_count == 2
			ds_priority_add(raw, argument[1], argument[0])
	}

	function pop() { ds_priority_delete_max(raw) }

	function pop_back() { return ds_priority_delete_min(raw) }

	function pop_front() { return ds_priority_delete_max(raw) }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

	///@function get(value)
	function get(Value) { return ds_priority_find_priority(raw, Value) }

  function tail() { return ds_priority_find_min(raw) }

  function top() { return ds_priority_find_max(raw) }

  function back() { return ds_priority_find_min(raw) }

  function front() { return ds_priority_find_max(raw) }

	function size() { return ds_priority_size(raw) }

	function empty() { return ds_priority_empty(raw) }

	function clear() { ds_priority_clear(raw) }

	///@function remove(value)
	function remove(Value) { ds_priority_delete_value(raw, Value) }

	function destroy() {
		ds_priority_destroy(raw)
		raw = undefined
	}

	///@function read(data_string)
	function read(Str) { ds_priority_read(raw, Str) }

	function write() { return ds_priority_write(raw) }

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
