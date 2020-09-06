/*
	Constructors:
		Multimap()
		Multimap(Arg)
		Multimap(Multimap)
		Multimap(Builtin-PairedArray)
		Multimap(Builtin-PairedList)
		Multimap(Builtin-Map)
		Multimap(Builtin-PriorityQueue)
		Multimap(Iterable-PairedContainer)
		Multimap(Arg0, Arg1, ...)

	Initialize:
		new Multimap
		set_value_type(type)
		set_comparator(compare_function)

	Usage:
		To Iterate with keys:
			cash_keys()
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(at_cashed(It))

		To Iterate with values:
			cash_values()
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(get(It))
		
*/
function Priority_Queue(): Container() constructor {

}
