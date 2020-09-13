/*
	Constructors:
		Unordered_Map()
		Unordered_Map(Arg)
		Unordered_Map(Maps)
		Unordered_Map(Unordered_Maps)
		Unordered_Map(Paired-Container)
		Unordered_Map(Builtin-Paired-Array)
		Unordered_Map(Builtin-Paired-List)
		Unordered_Map(Builtin-Map)
		Unordered_Map(Arg0, Arg1, ...)

	Initialize:
		new Unordered_Map()
		set_value_type(type)

	Usage:
		To Iterate with keys:
			for (var It = first(); It != last(); ++It)
				myfunc(It.get())
		
*/
function Unordered_Map(): Container() constructor {
	///@function first()
  function first() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  function last() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  function cfirst() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  function clast() { return (new const_iterator_type(self, size())).pure() }

	///@function set(key, value)
  function set(K, Value) { ds_map_set(raw, K, Value) return self }

	///@function insert(item)
	function insert() {
		var Key, Value
		if argument_count == 2 {
			Key = argument[0]
			Value = argument[1]
		} else {
			var Pair = argument[0]
			Key = Pair[0]
			Value = Pair[1]
		}
		ds_map_set(raw, Pair[0], Pair[1])
		return self
	}

	///@function set_list(key, builtin_list_id)
  function set_list(K, Value) { ds_map_add_list(raw, K, Value) }

	///@function set_map(key, builtin_map_id)
  function set_map(K, Value) { ds_map_add_map(raw, K, Value)  }

	///@function seek(key)
  function seek(K) { return ds_map_find_value(raw, K) }

	///@function at(key)
  function at(K) { return make_pair(K, seek(K)) }

  ///@function back()
	function back() { return at(ds_map_find_last(raw)) }

  ///@function front()
	function front() {  return at(ds_map_find_first(raw)) }

	///@function erase_index(key)
	function erase_index(K) {
		var Temp = seek(K)
		ds_map_delete(raw, K)
		return Temp
	}

	///@function erase_one(iterator)
	function erase_one(It) { return erase_index(It.get_key()) }

	///@function key_swap(key_1, key_2)
  function key_swap(Key1, Key2) {
		var Temp = seek(Key1)
		ds_map_set(raw, Key1, seek(Key2))
		ds_map_set(raw, Key2, Temp)
	}

	///@function is_list(key)
  function is_list(K) { return ds_map_is_list(raw, K) }

	///@function is_map(key)
  function is_map(K) { return ds_map_is_map(raw, K) }

	///@function contains(key)
  function contains(K) { return ds_map_exists(raw, K) }

	///@function size()
	function size() { return ds_map_size(raw) }

	///@function empty()
	function empty() { return ds_map_empty(raw) }

	///@function clear()
	function clear() { ds_map_clear(raw) }

	///@function read(data_string)
	function read(Str) {
		var loaded = ds_map_create()
		ds_map_read(loaded, Str)
		if 0 < ds_map_size(loaded) {
			var MIt = ds_map_find_first(loaded)
			while true {
				insert(MIt, ds_map_find_value(loaded, MIt))
				MIt = ds_map_find_next(loaded, MIt)
				if is_undefined(MIt)
					break
			}
		} 
	}

	///@function write()
	function write() { return ds_map_write(raw) }

	///@function destroy()
	function destroy() { ds_map_destroy(raw); gc_collect() }

	type = Unordered_Map
	raw = ds_map_create()
	iterator_type = MapIterator
	const_iterator_type = ConstMapIterator

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
						insert(MIt, ds_map_find_value(Item, MIt))
						MIt = ds_map_find_next(Item, MIt)
						if is_undefined(MIt)
							break
					}
				}
			} else if is_struct(Item) {
				var Type = instanceof(Item)
				if Type == "Map" or Type == "Multimap" {
					// (*) Maps
					ds_map_copy(raw, Item.data())
					copy(cash.first(), cash.last(), Item.cash.first())
				} else if Type == "Unordered_Map" or Type == "Unordered_Multimap" {
					// (*) Unordered_Maps
					
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
