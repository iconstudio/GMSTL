/*
	Constructors:
		Map()
		Map(Arg)
		Map(Map)
		Map(Iterable-PairedContainer)
		Map(Builtin-PairedArray)
		Map(Builtin-PairedList)
		Map(Builtin-Map)
		Map(Arg0, Arg1, ...)

	Initialize:
		new Map()
		set_value_type(type)

	Usage:
		To Iterate with keys:
			for (var It = first(); It != last(); ++It)
				myfunc(It.get())
		
*/
#macro Dictionary Map
function Map(): Container() constructor {
	///@function first()
  function first() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  function last() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  function cfirst() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  function clast() { return (new const_iterator_type(self, size())).pure() }

	///@function set(key, value)
  function set(K, Value) { 
		cash_push(K)
		ds_map_set(raw, K, Value)
		return self
	}

	///@function insert(pair)
	function insert(Pair) {
		set(Pair[0], Pair[1])
		return self
	}

	///@function change(key, value)
  function change(K, Value) {
		cash_push(K)
		return ds_map_replace(raw, K, Value) 
	}

	///@function set_list(key, builtin_list_id)
  function set_list(K, Value) {
		cash_push(K)
		ds_map_add_list(raw, K, Value)
	}

	///@function set_map(key, builtin_map_id)
  function set_map(K, Value) {
		cash_push(K)
		ds_map_add_map(raw, K, Value) 
	}

	///@function at(key)
  function at(K) { return ds_map_find_value(raw, K) }

  ///@function back()
	function back() { return at(ds_map_find_last(raw)) }

  ///@function front()
	function front() {  return at(ds_map_find_first(raw)) }

	///@function erase_at(key)
	function erase_at(K) {
		var Temp = at(K)
		ds_map_delete(raw, K)
		remove(cash.first(), cash.last(), K)
		return Temp
	}

	///@function erase_one(iterator)
	function erase_one(It) { return erase_at(It.get_index()) }

	///@function is_list(K)
  function is_list(K) { return ds_map_is_list(raw, K) }

	///@function is_map(K)
  function is_map(K) { return ds_map_is_map(raw, K) }

	///@function exists(key)
  function exists(K) { return ds_map_exists(raw, K) }

	///@function size()
	function size() { return ds_map_size(raw) }

	///@function empty()
	function empty() { return ds_map_empty(raw) }

	///@function clear()
	function clear() { ds_map_clear(raw) }

	///@function set_comparator(compare_function)
	function set_comparator(Func) { cash_comparator = method(other, Func) }

	///@function cash_push(key)
	function cash_push(K) {
		if !exists(K) {
			var filtered_key = is_numeric(K) ? K : is_string(K) ? string_weak_hash(K) : 0
			if 1 < cash.size() {
				var Last = cash.last()
				var Position = lower_bound(cash.first(), Last, filtered_key, cash_comparator)
				if Position.not_equals(Last) and !cash_comparator(filtered_key, Position.get())
					cash.insert(Position.get_index(), filtered_key)
				else
					cash.push_back(filtered_key)
			} else {
				cash.push_back(filtered_key)
			}
		}
	}

	///@function read(data_string)
	function read(Str) { ds_map_read(raw, Str) }

	///@function write()
	function write() { return ds_map_write(raw) }

	///@function destroy()
	function destroy() { ds_map_destroy(raw); cash.destroy(); delete cash; gc_collect() }

	type = Map
	raw = ds_map_create()
	iterator_type = MapIterator
	const_iterator_type = ConstMapIterator
	cash = new List()
	cash_comparator = compare_less

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Paired-Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in Paired-List
				for (var i = 0; i < ds_list_size(Item); ++i) insert(Item[| i])
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
				//ds_map_copy(raw, Item)
			} else if is_struct(Item) {
				if instanceof(Item) == "Map" {
					// (*) Map
					ds_map_copy(raw, Item.data())
				} else if is_iterable(Item) {
					// (*) Paired-Container
					foreach(Item.first(), Item.last(), function(Value) {
						insert(Value)
					})
				}
			} else {
				// (*) Arg
				insert(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}
