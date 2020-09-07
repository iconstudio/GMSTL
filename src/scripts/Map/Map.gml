/*
	Constructors:
		Map()
		Map(Arg)
		Map(Map)
		Map(Builtin-PairedArray)
		Map(Builtin-PairedList)
		Map(Builtin-Map)
		Map(Iterable-PairedContainer)
		Map(Arg0, Arg1, ...)

	Initialize:
		new Map
		set_value_type(type)

	Usage:
		To Iterate with keys:
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(get(It))
		
*/
#macro Unordered_Map Map
#macro Dictionary Map
function Map(): Container() constructor {
	type = Map
	raw = ds_map_create()
	key_memory = ds_list_create()
	key_memory_size = 0
	ds_list_clear(key_memory) // To avoid the 0-populate-value problem.

	///@function ibegin()
  function ibegin() { return 0 }

	///@function iend()
  function iend() { return size() }

	///@function bucket(key)
  function bucket(K) {
		var It = ds_list_find_index(key_memory, K)
		if It != -1 {
			return It
		} else {
			//Cannot return the iterator at end
			return -1
		}
	}

	///@function bucket_get(bucket_iterator)
  function bucket_get(Index) {
		if 0 <= Index and Index < bucket_count()
			return key_memory[| Index]
		return undefined
	}

	///@function bucket_count()
  function bucket_count() {
		return key_memory_size
	}

	///@function bucket_size(bucket_iterator)
  function bucket_size(Index) {
		if 0 <= Index and Index < bucket_count()
			return ds_list_size(key_memory[| Index])
		else
			return 0
	}

	///@function cash(key)
	function cash(K) {
		if is_undefined(ds_list_find_value(key_memory, K)) {
			ds_list_add(key_memory, K)
			key_memory_size++
		}
	}

	///@function try_decash(key)
	function try_decash(K) {
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

	///@function __set(key, value)
	function __set(K, Val) {
		ds_map_set(raw, K, Val)
		if !exists(K)
			cash(K)
	}

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
			__set(key_memory[| PairedVal[0]], PairedVal[1])
		else if is_struct(PairedVal)
			__set(key_memory[| PairedVal.first], PairedVal.second)
		else if argument_count == 2
			__set(key_memory[| argument[0]], argument[1])
		return self
	}

	///@function change(key, value)
  function change(K, Val) { 
		if !exists(K)
			cash(K)
		return ds_map_replace(raw, K, Val)
	}

	///@function get(iterator)
  function get(It) {
		return at(bucket_get(It))
	}

	///@function at(key)
  function at(K) { return ds_map_find_value(raw, K) }

	///@function back()
  function back() {
		if 0 < key_memory_size
			return get(key_memory_size - 1)
		else
			return undefined
	}

	///@function front()
  function front() { 
		if 0 < key_memory_size
			return get(0)
		else
			return undefined
	}

	///@function add_list(key, builtin_list_id)
  function add_list(K, Val) {
		if !exists(K)
			cash(K)
		ds_map_add_list(raw, K, Val)
	}

	///@function add_map(key, builtin_map_id)
  function add_map(K, Val) {
		if !exists(K)
			cash(K)
		ds_map_add_map(raw, K, Val)
	}

	///@function is_list(K)
  function is_list(K) { return ds_map_is_list(raw, K) }

	///@function is_map(K)
  function is_map(K) { return ds_map_is_map(raw, K) }

	///@function exists(K)
  function exists(K) { return ds_map_exists(raw, K) }

	///@function size()
	function size() { return ds_map_size(raw) }

	///@function empty()
	function empty() { return ds_map_empty(raw) }

	///@function clear()
	function clear() { ds_map_clear(raw) }

	///@function emplace(key, tuple)
	function emplace(K, Params) { set(K, construct(Params)) }

	///@function check_all(begin, end, predicate)
	function check_all(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !pred(Val)
				return false
			First++
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if pred(Val)
				return true
			First++
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if pred(Val)
				return false
			First++
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			pred(get(First))
			First++
		}
		return pred
	}

	///@function find(begin, end, value, [comparator])
	function find(First, Last, Val, Comparator) {
		var comp = select_argument(Comparator, comparator_equal)
		while First != Last {
			if comp(get(First), Val)
				return First
			First++
		}
		return Last
	}

	///@function find_if(begin, end, predicate)
	function find_if(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				return First
			First++
		}
		return Last
	}

	///@function count(begin, end, value)
	function count(First, Last, Val) {
		for (var it = First, result = 0; it != Last; ++it) {
			if get(it) == Val
				result++
		}
		return result
	}

	///@function count_if(begin, end, predicate)
	function count_if(First, Last, Pred) {
		var pred = method(other, Pred)
		for (var it = First, result = 0; it != Last; ++it) {
			var Val = get(it)
			if pred(Val)
				result++
		}
		return result
	}

	///@function erase_key(key)
	function erase_key(K) {
		var Temp = at(K)
		ds_map_delete(raw, K)
		try_decash(K)
		return Temp
	}

	///@function __erase_one(iterator)
	function __erase_one(It) {
		var TempK = key_memory[| It]
		if try_decash(TempK) {
			var Val = at(TempK)
			ds_map_delete(raw, TempK)
			return Val
		}
	}

	///@function __erase_range(begin, end)
	function __erase_range(First, Last) {
		for (; First != Last; ++First) {
			__erase_one(First)
		}
	}

	///@function swap(key_1, key_2)
	function swap(KeyA, KeyB) {
		var Temp = at(KeyA)
		set(KeyA, at(KeyB))
		set(KeyB, Temp)
	}

	///@function swap_range(begin, end, output)
	function swap_range(First, Last, Output) {
		while First != Last {
	    iter_swap(First, Output)

			First++
			Output++
	  }
	  return Output
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

	///@function remove(begin, end, [value])
	function remove(First, Last, Val) {
		for (var it = First, result = First; it != Last; ++it) {
			if get(it) == Val {
				erase(result)
			} else {
				result++
			}
		}
		return result
	}

	///@function remove_if(begin, end, predicate)
	function remove_if(First, Last, Pred) {
		var pred = method(other, Pred)
		for (var it = First, result = First, Val; it != Last; ++it) {
			Val = get(result)
			if pred(get(result)) {
				erase(result)
			} else {
				result++
			}
		}
		return result
	}

	///@function transform(begin, end, output, predicate)
	function transform(First, Last, Output, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			iter_set(Output++, pred(get(First)))
			First++
		}
		return Output
	}

	///@function read(data_string)
	function read(Str) {
		ds_map_read(raw, Str)
	}

	function write() {
		return ds_map_write(raw)
	}

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) and is_iterable(Item) {
				if is_iterable(Item) {
					// (*) Iterable-PairedContainer
					for (var It = Item.ibegin(); It != Item.iend(); ++It) {
						set(Item.get(It))
					}
				} else if instanceof(Item) == "Map" {
					// (*) Map
					ds_map_copy(raw, Item.data())
				}
			} else if is_array(Item) {
				// (*) Built-in PairedArray
				for (var i = 0; i < array_length(Item); ++i) {
					set(Item[i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in PairedList
				for (var i = 0; i < ds_list_size(Item); ++i) {
					set(Item[| i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_map) {
				// (*) Built-in Map
				ds_map_copy(raw, Item)
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
