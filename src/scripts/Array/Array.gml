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
	static empty = function() { return !modified }

	///@function clear()
	static clear = function() { _Under_reserve(inner_size) }

	///@function at(index)
	static at = function(Index) {if !valid(Index) return undefined; return raw[Index] }

	///@function valid(index)
	static valid = function(Index) { return bool(0 <= Index and Index < inner_size) }

	///@function front()
	static front = function() { return at(0) }

	///@function back()
	static back = function() { return at(inner_size - 1) }

	///@function first()
	static first = function() { return Iterator(0) }

	///@function last()
	static last = function() { return Iterator(inner_size) }

	//////@function set_at(index, value)
	static set_at = function(Index, Value) {
		modified = true
		raw[Index] = Value
		return self
	}

	///@function location(value)
	static location = function(Value) { return find(first(), last(), Value) }

	///@function contains(value)
	static contains = function(Value) { return (modified and !is_undefined(location(Value))) }

	///@function destroy()
	static destroy = function() { raw = 0; gc_collect() }

	static type = Array
	static iterator_type = Random_iterator
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = set_at

	///@function (index)
	static _Under_iterator_get = at

	///@function (value)
	static _Under_iterator_add = function(Value) {
		if inner_size <= inner_index
			throw "Cannot add more values into the Array."
		set_at(inner_index, Value)
		inner_index++
	}

	///@function (index, value)
	static _Under_iterator_insert = set_at

	///@function (index)
	static _Under_iterator_next = function(Index) { return Index + 1 }

	///@function (index)
	static _Under_iterator_prev = function(Index) { return Index - 1 }

	///@function 
	static _Under_reserve = function(Size) {
		raw = 0
		inner_index = 0
		inner_size = Size
		modified = false
		raw = array_create(Size, undefined)
	}

	raw = -1
	inner_size = 0
	inner_index = -1
	modified = false
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				_Under_reserve(array_length(Item))
				array_copy(raw, 0, Item, 0, inner_size)
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				_Under_reserve(ds_list_size(Item))
				for (var i = 0; i < inner_size; ++i) set_at(i, Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				_Under_reserve(Item.size())
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				_Under_reserve(1)
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
			_Under_reserve(argument_count)
			for (var i = 0; i < argument_count; ++i) set_at(i, argument[i])
		}
	}
}
