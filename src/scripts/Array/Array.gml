/*
	Usage:
		Array()
		Array(Arg)
		Array(Builtin-Array)
		Array(Builtin-List)
		Array(Container)
		Array(Arg0, Arg1, ...)

	Initialize:
		new Array;
		set_value_type(type);
*/
function Array(): Container() constructor {
	type = Array
	_size = 0

	///@function set(iterator, value)
  function set(It, Val) {
		raw[It] = Val
		return self
	}

	///@function get(iterator)
  function get(It) {
		return raw[It]
	}

	///@function at(index)
  function at(i) { return raw[i] }

	///@function size()
	function size() { return _size }

	///@function ibegin()
  function ibegin() { return 0 }

	///@function iend()
  function iend() { return _size }

	///@function front()
  function front() { return at(0) }

	///@function back()
  function back() { return at(_size - 1) }

	///@function allocate(size)
	function allocate(Size) {
		_size = Size
		raw = array_create(Size)
	}

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			 if is_struct(Item) {
				 // (*) Container
				allocate(Item.size())
				var First = 0
				for (var It = Item.ibegin(); It != Item.iend(); ++It) {
					set(First++, Item.get(It))
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				allocate(array_length(Item))
				array_copy(raw, 0, Item, 0, _size)
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				var Size = ds_list_size(Item)
				allocate(Size)
				for (var i = 0; i < Size; ++i) {
					set(i, ds_list_find_value(Item, i))
				}
			} else {
				// (*) Arg
				allocate(1)
				set(0, Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			allocate(argument_count)
			for (var i = 0; i < argument_count; ++i) {
				set(i, argument[i])
			}
		}
	}

	///@function __erase_one(iterator)
	function __erase_one(It) {
		var Temp = get(It)
		var NewPos = move(iterator_next(It), iend(), It)
		show_debug_message("!")
		//set(NewPos, undefined)
		//for (var CIt = It + 1; CIt != iend(); ++CIt) {
		//	set(It++, get(CIt))
		//}
		return Temp
	}

	///@function __erase_range(begin, end)
	function __erase_range(First, Last) {
		show_debug_message("?")
		//repeat iterator_distance(First, Last)
		//	ds_list_delete(raw, First)
		return First
	}
}