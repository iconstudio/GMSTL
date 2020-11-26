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
	///@function set_key(value)
	static set_key = function(Key) { data[0] = Key; return self }

	///@function set_value(value)
	static set_value = function(Value) { data[1] = Value; return self }

	///@function get_key()
	static get_key = function() { return data[0] }

	///@function get_value()
	static get_value = function() { return data[1] }

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
			return Where.get_value()
		else
			return undefined
	}

	//////@function set_at(index, value)
	static set_at = function(Key, Value) {
		var Where = first_of(Key)
		if !is_undefined(Where) {
			Where.set_value(Value)
		} else {
			var Node = _Under_try_insert(node_pointer_head, Key)
			Node.set_value(Value)
		}
		return self
	}
 
	///@function insert(value)
	static insert = function(Pair) {
		var Key = Pair[0], Value = Pair[1]
		var Where = first_of(Key)
		if !is_undefined(Where) {
			//if is_undefined(Value) throw "The value of " + string(Key) + " is undefined!\nNode: " + string(Where)
			Where.set_value(Value)
			return Iterator(Where)
		} else {
			var Node = _Under_try_insert(node_pointer_head, Key)
			Node.set_value(Value)
			return Iterator(Node)
		}
	}

	///@function insert_at(index, value)
	static insert_at = function(Hint, Pair) {
		var Key = Pair[0], Value = Pair[1]
		var Where = first_of(Hint)
		if !is_undefined(Where) {
			var Node = _Under_try_insert(Where, Key)
			Node.set_value(Value)
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
			_Under_try_erase(Where)
		}
		return Result
	}

	///@function key_swap_first_of(key_1, key_2)
	static key_swap_first_of = function(Key1, Key2) {
		var Where1 = first_of(Key1), Where2 = first_of(Key2)
		if !is_undefined(Where1) and !is_undefined(Where2) {
			var Temp = Where1.get_value()
			Where1.set_value(Where2.get_value())
			Where2.set_value(Temp)
		}
	}

	///@function key_swap(key_1, key_2)
	static key_swap = key_swap_first_of

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
	static _Under_iterator_set = function(Node, Value) { return Node.set_data(Value); return self }

	///@function (index)
	static _Under_iterator_get = function(Node) { return Node.get_data() }

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
			} else if Item.is_iterable {
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
