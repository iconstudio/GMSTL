///@function List([id] or [items...])
function List(Items) constructor {
	type = List
	raw = ds_list_create()
	Algorithm()

	function data() { return raw }

	function duplicate() { return new List(self) }

	///@function set(iterator, value)
  function set(It, Val) { 
		ds_list_set(raw, It, Val)
		return self
	}

	///@function get(iterator)
  function get(It) { return raw[| It] }

	///@function at(index)
  function at(i) { return ds_list_find_value(raw, i) }

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

	///@function ibegin()
  function ibegin() { return 0 }

	///@function iend()
  function iend() { return size() }

	///@function push_back(value)
	function push_back(Val) { ds_list_add(raw, Val) }

	///@function push_front(value)
	function push_front(Val) { insert(ibegin(), Val) }

	///@function insert(iterator, value)
  function insert(It, Val) {
		ds_list_insert(raw, It, Val)
		return It
	}

	///@function erase(iterator)
	function erase(It) { 
		var temp = get(It)
		ds_list_delete(raw, It)
		return temp
	}

	///@function pop_front()
	function pop_front() { return erase(ibegin()) }

	///@function pop_back()
	function pop_back() { return erase(iend() - 1) }

	///@function front()
  function front() { 
		if 0 < size() 
			return at(0)
		else
			return undefined
	}

	///@function back()
  function back() {
		var sz = size()
		if 0 < sz
			return at(sz - 1)
		else
			return undefined
	}

	///@function resize(size, [value_fill])
	function resize(Size, Fv) {
		var osz = size()
		if 0 < Size and Size != osz {
			if Size < osz {
				while size() != Size
					pop_back()
			} else {
				var fv = select_argument(Fv, 0)
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

	if 0 < argument_count and !is_undefined(argument[0]) {
		if argument_count == 1 and is_numeric(argument[0]) {
			var Item = argument[0]

			if ds_exists(Item, ds_type_list) {
				ds_list_copy(raw, Item)
			} else if is_struct(Item) {
				var First = ibegin()
				for (var It = Item.ibegin(); It != Item.iend(); ++It) {
					if It == iend()
						break
					set(First++, Item.get(It))
				}
			} else if is_array(Item) {
				var First = ibegin()
				for (var i = 0; i < array_length(Item); ++i) {
					if i == iend()
						break
					set(First++, Item[i])
				}
			} else {
				push_back(Item)
			}
		} else {
			for (var i = 0; i < argument_count; ++i) {
				push_back(argument[i])
			}
		}
	}
}
