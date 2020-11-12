/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Paired-Container)
		Multimap(Builtin-Paired-Array)
		Multimap(Builtin-Paired-List)
		Multimap(Builtin-Map)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap()

	Usage:
		To Iterate values:
			for (var It = Container.first(); It.not_equals(Container.last()); It.go_next()) {
				myfunc(It.get())
			}
		
*/

function Multimap(): Map() constructor {
#region public
	///@function insert(value)
	static insert = function(Pair) {
		var Key = Pair[0], Value = Pair[1]
		var Node = _Under_try_insert(node_pointer_head, Key)
		Node.set_value(Value)
		return Iterator(Node)
	}

	///@function key_swap(key_1, key_2)
	static key_swap = function(Key1, Key2) {
		var Where1 = first_of(Key1), Where2 = first_of(Key2)
		if !is_undefined(Where1) and !is_undefined(Where2) {
			var Temp = Where1.value
			Where1.value = Where2.value
			Where2.value = Temp
		}
	}

	is_multiple = true
	static type = Multimap
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
