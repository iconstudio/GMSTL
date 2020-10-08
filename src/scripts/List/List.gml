/*
	Constructors:
		List()
		List(Arg)
		List(Arg0, Arg1, ...)
		List(Builtin-Array)
		List(Builtin-List)
		List(Container)
		List(Iterator-Begin, Iterator-End)

	Initialize:
		new List()

*/
function List(): Container() constructor {
#region public
	///@function size()
	static size = function() { return ds_list_size(raw) }

	///@function empty()
	static empty = function() { return ds_list_empty(raw) }

	///@function valid(index)
	static valid = function(Index) { return bool(0 <= Index and Index < size()) }

	///@function clear()
	static clear = function() { ds_list_clear(raw) }

	///@function at(index)
	static at = function(Index) { return ds_list_find_value(raw, Index) }

	///@function front()
	static front = function() { return at(0) }

	///@function back()
	static back = function() { return at(size() - 1) }

	///@function first()
	static first = function() { return Iterator(0) }

	///@function last()
	static last = function() { return Iterator(size()) }

	//////@function insert(value)
	static insert = function(Value) { var It = last(); ds_list_add(raw, Value); return It }

	//////@function set_at(index, value)
	static set_at = function(Index, Value) { ds_list_set(raw, Index, Value); return self }

	//////@function insert_at(index, value)
	static insert_at = function(Index, Value) { ds_list_insert(raw, Index, Value); return self }

	///@function push_front(value)
	static push_front = function(Value) { insert_at(0, Value); return self }

	///@function push_back(value)
	static push_back = function(Value) { ds_list_add(raw, Value); return self }

	///@function erase_at(index)
	static erase_at = function(Index) { var Result = at(Index); ds_list_delete(raw, Index); return Result }

	///@function pop_front()
	static pop_front = function() { var Result = at(0); erase_at(0); return Result }

	///@function pop_back()
	static pop_back = function() { var Result = at(size() - 1); erase_at(size() - 1); return Result }

	///@function location(value)
	static location = function(Value) {
		var Result = ds_list_find_index(raw, Value)
		if Result == -1
			return undefined
		else
			return Iterator(Result)
	}

	///@function contains(value)
	static contains = function(Value) { return !is_undefined(location(Value)) }

	///@function mark_list(index)
	static mark_list = function(Index) { ds_list_mark_as_list(raw, Index) }

	///@function mark_map(index)
	static mark_map = function(Index) { ds_list_mark_as_map(raw, Index) }

	///@function is_list(index)
	static is_list = function(Index) { return ds_list_is_list(raw, Index) }

	///@function is_map(index)
	static is_map = function(Index) { return ds_list_is_map(raw, Index) }

	///@function sort_builtin(ascending)
	static sort_builtin = function(Ascending) { ds_list_sort(raw, Ascending) }

	///@function shuffle_builtin()
	static shuffle_builtin = function() { ds_list_shuffle(raw) }

	///@function read(data_string)
	static read = function(Str) { ds_list_read(raw, Str) }

	///@function write()
	static write = function() { return ds_list_write(raw) }

	///@function destroy()
	static destroy = function() { ds_list_destroy(raw); gc_collect() }

	static type = List
	static iterator_type = Random_iterator
#endregion

#region private
	///@function function(index, value)
	static _Under_iterator_set = set_at

	///@function function(index)
	static _Under_iterator_get = at

	///@function function(value)
	static _Under_iterator_add = push_back

	///@function function(index, value)
	static _Under_iterator_insert = insert_at

	///@function function(index)
	static _Under_iterator_next = function(Index) { return Index + 1 }

	///@function function(index)
	static _Under_iterator_prev = function(Index) { return Index - 1 }

	raw = ds_list_create()
	clear() // To avoid the 0-populate-value problem.
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push_back(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) push_back(Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				push_back(Item)
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
			for (var i = 0; i < argument_count; ++i) push_back(argument[i])
		}
	}
}
