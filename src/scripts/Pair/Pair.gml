/*
	Constructors:
		Pair()
		Pair(Arg)
		Pair(Pair)
		Pair(Builtin-Array)
		Pair(Builtin-List)
		Pair(Iterable-Container)
		Pair(Arg0, Arg1, ...)

	Initialize:
		new Pair
		set_value_type(type)

	Usage:
		
*/
function Pair() {
	first = undefined
	second = undefined

	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]

			if is_struct(Item) {
				if is_iterable(Item) {
					// (*) Iterable-Container
					var Len = Item.size()
					if 0 < Len {
						first = Item.at(0)
						if 1 < Len
							second = Item.at(1)
					}
				} else if instanceof(Item) == "Pair" {
					// (*) Pair
					first = Item.first
					second = Item.second
				}
			} else if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i)
				var Len = array_length(Item)
				if 0 < Len {
					first = Item[0]
					if 1 < Len
						second = Item[1]
				}
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				var Len = ds_list_size(Item)
				if 0 < Len {
					first = Item[| 0]
					if 1 < Len
						second = Item[| 1]
				}
			} else {
				// (*) Arg
				first = Item
			}
		} else {
			// (*) Arg0, Arg1, ...
			first = argument[0]
			second = argument[1]
		}
	}
}

///@function make_pair(value_1, value_2)
function make_pair(Val0, Val1) {
	return new Pair(Val0, Val1)
}
