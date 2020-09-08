/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Map)
		Multimap(Multimap)
		Multimap(Builtin-PairedArray)
		Multimap(Builtin-PairedList)
		Multimap(Builtin-Map)
		Multimap(Builtin-PriorityQueue)
		Multimap(Iterable-PairedContainer)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap
		set_value_type(type)

	Usage:
		To Iterate on keys:
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(get_key(It))

		To Iterate on lists:
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(get(It))

		To Iterate values with a key:
			var BucketIndex = bucket(Key)
			for (var It = ibegin(BucketIndex); It != iend(BucketIndex); ++It)
				myfunc(get(BucketIndex, It))
		
*/
#macro Ordered_Multimap Multimap
function Multimap() {
	type = Multimap
	raw = ds_map_create()
	key_memory = new List()
	key_memory.clear() // To avoid the 0-populate-value problem.

	///@function ibegin([bucket_iterator])
  function ibegin() {
		if argument_count == 0
			return 0
		else
			return 0 // Logic
	}

	///@function iend([bucket_iterator])
  function iend() {
		if argument_count == 0 {
			return size()
		} else if is_real(argument[0]) and 0 <= argument[0] and argument[0] < bucket_count() {
			return bucket_size(argument[0])
		}
		throw "An error occured when getting the end of a multimap!"
	}

	///@function at(key)
  function at(K) { return ds_map_find_value(raw, K) }

	///@function __set(key, value)
	function __set(K, Val) {
		if !exists(K) {
			__cash(K)
			var NewList = new List(Val)
			ds_map_set(raw, K, NewList)
			NewList.push_back(Val)
			return NewList
		} else {
			var TempList = at(K)
			TempList.push_back(Val)
			return TempList
		}
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

	///@function set_list(key, builtin_list_id)
  function set_list(K, Val) {
		if !exists(K) {
			__cash(K)
			var NewList = new List(Val)
			ds_map_set(raw, K, NewList)
		} else {
			var BeforeList = ds_map_find_value(raw, K)
			BeforeList.destroy()
			delete BeforeList
			ds_map_set(raw, K, Val)
		}
	}

	///@function iter_set(bucket_iterator, values_pair)
  function iter_set(BucketIndex, PairedVal) {
		var It = -1, Val = 0
		if is_array(PairedVal) {
			It = PairedVal[0]
			Val = PairedVal[1]
		} else if is_struct(PairedVal) {
			It = PairedVal.first
			Val = PairedVal.second
		} else if argument_count == 3 {
			It = argument[1]
			Val = argument[2]
		}

		bucket_set(BucketIndex, It, Val)
		return self
	}

	///@function get_key(bucket_iterator)
  function get_key(BucketIndex) {
		if 0 <= BucketIndex and BucketIndex < bucket_count() // key
			return key_memory.get(BucketIndex)
		return undefined
	}

	///@function get(bucket_iterator, [iterator])
  function get(BucketIndex) {
		if 0 <= BucketIndex and BucketIndex < bucket_count() {
			var Result = at(get_key(BucketIndex)) // list
			if argument_count == 2
				Result = Result.get(argument[1]) // value
			return Result
		}
		return undefined
	}

	///@function bucket(key)
  function bucket(K) {
		//Cannot return the iterator at end
		return ds_list_find_index(key_memory.data(), K) // optimize
	}

	///@function bucket_set(bucket_iterator, iterator, value)
  function bucket_set(BucketIndex, It, Val) {
		get(BucketIndex).set(It, Val)
	}

	///@function bucket_count()
  function bucket_count() {
		return key_memory.size()
	}

	///@function bucket_size(bucket_iterator)
  function bucket_size(BucketIndex) {
		return get(BucketIndex).size()
	}

	///@function back(bucket_iterator)
  function back(BucketIndex) {
		return get(BucketIndex).back()
	}

	///@function front(bucket_iterator)
  function front(BucketIndex) { 
		return get(BucketIndex).front()
	}

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

	///@function check_all(bucket_iterator, begin, end, predicate)
	function check_all(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.check_all(First, Last, pred)
	}

	///@function check_any(bucket_iterator, begin, end, predicate)
	function check_any(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.check_any(First, Last, pred)
	}

	///@function check_none(bucket_iterator, begin, end, predicate)
	function check_none(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.check_none(First, Last, pred)
	}

	///@function foreach(bucket_iterator, begin, end, predicate)
	function foreach(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.foreach(First, Last, pred)
	}

	///@function find(bucket_iterator, begin, end, value, [comparator])
	function find(BucketIndex, First, Last, Val, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.find(First, Last, Val, Comparator)
	}

	///@function find_if(bucket_iterator, begin, end, predicate)
	function find_if(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.find_if(First, Last, pred)
	}

	///@function count(bucket_iterator, begin, end, value)
	function count(BucketIndex, First, Last, Val) {
		var MyList = get(BucketIndex)
		return MyList.count(First, Last, Val)
	}

	///@function count_if(bucket_iterator, begin, end, predicate)
	function count_if(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.count_if(First, Last, pred)
	}

	///@function erase(bucket_iterator, begin, [end])
	function erase(BucketIndex) {
		if argument_count == 1
			erase_key(get_key(BucketIndex))
		if argument_count == 2
			__erase_one(BucketIndex, argument[1])
		else if argument_count == 3
			__erase_range(BucketIndex, argument[1], argument[2])
	}

	///@function erase_key(key)
	function erase_key(K) {
		var MyList = at(K)
		MyList.destroy()
		delete MyList
		ds_map_delete(raw, K)
		__try_decash(K)
	}

	///@function __erase_one(bucket_iterator, iterator)
	function __erase_one(BucketIndex, It) {
		var MyList = get(BucketIndex)
		MyList.erase(It)
	}

	///@function __erase_range(bucket_iterator, begin, end)
	function __erase_range(BucketIndex, First, Last) {
		var MyList = get(BucketIndex)
		for (; First != Last; ++First) {
			MyList.erase(First)
		}
	}

	///@function swap(key_1, key_2)
	function swap(KeyA, KeyB) {
		var Temp = at(KeyA)
		set(KeyA, at(KeyB))
		set(KeyB, Temp)
	}

	///@function key_swap(key, destination, destination_key)
	function key_swap(K, Dst, DstK) {
		var Temp = at(K)
		set(K, Dst.at(DstK))
		Dst.set(DstK, Temp)
	}

	///@function bucket_swap(bucket_iterator, iterator_1, iterator_2)
	function bucket_swap(BucketIndex, ItA, ItB) {
		var Temp = get(BucketIndex, ItA)
		bucket_set(BucketIndex, ItA, get(BucketIndex, ItB))
		bucket_set(BucketIndex, ItB, Temp)
	}

	///@function iter_swap(bucket_iterator_1, iterator_1, bucket_iterator_2, iterator_2)
	function iter_swap(BucketIndex, It, OutIndex, Output) {
		var Temp = get(BucketIndex, It)
		iter_set(BucketIndex, It, get(OutIndex, Output))
		iter_set(OutIndex, OutIndex, Temp)
	}

	///@function swap_range(bucket_iterator_1, begin, end, bucket_iterator_2, bucket_iterator_2_output)
	function swap_range(BucketIndex, First, Last, OutIndex, Output) {
		while First != Last {
	    iter_swap(BucketIndex, First, OutIndex, Output)

			First++
			Output++
	  }
	  return Output
	}

	///@function bucket_iter_swap(bucket_iterator, iterator, destination, destination_bucket_iterator, destination_bucket_iterator_output)
	function bucket_iter_swap(BucketIndex, It, Dst, OutIndex, Output) {
		var Temp = get(BucketIndex, It)
		bucket_set(BucketIndex, It, Dst.get(OutIndex, Output))
		Dst.bucket_set(OutIndex, Output, Temp)
	}

	///@function remove(bucket_iterator, begin, end, value)
	function remove(BucketIndex, First, Last, Val) {
		var MyList = get(BucketIndex)
		return MyList.remove(First, Last, Val)
	}

	///@function remove_if(bucket_iterator, begin, end, predicate)
	function remove_if(BucketIndex, First, Last, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.remove_if(First, Last, pred)
	}

	///@function bucket_move(bucket_iterator, begin, end, output)
	function bucket_move(BucketIndex, First, Last, Output) {
		var MyList = get(BucketIndex)
		return MyList.move(First, Last, Output)
	}

	///@function move(bucket_iterator_1, begin, end, bucket_iterator_2, bucket_iterator_2_output)
	function move(BucketIndex, First, Last, OutIndex, Output) {
		var MyList = get(BucketIndex)
		var OtherList = get(OutIndex)
		return MyList.move_to(First, Last, OtherList, Output)
	}

	///@function move_to(bucket_iterator, begin, end, destination, destination_bucket_iterator, destination_bucket_iterator_output)
	function move_to(BucketIndex, First, Last, Dst, OutIndex, Output) {
		var MyList = get(BucketIndex)
		var DstList = Dst.get(OutIndex)
		return MyList.move_to(First, Last, DstList, Output)
	}

	///@function fill(bucket_iterator, begin, end, value)
	function fill(BucketIndex, First, Last, Val) {
		var MyList = get(BucketIndex)
		MyList.fill(First, Last, Val)
	}

	///@function rotate(bucket_iterator, begin, middle, end)
	function rotate(BucketIndex, First, Middle, Last) {
		var MyList = get(BucketIndex)
		return MyList.rotate(First, Middle, Last)
	}

	///@function reverse(bucket_iterator, begin, end)
	function reverse(BucketIndex, First, Last) {
		var MyList = get(BucketIndex)
		MyList.reverse(First, Last)
	}

	///@function transform(bucket_iterator, begin, end, output, predicate)
	function transform(BucketIndex, First, Last, Output, Pred) {
		var pred = method(other, Pred)
		var MyList = get(BucketIndex)
		return MyList.transform(First, Last, Output, pred)
	}

	///@function min_element(bucket_iterator, begin, end, [comparator])
	function min_element(BucketIndex, First, Last, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.min_element(First, Last, Comparator)
	}

	///@function max_element(bucket_iterator, begin, end, [comparator])
	function max_element(BucketIndex, First, Last, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.max_element(First, Last, Comparator)
	}

	///@function lower_bound(bucket_iterator, begin, end, value, [comparator])
	function lower_bound(BucketIndex, First, Last, Val, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.lower_bound(First, Last, Val, Comparator)
	}

	///@function upper_bound(bucket_iterator, begin, end, value, [comparator])
	function upper_bound(BucketIndex, First, Last, Val, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.lower_bound(First, Last, Val, Comparator)
	}

	///@function binary_search(bucket_iterator, begin, end, value, [comparator])
	function binary_search(BucketIndex, First, Last, Val, Comparator) {
		var MyList = get(BucketIndex)
		return MyList.binary_search(First, Last, Val, Comparator)
	}

	///@function sort(bucket_iterator, begin, end, [comparator])
	function sort(BucketIndex, First, Last, Comparator) {
		var MyList = get(BucketIndex)
		MyList.sort(First, Last, Comparator)
	}

	///@function stable_sort(bucket_iterator, begin, end, [comparator])
	function stable_sort(BucketIndex, First, Last, Comparator) {
		var MyList = get(BucketIndex)
		MyList.stable_sort(First, Last, Comparator)
	}

	///@function __cash(key)
	function __cash(K) {
		if is_undefined(ds_list_find_value(key_memory, K)) {
			key_memory.push_back(K)
		}
	}

	///@function __try_decash(key)
	function __try_decash(K) {
		if 0 < key_memory.size() {
			key_memory.remove(key_memory.ibegin(), key_memory.iend(), K)
			return true
		}
		return false
	}

	function destroy() {
		var Begin = ibegin()
		var End = iend()
		if 0 < End {
			for (var It = Begin; It != End; ++It) {
				var TempList = get(It)
				TempList.destroy()
				delete TempList
			}
			ds_map_clear(raw)
			key_memory.destroy()
			delete key_memory
		}
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
