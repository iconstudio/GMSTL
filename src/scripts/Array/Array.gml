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
	
*/
function Array(): Container() constructor {
#region public
	///@function size()
	static size = function() { return inner_size }

	///@function empty()
	static empty = function() { return bool(inner_size == 0) }

	///@function valid(Index)
	static valid = function(Index) { return bool(0 <= Index and Index < inner_size) }

	///@function at(index)
	static at = function(Index) { if !valid(Index) return undefined; return raw[Index] }

	///@function front()
	static front = function() { return at(0) }

	///@function back()
	static back = function() { return at(inner_size - 1) }

	///@function first()
	static first = function() { return Iterator(0) }

	///@function last()
	static last = function() { return Iterator(inner_size) }

	//////@function set_at(index, value)
	static set_at = function(Index, Value) { raw[Index] = Value; return self }

	///@function assign(begin, end)
	static assign = function(First, Last) {
		First = check_iterator(First)

		var Output = 0
		while First.not_equals(Last) {
			set_at(Output++, First.get())
			First.go_next()
		}
	}

	///@function location(value)
	static location = function(Value) { return find(first(), last(), Value) }

	///@function contains(value)
	static contains = function(Value) { return !is_undefined(location(Value)) }

	///@function destroy()
	static destroy = function() { raw = 0; gc_collect() }

	static type = Array
	static iterator_type = Random_iterator
#endregion

#region private
	///@function 
	static underlying_iterator_set = function(Index, Value) { return set_at(Index, Value) }

	///@function 
	static underlying_iterator_get = function(Index) { return at(Index) }

	///@function 
	static underlying_iterator_next = function(Index) { return Index + 1 }

	///@function 
	static underlying_iterator_prev = function(Index) { return Index - 1 }

	///@function 
	static underlying_iterator_insert = undefined

	///@function
	static underlying_reserve = function(Size) {
		raw = 0
		inner_size = Size
		raw = array_create(Size)
	}

	raw = -1
	inner_size = 0
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				underlying_reserve(array_length(Item))
				array_copy(raw, 0, Item, 0, inner_size)
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				underlying_reserve(ds_list_size(Item))
				for (var i = 0; i < inner_size; ++i) set_at(i, Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				underlying_reserve(Item.size())
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				underlying_reserve(1)
				set_at(0, Item)
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
			underlying_reserve(argument_count)
			for (var i = 0; i < argument_count; ++i) set_at(i, argument[i])
		}
	}
}
