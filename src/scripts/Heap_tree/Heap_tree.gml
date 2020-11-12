/*
	Constructors:
		Heap_tree()
		Heap_tree(Arg)
		Heap_tree(Arg0, Arg1, ...)
		Heap_tree(Builtin-Array)
		Heap_tree(Builtin-List)
		Heap_tree(Container)
		Heap_tree(Iterator-Begin, Iterator-End)

	Initialize:
		new Heap_tree()

*/
function Heap_tree(): List() constructor {
#region public
	///@function top()
	static top = function() { return front() }

	///@function tail()
	static tail = function() { return back() }

	///@function insert(value)
	static insert = function(Value) {
		if 0 == size() {
			push_back(Value)
			return 0
		}

		var Index = size(), Parent = find_parent(Index)
		while 0 < Index and key_comparator(Value, at(Parent)) {
			set_at(Index, at(Parent))
			Index = Parent
			Parent = find_parent(Parent)
		}
		set_at(Index, Value)
		return Parent
	}

	///@function pop_front()
	static pop_front = function() { // overwrite
		var Size = size()
		if Size == 0 {
			return undefined
		} else if Size == 1 {
			return pop_back()
		} else if Size == 2 {
			var Result = at(0)
			set_at(0, at(1))
			pop_back()
			return Result
		}

		var Index = 0, Left = left(Index), Right = right(Index), Minimum, MinPosition
		var HeadValue = at(0), LastValue = pop_back()
		set_at(0, LastValue)

		while Left < Size {
			Minimum = at(Left)
			MinPosition = Left

			if Right < Size and key_comparator(at(Right), Minimum) {
				Minimum = at(Right)
				MinPosition = Right
			}

			if at(Index) < Minimum
				break

			var Temp = at(Index)
			set_at(Index, at(MinPosition))
			set_at(MinPosition, Temp)

			Index = MinPosition
			Left = left(Index)
			Right = right(Index)
		}
		return HeadValue
	}

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_comparator = method(other, Func) }

	static type = Heap_tree
#endregion

#region private
	///@function 
	static left = function(Index) { return Index * 2 + 1 }

	///@function 
	static right = function(Index) { return Index * 2 + 2 }

	///@function 
	static find_parent = function(Index) { return floor((Index - 1) * 0.5) }

	///@function (index, value)
	static _Under_iterator_set = undefined

	///@function (index)
	static _Under_iterator_get = undefined

	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = undefined

	///@function (index)
	static _Under_iterator_prev = undefined

	key_comparator = compare_less
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) insert(Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				insert(Item)
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
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}
