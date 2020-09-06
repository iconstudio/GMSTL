/*
	Constructors:
		List()
		List(Arg)
		List(Builtin-Array)
		List(Builtin-List)
		List(Iterable-Container)
		List(Arg0, Arg1, ...)

	Initialize:
		new List;
		set_value_type(type)

	Usage:
		
*/
function List(): Container() constructor {
	Algorithm()
	type = List
	raw = ds_list_create()

	///@function ibegin()
  function ibegin() { return 0 }

	///@function iend()
  function iend() { return size() }

	///@function set(iterator, value)
  function set(It, Val) { 
		ds_list_set(raw, It, Val)
		return self
	}

	///@function get(iterator)
  function get(It) {
		if is_nan(It)
			throw "An error occured when trying to acquire a value from the list!"
		return raw[| It]
	}

	///@function at(index)
  function at(i) { return ds_list_find_value(raw, i) }

	///@function insert(iterator, value)
  function insert(It, Val) {
		ds_list_insert(raw, It, Val)
		return It
	}

	///@function push_back(value)
	function push_back(Val) { ds_list_add(raw, Val) }

	///@function push_front(value)
	function push_front(Val) { insert(ibegin(), Val) }

	///@function emplace_back(tuple)
	function emplace_back(Params) { push_back(construct(Params)) }

	///@function emplace_front(tuple)
	function emplace_front(Params) { push_front(construct(Params)) }

	///@function pop_back()
	function pop_back() { return erase(iend() - 1) }

	///@function pop_front()
	function pop_front() { return erase(ibegin()) }

	///@function back()
  function back() {
		var sz = size()
		if 0 < sz
			return at(sz - 1)
		else
			return undefined
	}

	///@function front()
  function front() { 
		if 0 < size() 
			return at(0)
		else
			return undefined
	}

	///@function mark_list(index)
  function mark_list(i) { ds_list_mark_as_list(raw, i) }

	///@function mark_map(index)
  function mark_map(i) { ds_list_mark_as_map(raw, i) }

	///@function size()
	function size() { return ds_list_size(raw) }

	///@function empty()
	function empty() { return ds_list_empty(raw) }

	///@function clear()
	function clear() { ds_list_clear(raw) }

	///@function resize(size, [value_fill])
	function resize(Size, Fv) {
		var osz = size()
		if 0 < Size and Size != osz {
			if Size < osz {
				while size() != Size
					pop_back()
			} else {
				var fv = select_argument(Fv, (is_undefined(value_type) ? 0 : undefined))
				while size() != Size
					push_back(fv)
			}
			return true
		}
		return false
	}

	///@function shuffle_builtin()
	///@description Fast
  function shuffle_builtin() { ds_list_shuffle(raw) }

	///@function sort_builtin(ascending)
	///@description Fast
  function sort_builtin(Ascending) { ds_list_sort(raw, Ascending) }

	///@function __erase_one(iterator)
	function __erase_one(It) {
		var Temp = get(It)
		ds_list_delete(raw, It)
		return Temp
	}

	///@function __erase_range(begin, end)
	function __erase_range(First, Last) {
		var Dist = iterator_distance(First, Last)
		var Temp = array_create(Dist, undefined)
		var It = 0
		repeat Dist {
			Dist[It++] = get(First)
			ds_list_delete(raw, First)
		}
		return Temp
	}

	///@function read(data_string)
	function read(Str) {
		ds_list_read(raw, Str)
	}

	function write() {
		return ds_list_write(raw)
	}

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				var First = ibegin()
				for (var It = Item.ibegin(); It != Item.iend(); ++It) {
					if It == iend()
						break
					set(First++, Item.get(It))
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				var First = ibegin()
				for (var i = 0; i < array_length(Item); ++i) {
					set(First++, Item[i])
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				ds_list_copy(raw, Item)
			} else {
				// (*) Arg
				push_back(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) {
				push_back(argument[i])
			}
		}
	}
}
