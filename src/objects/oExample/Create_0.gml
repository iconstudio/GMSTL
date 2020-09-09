randomize()

///@function print(container)
function print(Cont) {
	Cont.foreach(Cont.nbegin(), Cont.nend(), show_debug_message)	
}

test1 = new List(4, 2, 8, 13, 11, 9) // 6
test2 = new List(3, 3.5, 26, 7, 10, 15, 5, 4.5) // 8

test_sum = new List()
show_debug_message("\nThe First List")
test1.emplace_front(40)
test1.merge_sort(test1.nbegin(), test1.nend())
print(test1)
show_debug_message("Is sorted: " + string(test1.is_sorted(test1.nbegin(), test1.nend())))
show_debug_message("bsearch(11): " + string(test1.binary_search(test1.nbegin(), test1.nend(), 11)))

show_debug_message("\nThe Second Array")
test2.merge_sort(test2.nbegin(), test2.nend())
print(test2)
show_debug_message("Is sorted: " + string(test2.is_sorted(test2.nbegin(), test2.nend())))
show_debug_message("bsearch(2): " + string(test2.binary_search(test2.nbegin(), test2.nend(), 2)))

show_debug_message("\nThe Summary List")
test_sum.merge(test1, test1.nbegin(), test1.nend(), test2, test2.nbegin(), test2.nend(), test_sum.nbegin())
print(test_sum)

var count_dem = test2.count_if(test_sum.nbegin(), test_sum.nend(), function(Val) {
	return !is_undefined(Val) and frac(Val) != 0
})
show_debug_message("Count of Demical: " + string(count_dem))

show_debug_message("\nPartitions")
my_value = 3
test_predicate = function(Val) { // It can use its member fields.
	return (Val mod my_value == 0)
}
var part_point = test_sum.partition(test_sum.nbegin(), test_sum.nend(), test_predicate)
var is_parted = test_sum.is_partitioned(test_sum.nbegin(), test_sum.nend(), test_predicate)
print(test_sum)
show_debug_message("Is parted: " + string(is_parted))
show_debug_message("Parted on: " + string(part_point))

var nth = 10
show_debug_message("\nNth Sorting (" + string(nth) + ")")
test_sum.random_shuffle(test_sum.nbegin(), test_sum.nend())
var nth_interator = iterator_advance(test_sum.nbegin(), nth)
var nth_value = test_sum.get(nth_interator)
var nth_result = test_sum.nth_element(test_sum.nbegin(), nth_interator, test_sum.nend())
show_debug_message("Rearranged On: " + string(nth_interator))
show_debug_message("The Stand Value: " + string(nth_value))

var nth_result_iterator = iterator_advance(test_sum.nbegin(), nth)
var nth_result_value = test_sum.get(nth_result_iterator)
show_debug_message("The " + string(nth) + "th Iterator: " + string(nth_result_iterator))
show_debug_message("The " + string(nth) + "th Value: " + string(nth_result_value))
print(test_sum)

show_debug_message("\nTransform a List into a Multimap")
// Transform into paired-container
test_sum.transform(test_sum.nbegin(), test_sum.nend(), test_sum.nbegin(), function (Val) {
	return [irandom(2), Val]
})
print(test_sum)

show_debug_message("\nMultimap")
test_multimap = new Multimap(test_sum)
for (var KIt = test_multimap.nbegin(); KIt != test_multimap.nend(); ++KIt) {
	var TempKey = test_multimap.get_key(KIt)
	var TempList = test_multimap.get(KIt)
	show_debug_message("Values with key " + string(TempKey) + ": ")
	print(TempList)
}

test_grid = new Grid(5, 5)
