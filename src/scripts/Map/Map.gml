/*
	Constructors:
		Map()
		Map(Arg)
		Map(Multimaps)
		Map(Paired-Container)
		Map(Builtin-Paired-Array)
		Map(Builtin-Paired-List)
		Map(Builtin-Map)
		Map(Arg0, Arg1, ...)

	Initialize:
		new Map()

	Usage:
		To Iterate values:
			for (var It = Container.first(); It.not_equals(Container.last()); It.go()) {
				myfunc(It.get())
			}
		
*/
#macro Dictionary Map
function Map(): Container() constructor {
	///@function empty()
	static empty = function() { return ds_map_empty(raw) }

	///@function size()
	static size = function() { return ds_map_size(raw) }

	///@function contains(key)
  static contains = function(K) { return ds_map_exists(raw, K) }

	///@function key_at(index)
  static key_at = function(Index) { return cash.at(Index) }

	///@function seek(key)
  static seek = function(K) { return ds_map_find_value(raw, K) }

	///@function at(index)
  static at = function(Index) { return ds_map_find_value(raw, key_at(Index)) }

  ///@function back()
	static back = function() { return at(size() - 1) }

  ///@function front()
	static front = function() { return at(0) }

	///@function first()
  static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  static last = function() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  static cfirst = function() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  static clast = function() { return (new const_iterator_type(self, size())).pure() }

	//////@function set(index, value)
  static set = function(Index, Value) { 
		var Key = cash.at(Index)
		if !is_undefined(Key)
			ds_map_set(raw, Key, Value)
		return self
	}

	///@function insert(item)
	static insert = function() {
		var Key, Value
		if argument_count == 2 {
			Key = argument[0]
			Value = argument[1]
		} else {
			var Pair = argument[0]
			Key = Pair[0]
			Value = Pair[1]
		}
		if !contains(Key) cash_push(Key)
		ds_map_set(raw, Key, Value)
		return self
	}

	///@function set_list(key, builtin_list_id)
  static set_list = function(K, Value) {
		if !contains(K) cash_push(K)
		ds_map_add_list(raw, K, Value)
	}

	///@function set_map(key, builtin_map_id)
  static set_map = function(K, Value) {
		if !contains(K) cash_push(K)
		ds_map_add_map(raw, K, Value) 
	}

	///@function erase_at(key)
	static erase_at = function(K) {
		var Temp = seek(K)
		ds_map_delete(raw, K)
		remove(cash.first(), cash.last(), K)
		return Temp
	}

	///@function clear()
	static clear = function() { ds_map_clear(raw) }

	///@function key_swap(key_1, key_2)
  static key_swap = function(Key1, Key2) {
		var Temp = seek(Key1)
		ds_map_set(raw, Key1, seek(Key2))
		ds_map_set(raw, Key2, Temp)
	}

	///@function is_list(key)
  static is_list = function(K) { return ds_map_is_list(raw, K) }

	///@function is_map(key)
  static is_map = function(K) { return ds_map_is_map(raw, K) }

	///@static cash_push = function(key)
	static cash_push = function(K) {
		if 1 < cash.size() {
			cash.push_back(K)
			cash.sort_builtin(true)
		} else {
			cash.push_back(K)
		}
	}

	///@function read(data_string)
	static read = function(Str) {
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
	static write = function() { return ds_map_write(raw) }

	///@function destroy()
	static destroy = function() { ds_map_destroy(raw); cash.destroy(); delete cash; gc_collect() }

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
				if Type == "Multimap" or Type == "Unordered_Multimap" {
					// (*) Multimaps
					foreach(Item.first(), Item.last(), function(Value) {
						var Key = Value[0], KList = Value[1].duplicate()
						insert(Key, KList)
					})
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
