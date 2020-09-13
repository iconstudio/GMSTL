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
	///@function first()
  function first() { return (new iterator_type(self, 0)).pure() }

	///@function last()
  function last() { return (new iterator_type(self, size())).pure() }

	///@function cfirst()
  function cfirst() { return (new const_iterator_type(self, 0)).pure() }

	///@function clast()
  function clast() { return (new const_iterator_type(self, size())).pure() }

	///@function set(index, value)
  function set(Index, Value) {
		raw[Index] = Value
		return self
	}

	///@function at(index)
  function at(Index) { return raw[Index] }

  ///@function back()
	function back() { return at(inner_size - 1) }

  ///@function front()
	function front() { return at(0) }

	///@function erase_index(index)
	function erase_index(Index) {
		var Value = at(Index)
		set(Index, undefined)
		return Value
	}

	///@function erase_one(iterator)
	function erase_one(It) {
		var Value = It.get()
		It.set(undefined)
		return Value
	}

	///@function size()
	function size() { return inner_size }

	///@function destroy()
	function destroy() { raw = 0 gc_collect() }

	///@function allocate(size)
	function allocate(Size) {
		inner_size = Size
		raw = array_create(Size)
	}

	type = Array
	iterator_type = RandomIterator
	const_iterator_type = ConstIterator
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
