/*
	Constructors:
		Priority_Queue()
		Priority_Queue(Arg)
		Priority_Queue(Arg0, Arg1, ...)
		Priority_Queue(Builtin-Array)
		Priority_Queue(Builtin-List)
		Priority_Queue(Container)
		Priority_Queue(Iterator-Begin, Iterator-End)

	Initialize:
		new Priority_Queue()

	Usage:
		AI_Target_Filter = new Priority_Queue()
		AI_Target_Filter.set_key_compare(function(Target, Other) {
			return (Target.hp < Other.hp)
		})

		var weakest = AI_Target_Filter.top()
*/
function Priority_Queue(): Heap_Tree() constructor {
	///@function push(value)
	static push = function(Value) { return insert(Value) }

	type = Priority_Queue

	// ** Assigning **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) insert(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < inner_size; ++i) insert(Item[| i])
			} else if is_struct(Item) and is_iterable(Item) {
				// (*) Container
				foreach(Item.first(), Item.last(), insert)
			} else {
				// (*) Arg
				insert(Item)
			}
		} else {
			// (*) Iterator-Begin, Iterator-End
			if argument_count == 2 {
				if is_struct(argument[0]) and is_iterator(argument[0])
				and is_struct(argument[1]) and is_iterator(argument[1]) {
					foreach(argument[0], argument[1], insert)
					exit
				}
			}
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) insert(argument[i])
		}
	}
}
