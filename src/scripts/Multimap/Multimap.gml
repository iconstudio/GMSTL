/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Maps)
		Multimap(Unordered_Maps)
		Multimap(Paired-Container)
		Multimap(Builtin-Paired-Array)
		Multimap(Builtin-Paired-List)
		Multimap(Builtin-Map)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap()
		set_value_type(type)

	Usage:
		To Iterate on keys:
			for (var It = first(); It != last(); ++It)
				myfunc(get_key(It))

		To Iterate on lists:
			for (var It = first(); It != last(); ++It)
				myfunc(get(It))

		To Iterate values with a key:
			var BucketIndex = bucket(Key)
			for (var It = first(BucketIndex); It != last(BucketIndex); ++It)
				myfunc(get(BucketIndex, It))

		To Iterate values within methods:
			var BucketIndex = bucket(Key)
			myfunc(BucketIndex, first(BucketIndex), last(BucketIndex))
		
*/
function Multimap(): Container() constructor {
	///@function bucket(key)
  function bucket(K) { return seek(K) }

	///@function bucket_find(bucket_index)
  function bucket_find(Index) { return seek(cash.at(Index)) }

	///@function bucket_count()
  function bucket_count() { return cash.size() }

	///@function bucket_create(key, [value])
	function bucket_create(K) {
		var NewList = new List()
		if 0 < argument_count
			NewList.push_back(argument[1])
		ds_map_set(raw, K, NewList)
	}

	///@function first([bucket_index])
  function first() {
		if 1 == argument_count
			return bucket_find(argument[0]).first()
		else
			return (new iterator_type(self, 0)).pure()
	}

	///@function last([bucket_index])
  function last() {
		if 1 == argument_count
			return bucket_find(argument[0]).last()
		else
			return (new iterator_type(self, size())).pure()
	}

	///@function cfirst([bucket_index])
  function cfirst() {
		if 1 == argument_count
			return bucket_find(argument[0]).cfirst()
		else
			return (new const_iterator_type(self, 0)).pure()
	}

	///@function clast([bucket_index])
  function clast() {
		if 1 == argument_count
			return bucket_find(argument[0]).clast()
		else
			return (new const_iterator_type(self, size())).pure()
	}

	///@function set(bucket_index, list)
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
		if !contains(Key) {
			cash_push(Key)
			bucket_create(Key, Value)
		} else {
			var KList = bucket(Key)
			KList.push_back(Value)
			sort(KList.first(), KList.last(), value_comparator)
		}
		return self
	}

	///@function seek(key)
  function seek(K) { return ds_map_find_value(raw, K) }

	///@function at(bucket_index)
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

	///@function key_swap(key_1, key_2)
  function key_swap(Key1, Key2) {
		var Temp = seek(Key1)
		ds_map_set(raw, Key1, seek(Key2))
		ds_map_set(raw, Key2, Temp)
	}

	///@function is_list(K)
  function is_list(K) { return ds_map_is_list(raw, K) }

	///@function is_map(K)
  function is_map(K) { return ds_map_is_map(raw, K) }

	///@function contains(key)
  function contains(K) { return ds_map_exists(raw, K) }

	///@function size()
	function size() { return ds_map_size(raw) }

	///@function empty()
	function empty() { return ds_map_empty(raw) }

	///@function clear()
	function clear() { ds_map_clear(raw) }

	///@function set_value_comp(compare_function)
	function set_value_comp(Func) { value_comparator = method(other, Fun) return self }

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
				if Type == "Map" or Type == "Unordered_Map" {
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
