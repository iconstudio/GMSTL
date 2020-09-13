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
	///@function first()
  function first() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  function last() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  function cfirst() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  function clast() { return (new const_iterator_type(self, size())).pure() }

	///@function set(index, value)
  function set(Index, Value) { ds_list_set(raw, Index, Value) return self }

	///@function index_insert(index, value)
  function index_insert(Index, Value) { ds_list_insert(raw, Index, Value) }

	///@function push_back(value)
	function push_back(Value) { ds_list_add(raw, Value) }

	///@function push_front(value)
	function push_front(Value) { index_insert(0, Value) }

	///@function at(index)
  function at(Index) { return ds_list_find_value(raw, Index) }

	///@function back()
	function back() { return at(size() - 1) }

	///@function front()
	function front() { return at(0) }

	///@function erase_index(index)
	function erase_index(Index) {
		var Value = at(Index)
		ds_list_delete(raw, Index)
		return Value
	}

	///@function erase_one(iterator)
	function erase_one(It) {
		var Value = It.get()
		ds_list_delete(raw, It)
		It.pointer--
		return Value
	}

	///@function pop_back()
	function pop_back() { return erase_index(size() - 1) }

	///@function pop_front()
	function pop_front() { return erase_index(0) }

	///@function mark_list(index)
  function mark_list(Index) { ds_list_mark_as_list(raw, Index) }

	///@function mark_map(index)
  function mark_map(Index) { ds_list_mark_as_map(raw, Index) }

	///@function is_list(index)
  function is_list(Index) { return ds_list_is_list(raw, Index) }

	///@function is_map(index)
  function is_map(Index) { return ds_list_is_map(raw, Index) }

	///@function size()
	function size() { return ds_list_size(raw) }

	///@function empty()
	function empty() { return ds_list_empty(raw) }

	///@function clear()
	function clear() { ds_list_clear(raw) }

	///@function sort_builtin(ascending)
  function sort_builtin(Ascending) { ds_list_sort(raw, Ascending) }

	///@function shuffle_builtin()
  function shuffle_builtin() { ds_list_shuffle(raw) }

	///@function read(data_string)
	function read(Str) { ds_list_read(raw, Str) }

	///@function write()
	function write() { return ds_list_write(raw) }

	///@function destroy()
	function destroy() { ds_list_destroy(raw) gc_collect() }

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
