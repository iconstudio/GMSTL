randomize()

///@function print(container)
function print(Cont) { foreach(Cont.first(), Cont.last(), show_debug_message) }

test1 = new List(4, 2, 8, 13, 11, 9) // 6
test2 = new Array(3, 3.5, 26, 7, 10, 15, 5, 4.5) // 8

test_sum = new List()
show_debug_message("\nThe First List")
test1.emplace_front(40)
sort(test1.first(), test1.last())
print(test1)
show_debug_message("Is sorted: " + string(is_sorted(test1.first(), test1.last())))
show_debug_message("bsearch(11): " + string(binary_search(test1.first(), test1.last(), 11)))

show_debug_message("\nThe Second Array")
stable_sort(test2.first(), test2.last())
print(test2)
show_debug_message("Is sorted: " + string(is_sorted(test2.first(), test2.last())))
show_debug_message("bsearch(2): " + string(binary_search(test2.first(), test2.last(), 2)))

show_debug_message("\nThe Summary List")
merge(test1.first(), test1.last(), test2.first(), test2.last(), test_sum.first())
print(test_sum)

var count_dem = count_if(test_sum.first(), test_sum.last(), function(Value) {
	return !is_undefined(Value) and frac(Value) != 0
})
show_debug_message("Count of Demical: " + string(count_dem))

show_debug_message("\nPartitions")
my_value = 3
test_predicate = function(Value) { // It can use its member fields.
	return (Value mod my_value == 0)
}
var part_point = partition(test_sum.first(), test_sum.last(), test_predicate)
var is_parted = is_partitioned(test_sum.first(), test_sum.last(), test_predicate)
print(test_sum)
show_debug_message("Is parted: " + string(is_parted))
show_debug_message("Parted on: " + string(part_point.get_index()))

var nth = 10
show_debug_message("\nNth Sorting (" + string(nth) + ")")
random_shuffle(test_sum.first(), test_sum.last())
var nth_interator = iterator_advance(test_sum.first(), nth)
var nth_value = nth_interator.get()
var nth_result = nth_element(test_sum.first(), nth_interator, test_sum.last())
show_debug_message("Rearranged On: " + string(nth_interator.get_index()))
show_debug_message("The Stand Value: " + string(nth_value))

var nth_result_iterator = iterator_advance(test_sum.first(), nth)
var nth_result_value = nth_result_iterator.get()
show_debug_message("The " + string(nth) + "th Iterator: " + string(nth_result_iterator.get_index()))
show_debug_message("The " + string(nth) + "th Value: " + string(nth_result_value))
print(test_sum)

show_debug_message("\nTransform a List into a Multimap")
// Transform into paired-container
transform(test_sum.first(), test_sum.last(), test_sum.first(), function (Value) {
	return [irandom(2), Value]
})
print(test_sum)

show_debug_message("\nMultimap")
test_multimap = new Multimap(test_sum)
/*
for (var KIt = test_multimap.first(); KIt != test_multimap.last(); ++KIt) {
	var TempKey = test_multimap.get_key(KIt)
	var TempList = test_multimap.get(KIt)
	show_debug_message("Values with key " + string(TempKey) + ": ")
	print(TempList)
}
