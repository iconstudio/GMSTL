randomize()

test_predicate = function(Val) {return Val < 10}
test1 = new Array(4, 2, 8, 13, 11, 9)
test2 = new Array(3, 3.5, 26, 7, 10, 15, 5, 4.5)
// 14개

test_sum = new List()
show_debug_message("\nThe First Array")
test1.merge_sort(test1.ibegin(), test1.iend())
test1.foreach(test1.ibegin(), test1.iend(), show_debug_message)
show_debug_message("Is sorted: " + string(test1.is_sorted(test1.ibegin(), test1.iend())))
show_debug_message("bsearch(11): " + string(test1.binary_search(test1.ibegin(), test1.iend(), 11)))

show_debug_message("\nThe Second Array")
test2.merge_sort(test2.ibegin(), test2.iend())
test2.foreach(test2.ibegin(), test2.iend(), show_debug_message)
show_debug_message("Is sorted: " + string(test2.is_sorted(test2.ibegin(), test2.iend())))
show_debug_message("bsearch(2): " + string(test2.binary_search(test2.ibegin(), test2.iend(), 2)))

show_debug_message("\nThe Summary List")
test_sum.merge(test1, test1.ibegin(), test1.iend(), test2, test2.ibegin(), test2.iend(), test_sum.ibegin())
test_sum.foreach(test_sum.ibegin(), test_sum.iend(), show_debug_message)

show_debug_message("\n")
//test.partition(test.ibegin(), test.iend(), test_predicate)
//var part_point = test.nth_element(test.ibegin(), test.ibegin() + 3, test.iend())
//var is_parted = test.is_partitioned(test.ibegin(), test.iend(), rpred)
//show_debug_message("Parted: " + string(part_point))
//test_sum.shuffle(test_sum.ibegin(), test_sum.iend())
//test_sum.foreach(test_sum.ibegin(), test_sum.iend(), show_debug_message)

var count_dem = test_sum.count_if(test_sum.ibegin(), test_sum.iend(), function(Val) {
	return frac(Val) != 0
})
show_debug_message("Count of Demical: " + string(count_dem))


