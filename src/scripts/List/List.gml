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

	Usage:
		
*/
function List(): Container() constructor {
	///@function size()
	static size = function() { return ds_list_size(raw) }

	///@function empty()
	static empty = function() { return ds_list_empty(raw) }

	///@function at(index)
  static at = function(Index) { return ds_list_find_value(raw, Index) }

	///@function seek(value)
  static seek = function(Value) { return ds_list_find_index(raw, Value) }

	///@function back()
	static back = function() { return at(size() - 1) }

	///@function front()
	static front = function() { return at(0) }

	///@function first()
  static first = function() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  static last = function() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  static cfirst = function() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  static clast = function() { return (new const_iterator_type(self, size())).pure() }

	//////@function set(index, value)
  static set = function(Index, Value) { ds_list_set(raw, Index, Value) return self }

	//////@function index_insert(index, value)
  static index_insert = function(Index, Value) { ds_list_insert(raw, Index, Value) }

	///@function push_back(value)
	static push_back = function(Value) { ds_list_add(raw, Value) }

	///@function push_front(value)
	static push_front = function(Value) { index_insert(0, Value) }

	///@function erase_at(index)
	static erase_at = function(Index) {
		var Value = at(Index)
		ds_list_delete(raw, Index)
		return Value
	}

	///@function pop_back()
	static pop_back = function() { return erase_at(size() - 1) }

	///@function pop_front()
	static pop_front = function() { return erase_at(0) }

	///@function clear()
	static clear = function() { ds_list_clear(raw) }

	///@function sort_builtin(ascending)
  function sort_builtin(Ascending) { ds_list_sort(raw, Ascending) }

	///@function shuffle_builtin()
  function shuffle_builtin() { ds_list_shuffle(raw) }

	///@function mark_list(index)
  static mark_list = function(Index) { ds_list_mark_as_list(raw, Index) }

	///@function mark_map(index)
  static mark_map = function(Index) { ds_list_mark_as_map(raw, Index) }

	///@function is_list(index)
  static is_list = function(Index) { return ds_list_is_list(raw, Index) }

	///@function is_map(index)
  static is_map = function(Index) { return ds_list_is_map(raw, Index) }

	///@function read(data_string)
	static read = function(Str) { ds_list_read(raw, Str) }

	///@function write()
	static write = function() { return ds_list_write(raw) }

	///@function destroy()
	static destroy = function() { ds_list_destroy(raw); gc_collect() }

	raw = ds_list_create()
	type = List
	iterator_type = RandomIterator
	const_iterator_type = ConstIterator
	clear() // To avoid the 0-populate-value problem.

	// ** Assigning **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push_back(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < inner_size; ++i) push_back(Item[| i])
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
