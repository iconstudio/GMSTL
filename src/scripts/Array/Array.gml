/*
	Constructors:
		Array()
		Array(Arg)
		Array(Arg0, Arg1, ...)
		Array(Builtin-Array)
		Array(Builtin-List)
		Array(Container)
		Array(Iterator-Begin, Iterator-End)

	Initialize:
		new Array()

	Usage:
		
*/
function Array(): Container() constructor {
	///@function size()
	static size = function() { return inner_size }

	///@function at(index)
	static at = function(Index) { return raw[Index] }

	///@function back()
	static back = function() { return at(inner_size - 1) }

	///@function front()
	static front = function() { return at(0) }

	///@function first()
	static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
	static last = function() { return (new iterator_type(self, size())).pure() }

	//////@function set(index, value)
	static set = function(Index, Value) {
		raw[Index] = Value
		return self
	}

	///@function destroy()
	static destroy = function() { raw = 0; gc_collect() }

	///@function allocate(size)
	static allocate = function(Size) {
		inner_size = Size
		raw = array_create(Size)
	}

	type = Array
	iterator_type = RandomIterator
	inner_size = 0

	// ** Assigning **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				allocate(array_length(Item))
				array_copy(raw, 0, Item, 0, inner_size)
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				allocate(ds_list_size(Item))
				for (var i = 0; i < inner_size; ++i) set(i, Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				allocate(Item.size())
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				allocate(1)
				set(0, Item)
			}
		} else {
			// (*) Iterator-Begin, Iterator-End
			if argument_count == 2 {
				if is_struct(argument[0]) and is_iterator(argument[0])
				and is_struct(argument[1]) and is_iterator(argument[1]) {
					assign(argument[0], argument[1])
					exit
				}
			}
			// (*) Arg0, Arg1, ...
			allocate(argument_count)
			for (var i = 0; i < argument_count; ++i) set(i, argument[i])
		}
	}
}
