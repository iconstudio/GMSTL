/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Multimaps)
		Multimap(Paired-Container)
		Multimap(Builtin-Paired-Array)
		Multimap(Builtin-Paired-List)
		Multimap(Builtin-Map)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap()

	Usage:
		To Iterate values on lists:
			for (var It = Container.first(); It.not_equal(Container.last()); It.go()) {
				var Pair = It.get()
				var KList = Pair[1]
				foreach(KList.first(), KList.first(), function(Value) {
					myfunc(Value)
				})
			}

		To Iterate values in a key:
			var Bucket = Container.bucket("KEY")
			for (var It = Container.first(Bucket); It.not_equal(Container.last(Bucket)); It.go())
				myfunc(It.get())

		To Iterate values with bucket indexes:
			var Pair, Key, Values
			for (var i = 0; i < Container.bucket_count(); ++i) {
				Pair = Container.at(i) // a Pair
				Key = TempPair[0]
				Values = TempPair[1] // a List
				for (var It = Values.first(); It.not_equal(Values.last()); It.go())
					myfunc(It.get())
			}

		To Iterate values within methods:
			var Bucket = Container.bucket("KEY")
			myfunc(Container.first(Bucket), Container.last(Bucket))
		
*/
function Multimap(): Container() constructor {
	///@function size()
	static size = function() { return ds_map_size(raw) }

	///@function empty()
	static empty = function() { return ds_map_empty(raw) }

	///@function contains(key)
  static contains = function(K) { return ds_map_exists(raw, K) }

	///@function seek(key)
  static seek = function(K) { return ds_map_find_value(raw, K) }

	///@function at(bucket_index)
  static at = function(Index) {
		var K = cash.at(Index)
		return make_pair(K, seek(K))
	}

  ///@function back()
	static back = function() { return at(size() - 1) }

  ///@function front()
	static front = function() { return at(0) }

	///@function bucket(key)
  static bucket = function(K) { return ds_list_find_index(cash.raw, K) }

	///@function bucket_find(bucket_index)
  static bucket_find = function(Index) { return seek(cash.at(Index)) }

	///@function bucket_count()
  static bucket_count = function() { return cash.size() }

	///@function bucket_create(key, [value])
	static bucket_create = function(K) {
		var NewList = new List()
		if 0 < argument_count
			NewList.push_back(argument[1])
		ds_map_set(raw, K, NewList)
	}

	///@function first([bucket_index])
  static first = function() {
		if 1 == argument_count
			return bucket_find(argument[0]).first()
		else
			return (new iterator_type(self, 0)).pure()
	}

	///@function last([bucket_index])
  static last = function() {
		if 1 == argument_count
			return bucket_find(argument[0]).last()
		else
			return (new iterator_type(self, size())).pure()
	}

	///@function cfirst([bucket_index])
  static cfirst = function() {
		if 1 == argument_count
			return bucket_find(argument[0]).cfirst()
		else
			return (new const_iterator_type(self, 0)).pure()
	}

	///@function clast([bucket_index])
  static clast = function() {
		if 1 == argument_count
			return bucket_find(argument[0]).clast()
		else
			return (new const_iterator_type(self, size())).pure()
	}

	///@function set(bucket_index, list)
  static set = function(Index, Value) {
		if !is_struct(Value)
			throw "Cannot bind a non-struct item to Multimap!"
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
		if !contains(Key) {
			cash_push(Key)
			bucket_create(Key, Value)
		} else {
			var KList = seek(Key)
			KList.push_back(Value)
			stable_sort(KList.first(), KList.last(), value_comparator)
		}
		return self
	}

	///@function erase_index(key)
	static erase_index = function(K) {
		var Temp = seek(K)
		ds_map_delete(raw, K)
		remove(cash.first(), cash.last(), K)
		return Temp
	}

	///@function erase_one(iterator)
	static erase_one = function(It) { return erase_index(It.get_index()) }

	///@function clear()
	static clear = function() { ds_map_clear(raw) }

	///@function key_swap(key_1, key_2)
  static key_swap = function(Key1, Key2) {
		var Temp = seek(Key1)
		ds_map_set(raw, Key1, seek(Key2))
		ds_map_set(raw, Key2, Temp)
	}

	///@function set_key_comp(compare_function)
	function set_key_comp(Func) { key_comparator = method(other, Func) return self }

	///@function set_value_comp(compare_function)
	function set_value_comp(Func) { value_comparator = method(other, Func) return self }

	///@function cash_push(key)
	function cash_push(K) {
		if 1 < cash.size() {
			cash.push_back(K)
			stable_sort(cash.first(), cash.last(), key_comparator)
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
	key_comparator = compare_complex_less
	value_comparator = compare_less
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
				//ds_map_copy(raw, Item)
			} else if is_struct(Item) {
				var Type = instanceof(Item)
				if Type == "Multimap" or Type == "Unordered_Multimap" {
					// (*) Multimaps
					foreach(Item.first(), Item.last(), function(Value) {
						var Key = Value[0], KList = Value[1].duplicate()
						ds_map_set(raw, Key, KList)
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
