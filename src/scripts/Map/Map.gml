/*
	Constructors:
		Map()
		Map(Arg)
		Map(Paired-Container)
		Map(Builtin-Paired-Array)
		Map(Builtin-Paired-List)
		Map(Builtin-Map)
		Map(Arg0, Arg1, ...)

	Initialize:
		new Map()

	Usage:
		To Iterate values:
			for (var It = Container.first(); It.not_equals(Container.last()); It.go_next()) {
				myfunc(It.get())
			}
		
*/
///@function Map_node(storage)
function Map_node(Storage): RBTree_node(Storage) constructor {
	///@function set(value)
	static set = function(Key) { data[0] = Key; return self }

	///@function get()
	static get = function() { return data }

	///@function extract()
	static extract = function() { return data[0] }

	data = array_create(2, undefined)

	static type = Map_node
}

#macro Dictionary Map
function Map(): RedBlack_tree() constructor {
#region public
	///@function at(index)
	static at = function(Key) {
		var Where = first_of(Key)
		if !is_undefined(Where)
			return Where.data[1]
		else
			return undefined
	}

	//////@function set_at(index, value)
	static set_at = function(Key, Value) {
		var Where = first_of(Key)
		if !is_undefined(Where) {
			Where.data[1] = Value
		} else {
			var Node = _Under_insert_and_fix(node_head, Key)
			Node.data[1] = Value
		}
		return self
	}
 
	///@function insert(value)
	static insert = function(Pair) {
		var Key = Pair[0], Value = Pair[1]
		var Where = first_of(Key)
		if !is_undefined(Where) {
			Where.data[1] = Value
			return Iterator(Where)
		} else {
			var Node = _Under_insert_and_fix(node_head, Key)
			Node.data[1] = Value
			return Iterator(Node)
		}
	}

	///@function insert_at(index, value)
	static insert_at = function(Hint, Pair) {
		var Key = Pair[0], Value = Pair[1]
		var Where = first_of(Hint)
		if !is_undefined(Where) {
			var Node = _Under_insert_and_fix(Where, Key)
			Node.data[1] = Value
			return Iterator(Node)
		} else {
			return undefined
		}
	}

	///@function erase_at(data)
	static erase_at = function(Key) {
		var Result = undefined, Where = first_of(Key)
		if !is_undefined(Where) {
			Result = Iterator(Where.node_next)
			_Under_erase_and_fix(Where)
		}
		return Result
	}

	///@function key_swap_first_of(key_1, key_2)
	static key_swap_first_of = function(Key1, Key2) {
		var Where1 = first_of(Key1), Where2 = first_of(Key2)
		if !is_undefined(Where1) and !is_undefined(Where2) {
			var Temp = Where1.value
			Where1.value = Where2.value
			Where2.value = Temp
		}
	}

	///@function key_swap(key_1, key_2)
	static key_swap = key_swap_first_of

	///@function iter_swap(iterator_1, iterator_2)
	static iter_swap = function(Iter1, Iter2) {
		if Iter1.storage == self and Iter2.storage == self {
			var Temp = Iter1.value
			Iter1.value = Iter2.value
			Iter2.value = Temp
		}
	}

	///@function read(data_string)
	static read = function(Str) {
		
	}

	///@function write()
	static write = function() {
		
	}

	static type = Map
	static value_type = Map_node
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = function(Node, Value) { return Node.set(Value); return self }

	///@function (index)
	static _Under_iterator_get = function(Node) { return Node.data }

	///@function (value)
	static _Under_iterator_add = insert

	///@function (index, value)
	static _Under_iterator_insert = insert_at

	static key_inquire_comparator = compare_complex_less
#endregion

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Paired-Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in Paired-List
				for (var i = 0; i < ds_list_size(Item); ++i) insert(Item[| i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_map) {
				// (*) Built-in Map
				var Size = ds_map_size(Item)
				if 0 < Size {
					var MIt = ds_map_find_first(Item)
					while true {
						insert(MIt, ds_map_find_value(Item, MIt))
						MIt = ds_map_find_next(Item, MIt)
						if is_undefined(MIt)
							break
					}
				}
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Paired-Container
				foreach(Item.first(), Item.last(), insert)
			} else {
				// (*) Arg
				insert(Item)
			}
		} else {
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}
