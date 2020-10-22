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
			for (var It = Container.first(); It.not_equals(Container.last()); It.go_next()) {
				myfunc(It.get())
			}
		
*/
#macro Dictionary Map
function Map(): RedBlack_tree() constructor {
#region public
	///@function at(index)
	static at = function(Key) {
		
	}

	//////@function set_at(index, value)
	static set_at = function(Index, Value) { 
		var Key = cash.at(Index)
		if !is_undefined(Key)
			ds_map_set(raw, Key, Value)
		return self
	}

	///@function insert(item)
	static insert = function() {
		var Pair = argument[0]
		var Key = Pair[0]
		var Value = Pair[1]
		if !contains(Key) cash_push(Key)
		ds_map_set(raw, Key, Value)
		return self
	}

	///@function erase_at(key)
	static erase_at = function(K) {
		var Temp = seek(K)
		ds_map_delete(raw, K)
		remove(cash.first(), cash.last(), K)
		return Temp
	}

	///@function key_swap(key_1, key_2)
	static key_swap = function(Key1, Key2) {
		var Temp = seek(Key1)
		ds_map_set(raw, Key1, seek(Key2))
		ds_map_set(raw, Key2, Temp)
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

	static type = Map
	static iterator_type = Bidirectional_iterator
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = set_at

	///@function (index)
	static _Under_iterator_get = at

	///@function function(value)
	static _Under_iterator_add = push_back

	///@function (index, value)
	static _Under_iterator_insert = insert_at

	///@function (index)
	static _Under_iterator_next = function(Index) { return Index + 1 }

	///@function (index)
	static _Under_iterator_prev = function(Index) { return Index - 1 }

	///@function 
	static _Under_extract_key = function(Node) { return Node.value[0] }

	raw = ds_map_create()
	cash = new List()
#endregion

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
