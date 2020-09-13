/*
	Constructors:
		Map()
		Map(Arg)
		Map(Maps)
		Map(Unordered_Maps)
		Map(Paired-Container)
		Map(Builtin-Paired-Array)
		Map(Builtin-Paired-List)
		Map(Builtin-Map)
		Map(Arg0, Arg1, ...)

	Initialize:
		new Map()

	Usage:
		To Iterate values:
			foreach(Container.first(), Container.last(), function(Value) {
				myfunc(Value[1])
			})
		
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

	///@function set(index, value)
  function set(Index, Value) { 
		var Key = cash.at(Index)
		if !is_undefined(Key)
			ds_map_set(raw, Key, Value)
		return self
	}

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
		if !contains(K) cash_push(Key)
		ds_map_set(raw, Key, Value)
		return self
	}

	///@function set_list(key, builtin_list_id)
  function set_list(K, Value) {
		if !contains(K) cash_push(K)
		ds_map_add_list(raw, K, Value)
	}

	///@function set_map(key, builtin_map_id)
  function set_map(K, Value) {
		if !contains(K) cash_push(K)
		ds_map_add_map(raw, K, Value) 
	}

	///@function seek(key)
  function seek(K) { return ds_map_find_value(raw, K) }

	///@function at(index)
  function at(Index) {
		var K = cash.at(Index)
		return make_pair(K, seek(K))
	}

  ///@function back()
	function back() { return at(size() - 1) }

  ///@function front()
	function front() { return at(0) }

	///@function erase_index(key)
	function erase_index(K) {
		var Temp = seek(K)
		ds_map_delete(raw, K)
		remove(cash.first(), cash.last(), K)
		return Temp
	}

	///@function erase_one(iterator)
	function erase_one(It) { return erase_index(It.get_index()) }

	///@function key_change(key, value)
  function key_change(K, Value) {
		cash_push(K)
		return ds_map_replace(raw, K, Value) 
	}

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

	///@function cash_push(key)
	function cash_push(K) {
		if 1 < cash.size() {
			cash.push_back(K)
			cash.sort_builtin(true)
		} else {
			cash.push_back(K)
		}
	}

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
	function destroy() { ds_map_destroy(raw); cash.destroy(); delete cash; gc_collect() }

	type = Map
	raw = ds_map_create()
	iterator_type = ForwardIterator
	const_iterator_type = ConstIterator
	cash = new List()
	
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
