/*
	Constructors:
		Priority_queue()
		Priority_queue(Arg)
		Priority_queue(Arg0, Arg1, ...)
		Priority_queue(Builtin-Array)
		Priority_queue(Builtin-List)
		Priority_queue(Container)
		Priority_queue(Iterator-Begin, Iterator-End)

	Initialize:
		new Priority_queue()

	Usage:
		AI_Target_Filter = new Priority_queue()
		AI_Target_Filter.set_key_compare(function(Target, Other) {
			return (Target.hp < Other.hp)
		})

		var weakest = AI_Target_Filter.top()

*/
function Priority_queue(): Heap_tree() constructor {
#region public
	///@function push(value)
	static push = insert

	///@function push_back(value)
	static push_back = insert

	static type = Priority_queue
	static is_iterable = false
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = undefined

	///@function (index)
	static _Under_iterator_get = undefined

	///@function function(value)
	static _Under_iterator_add = push

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = undefined

	///@function (index)
	static _Under_iterator_prev = undefined
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
			} else if Item.is_iterable {
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
