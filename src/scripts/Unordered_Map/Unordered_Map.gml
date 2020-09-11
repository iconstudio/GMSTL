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
		new Map
		set_value_type(type)

	Usage:
		To Iterate with pair:
			var BucketNumber = bucket_count()
			for (var i = 0; i < BucketNumber; ++i) {
				var Key = get_key(i)
				var Value = at(Key)
				myfunc(Key, Value)
			}

		To Iterate with keys:
			for (var It = first(); It != last(); ++It)
				myfunc(get(It))
		
*/
#macro Ordered_Map Map
#macro Dictionary Map
function Map(): Container() constructor {
	///@function first()
  function first() { return 0 }

	///@function last()
  function last() { return size() }

	///@function set(values_pair)
	function set(PairedVal) {
		if is_array(PairedVal)
			__set(PairedVal[0], PairedVal[1])
		else if is_struct(PairedVal)
			__set(PairedVal.first, PairedVal.second)
		else if argument_count == 2
			__set(argument[0], argument[1])
		return self
	}

	///@function iter_set(values_pair)
  function iter_set(PairedVal) { 
		if is_array(PairedVal)
			__set(get_key(PairedVal[0]), PairedVal[1])
		else if is_struct(PairedVal)
			__set(get_key(PairedVal.first), PairedVal.second)
		else if argument_count == 2
			__set(get_key(argument[0]), argument[1])
		return self
	}

	///@function emplace(key, tuple)
	function emplace(K, Params) { set(K, construct(Params)) }

	///@function replace(key, value)
  function replace(K, Value) { 
		if !exists(K)
			__cash(K)
		return ds_map_replace(raw, K, Value)
	}

	///@function get(iterator)
  function get(It) {
		return at(get_key(It))
	}

	///@function get_key(bucket_iterator)
  function get_key(BucketIndex) {
		if 0 <= BucketIndex and BucketIndex < bucket_count()
			return key_memory[| BucketIndex]
		return undefined
	}

	///@function at(key)
  function at(K) { return ds_map_find_value(raw, K) }

	///@function _bucket(key)
  function _bucket(K) {
		//Cannot return the iterator at end
		return ds_list_find_index(key_memory, K)
	}

	///@function bucket_count()
  function bucket_count() {
		return key_memory_size
	}

  function back() {
		if 0 < key_memory_size
			return get(key_memory_size - 1)
		else
			return undefined
	}

  function front() { 
		if 0 < key_memory_size
			return get(0)
		else
			return undefined
	}

	///@function set_list(key, builtin_list_id)
  function set_list(K, Value) {
		if !exists(K)
			__cash(K)
		ds_map_add_list(raw, K, Value)
	}

	///@function add_map(key, builtin_map_id)
  function set_map(K, Value) {
		if !exists(K)
			__cash(K)
		ds_map_add_map(raw, K, Value)
	}

	///@function is_list(K)
  function is_list(K) { return ds_map_is_list(raw, K) }

	///@function is_map(K)
  function is_map(K) { return ds_map_is_map(raw, K) }

	///@function exists(key)
  function exists(K) { return ds_map_exists(raw, K) }

	function size() { return ds_map_size(raw) }

	function empty() { return ds_map_empty(raw) }

	function clear() { ds_map_clear(raw) }

	///@function check_all(begin, end, predicate)
	function check_all(First, Last, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if !pred(Value)
				return false
			First++
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(First, Last, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if pred(Value)
				return true
			First++
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(First, Last, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if pred(Value)
				return false
			First++
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(First, Last, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			pred(get(First))
			First++
		}
		return pred
	}

	///@function find(begin, end, value, [comparator])
	function find(First, Last, Value, Comparator) {
		var Compare = select_argument(Comparator, compare_equal)
		while First.not_equals(Last) {
			if Compare(get(First), Value)
				return First
			First++
		}
		return Last
	}

	///@function find_if(begin, end, predicate)
	function find_if(First, Last, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if !is_undefined(Value) and pred(Value)
				return First
			First++
		}
		return Last
	}

	///@function count(begin, end, value)
	function count(First, Last, Value) {
		for (var it = First, Result = 0; it != Last; it.go()) {
			if get(it) == Value
				Result++
		}
		return Result
	}

	///@function count_if(begin, end, predicate)
	function count_if(First, Last, Pred) {
		Pred = method(other, Pred)
		for (var it = First, Result = 0; it != Last; it.go()) {
			var Value = get(it)
			if pred(Value)
				Result++
		}
		return Result
	}

	///@function erase_key(key)
	function erase_key(K) {
		var Temp = at(K)
		ds_map_delete(raw, K)
		__try_decash(K)
		return Temp
	}

	///@function key_swap(key, destination, destination_key)
	function key_swap(K, Dst, DstK) {
		var Temp = at(K)
		set(K, Dst.at(DstK))
		Dst.set(DstK, Temp)
	}

	///@function iter_swap(iterator, destination, destination_iterator)
	function iter_swap(It, Dst, DstIt) {
		var Temp = get(It)
		iter_set(It, Dst.get(DstIt))
		Dst.iter_set(DstIt, Temp)
	}

	///@function remove(begin, end, value)
	function remove(First, Last, Value) {
		for (var it = First, Result = First; it != Last; it.go()) {
			if get(it) == Value {
				erase(Result)
			} else {
				Result++
			}
		}
		return Result
	}

	///@function remove_if(begin, end, predicate)
	function remove_if(First, Last, Pred) {
		Pred = method(other, Pred)
		for (var it = First, Result = First, Value; it != Last; it.go()) {
			Value = get(Result)
			if pred(get(Result)) {
				erase(Result)
			} else {
				Result++
			}
		}
		return Result
	}

	///@function transform(begin, end, output, predicate)
	function transform(First, Last, Output, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			iter_set(Output.go(), pred(get(First)))
			First++
		}
		return Output
	}

	function destroy() {
		ds_map_destroy(raw)
		raw = undefined
	}

	///@function read(data_string)
	function read(Str) {
		ds_map_read(raw, Str)
	}

	function write() {
		return ds_map_write(raw)
	}

	///@function __set(key, value)
	function __set(K, Value) {
		if !exists(K)
			__cash(K)
		ds_map_set(raw, K, Value)
	}

	///@function __erase_one(iterator)
	function __erase_one(It) {
		var TempK = key_memory[| It]
		if __try_decash(TempK) {
			var Value = at(TempK)
			ds_map_delete(raw, TempK)
			return Value
		}
	}

	///@function __erase_range(begin, end)
	function __erase_range(First, Last) {
		for (; First.not_equals(Last); ++First) {
			__erase_one(First)
		}
	}

	///@function __cash(key)
	function __cash(K) {
		ds_list_add(key_memory, K)
		key_memory_size++
	}

	///@function __try_decash(key)
	function __try_decash(K) {
		if 0 < key_memory_size {
			var It = ds_list_find_index(key_memory, K)
			if It != -1 {
				ds_list_delete(key_memory, It)
				key_memory_size--
				return true
			}
		}
		return false
	}

	type = Map
	raw = ds_map_create()
	key_memory = ds_list_create()
	key_memory_size = 0
	ds_list_clear(key_memory) // To avoid the 0-populate-value problem.

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_array(Item) {
				// (*) Built-in Paired-Array
				for (var i = 0; i < array_length(Item); ++i) set(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in Paired-List
				for (var i = 0; i < ds_list_size(Item); ++i) set(Item[| i])
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
					ds_list_copy(key_memory, Item.key_memory)
				} else if is_iterable(Item) {
					// (*) Paired-Container
					for (var It = Item.first(); It != Item.last(); ++It) {
						set(Item.get(It))
					}
				}
			} else {
				// (*) Arg
				set(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) {
				set(argument[i])
			}
		}
	}
}
