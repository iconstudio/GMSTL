///@description Using this function to implement methods.
function Algorithm() {
	_Nth_val = 0
	_Nth_cmp = -1

	///@function erase(begin, [end])
	function erase(ItA, ItB) {
		if is_undefined(ItB) or ItA == ItB
			return __erase_one(ItA)
		else
			return __erase_range(ItA, ItB)
	}

	///@function assign(number, value) \ assign(source, begin, end)
  function assign() {
		var Output = 0
		if argument_count == 2 {
			Output = ibegin()
			repeat argument[0]
				set(Output++, argument[1])
		} else if argument_count == 3 {
			Output = ibegin()
			for (var It = argument[1]; It != argument[2]; ++It)
				set(Output++, argument[0].get(It))
		}
		return Output
	}

	///@function swap(iterator_1, iterator_2)
	function swap(ItA, ItB) {
		var Temp = get(ItA)
		set(ItA, get(ItB))
		set(ItB, Temp)
	}

	///@function check_all(begin, end, predicate)
	function check_all(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and !pred(Val)
				return false
			First++
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				return true
			First++
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				return false
			First++
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			pred(get(First))
			First++
		}
		return pred
	}

	///@function find(begin, end, value, [comparator])
	function find(First, Last, Val, Comparator) {
		var comp = select_argument(Comparator, comparator_equal)
		while First != Last {
			if comp(get(First), Val)
				return First
			First++
		}
		return Last
	}

	///@function find_if(begin, end, predicate)
	function find_if(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				return First
			First++
		}
		return Last
	}

	///@function count(begin, end, value)
	function count(First, Last, Val) {
		for (var it = First, result = 0; it != Last; ++it) {
			if get(it) == Val
				result++
		}
		return result
	}

	///@function count_if(begin, end, predicate)
	function count_if(First, Last, Pred) {
		var pred = method(other, Pred)
		for (var it = First, result = 0; it != Last; ++it) {
			var Val = get(it)
			if !is_undefined(Val) and pred(Val)
				result++
		}
		return result
	}

	///@function copy(begin, end, output)
	function copy(First, Last, Output) {
		while First != Last {
			set(Output++, get(First))
			First++
		}
		return Output
	}

	///@function copy_n(begin, number, output)
	function copy_n(First, Number, Output) {
		repeat Number {
			set(Output++, get(First++))
		}
		return Output
	}

	///@function copy_to(begin, end, destination, destination_begin)
	function copy_to(First, Last, Dst, DstBgn) {
		for (var it = First; it != Last; ++it) {
			Dst.set(DstBgn++, get(it))
		}
		return DstBgn
	}

	///@function copy_to_n(begin, number, destination, destination_begin)
	function copy_to_n(First, Number, Dst, DstBgn) {
		repeat Number {
			Dst.set(DstBgn++, get(First++))
		}
		return DstBgn
	}

	///@function copy_if(begin, end, output, predicate)
	function copy_if(First, Last, Output, Pred) {
		var pred = method(other, Pred), Val = 0
		while First != Last {
			Val = get(First)
			if !is_undefined(Val) and pred(Val)
				set(Output++, Val)
			First++
		}
		return Output
	}

	///@function replace(begin, end, old_value, new_value)
	function replace(First, Last, OldVal, NewVal) {
		while First != Last {
			if get(First) == OldVal
				set(First, NewVal)
			First++
		}
	}

	///@function replace_if(begin, end, predicate, new_value)
	function replace_if(First, Last, Pred, NewVal) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				set(First, NewVal)
			First++
		}
	}

	///@function replace_copy(begin, end, output, old_value, new_value)
	function replace_copy(First, Last, Output, OldVal, NewVal) {
		while First != Last {
			if get(First) == OldVal
				set(Output, NewVal)
			else
				set(Output, get(First))
			First++
			Output++
		}
		return Output
	}

	///@function replace_copy_to(begin, end, destination, destination_begin, old_value, new_value)
	function replace_copy_to(First, Last, Dst, DstBgn, OldVal, NewVal) {
		while First != Last {
			if get(First) == OldVal
				Dst.set(DstBgn++, NewVal)
			else
				Dst.set(DstBgn++, get(First))
			First++
		}
		return DstBgn
	}

	///@function remove(begin, end, [value])
	function remove(First, Last, Val) {
		for (var it = First, result = First; it != Last; ++it) {
			if get(it) == Val {
				erase(result)
			} else {
				result++
			}
		}
		return result
	}

	///@function remove_if(begin, end, predicate)
	function remove_if(First, Last, Pred) {
		var pred = method(other, Pred)
		for (var it = First, result = First, Val; it != Last; ++it) {
			Val = get(result)
			if !is_undefined(Val) and pred(get(result)) {
				erase(result)
			} else {
				result++
			}
		}
		return result
	}

	///@function swap_range(begin, end, output)
	function swap_range(First, Last, Output) {
		while First != Last {
	    swap(First, Output)

			First++
			Output++
	  }
	  return Output
	}

	///@function move(begin, end, output)
	function move(First, Last, Output) {
		while First != Last {
			//erase()
			set(Output, First)
			set(First, undefined)

			First++
			Output++
	  }
		return Output
	}

	///@function move_to(begin, end, destination, destination_begin)
	function move_to(First, Last, Dst, DstBgn) {
		copy_to(First, Last, Dst, DstBgn)
		remove(First, Last)
	}

	///@function fill(begin, end, value)
	function fill(First, Last, Val) {
		while First != Last {
			set(First, Val)
			First++
		}
	}

	///@function rotate(begin, middle, end)
	function rotate(First, Middle, Last) {
		var Next = Middle
	  while First != Next {
		  swap(First, Next)
			First++
			Next++

		  if Next == Last
				Next = Middle
		  else if First == Middle
				Middle = Next
		}
		return Next
	}

	///@function transform(begin, end, output, predicate)
	function transform(First, Last, Output, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			set(Output++, pred(get(First)))
			First++
		}
		return Output
	}

	///@function min_element(begin, end, [comparator])
	function min_element(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		if First == Last
			return Last

		var result = First
		while ++First != Last {
		  if comp(get(First), get(result))
		    result = First
		}
		return result
	}

	///@function max_element(begin, end, [comparator])
	function max_element(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		if First == Last
			return Last

		var result = First
		while ++First != Last {
		  if comp(get(result), get(First))
		    result = First
		}
		return result
	}

	///@function lower_bound(begin, end, value, [comparator])
	///@description THE ELEMENT SEQUENCE MUST HAVE BEEN SORTED OR AT LEAST GOT PARTITIONED WITH VALUE.
	function lower_bound(First, Last, Val, Comparator) { // return the first and largest element which less than value.
		var comp = select_argument(Comparator, comparator_less)
		var It, Step, count = iterator_distance(First, Last)
		while 0 < count {
		  It = First
			Step = count * 0.5
			iterator_advance(It, Step)

		  if comp(get(It), Val) {
		    First = ++It
		    count -= Step + 1
		  } else {
				count = Step
			}
		}
		return First
	}

	///@function upper_bound(begin, end, value, [comparator])
	///@description THE ELEMENT SEQUENCE MUST HAVE BEEN SORTED OR AT LEAST GOT PARTITIONED WITH VALUE.
	function upper_bound(First, Last, Val, Comparator) { // return a greater element to the value.
		var comp = select_argument(Comparator, comparator_less)
		var It, Step, count = iterator_distance(First, Last)
		while 0 < count {
		  It = First
			Step = count * 0.5
			iterator_advance(It, Step)

		  if !comp(Val, get(It)) {
		    First = ++It
		    count -= Step + 1
		  } else {
				count = Step
			}
		}
		return First
	}

	///@function binary_search(begin, end, value, [comparator])
	///@description THE ELEMENT SEQUENCE MUST HAVE BEEN SORTED OR AT LEAST GOT PARTITIONED WITH VALUE.
	function binary_search(First, Last, Val, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		First = lower_bound(First, Last, Val, comp)
		return (First != Last and !comp(Val, get(First)))
	}

	///@function sort(begin, end, [comparator])
	///@description quick sort
	function sort(First, Last, Comparator) {
		if Last <= 1
			exit

		var comp = select_argument(Comparator, comparator_less)
		var pivot = First
		for (var it = First + 1; it < First + Last; ++it) {
			if comp(get(it), get(pivot)) {
				var temp = get(it)
				set(it, get(pivot + 1))
				set(pivot + 1, get(pivot))
				set(pivot, temp)

				pivot++
			}
		}

		sort(First, pivot - First, comp)
		if pivot < First + Last
			sort(pivot + 1, Last - (pivot - First) - 1, comp)
	}

	///@function stable_sort(begin, end, [comparator])
	///@description selection sort
	function stable_sort(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		while First != Last {
		  var selection = min_element(First, Last, comp)
		  swap(selection, First)
			First++
		}
	}

	///@function insertion_sort(begin, end, [comparator])
	function insertion_sort(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)

		First++
		while First != Last {
			var Value = get(First)
			for(var It = First - 1; 0 <= It and comp(Value, get(It)); --It) {
		    set(It + 1, get(It))
		  }
			set(It + 1, Value)

			First++
		}
	}

	///@function merge_sort(begin, end, [comparator])
	function merge_sort(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		var Dist = iterator_distance(First, Last)
	  if Dist <= 1
			exit

		var Middle = iterator_advance(First, Dist * 0.5)
	  merge_sort(First, Middle, comp)
	  merge_sort(Middle, Last, comp)
	  inplace_merge(First, Middle, Last, comp)
	}

/*
template <class Iter, class T>
void nth_element(Iter first, Iter nth, Iter last) {
  while (last - first > 3) {
    Iter cut =
      unguarded_partition(first, last,
                          T(median(*first,
                                   *(first + (last - first)/2),
                                   *(last - 1))));
    if (cut <= nth)
      first = cut;
    else 
      last = cut;
  }
  insertion_sort(first, last);
}
*/

	///@function nth_element(begin, nth, end, [comparator])
	function nth_element(First, Nth, Last, Comparator) {
		if First == Last or Nth == Last
			exit

		_Nth_val = get(Nth)
		_Nth_cmp = select_argument(Comparator, comparator_less)
		var pred = function(Val) {
			return !is_undefined(Val) and _Nth_cmp(_Nth_val, Val)
		}

		while First != Last { // partition
		  while pred(get(First)) {
		    ++First
		    if First == Last
					return First
		  }

		  do {
		    --Last
		    if First == Last
					return First
		  } until pred(get(Last))

		  swap(First, Last)
		  First++
		}
	}

	///@function is_sorted(begin, end, [comparator])
	function is_sorted(First, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		if First == Last
			return true

		var Next = First
		while ++Next != Last {
		  if comp(get(Next), get(First))
		    return false
		  First++
		}
		return true
	}

	///@function partition(begin, end, predicate)
	function partition(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
		  while !is_undefined(Val) and pred(Val) {
		    ++First
		    if First == Last
					return First
				Val = get(First)
		  }

		  do {
		    --Last
		    if First == Last
					return First
				Val = get(Last)
		  } until !is_undefined(Val) and pred(Val)

		  swap(First, Last)
		  First++
		}
		return First
	}

	///@function is_partitioned(begin, end, predicate)
	function is_partitioned(First, Last, Pred) {
		var Val = get(First)
		while First != Last and !is_undefined(Val) and Pred(Val) {
			Val = get(++First)
		}

		while First != Last {
		  if !is_undefined(Val) and Pred(Val)
				return false
		  Val = get(++First)
		}
		return true
	}

	///@function merge(source_1, 1_begin, 1_end, source_2, 2_begin, 2_end, output, [comparator])
	function merge(Source_1, Src1_Begin, Src1_End, Source_2, Src2_Begin, Src2_End, Output, Comparator) {
		var comp = select_argument(Comparator, comparator_less)
		while true {
		  if Src1_Begin == Src1_End
				return Source_2.copy_to(Src2_Begin, Src2_End, self, Output)

			if Src2_Begin == Src2_End
				return Source_1.copy_to(Src1_Begin, Src1_End, self, Output)

		  if comp(Source_2.get(Src2_Begin), Source_1.get(Src1_Begin))
				set(Output, Source_2.get(Src2_Begin++)) // left
			else
				set(Output, Source_1.get(Src1_Begin++))
			//set(Output, comp(Source_2.get(Src2_Begin), Source_1.get(Src1_Begin)) ? Source_2.get(Src2_Begin++) : Source_1.get(Src1_Begin++))
			Output++
		}
		return Output
	}

	///@function inplace_merge(begin, middle, end, [comparator])
	function inplace_merge(First, Middle, Last, Comparator) {
		var comp = select_argument(Comparator, comparator_less)

		var Temp = duplicate()
		Temp.merge(self, First, Middle, self, Middle, Last, First, comp)
		Temp.copy_to(First, Last, self, First)
		delete Temp

		/*
		var Dist = iterator_distance(First, Last)
		var summary = duplicate()
		var summary_begin = summary.ibegin()
		summary.merge(self, First, Middle, self, Middle, Last, summary_begin, comp)

		for (var i = 0; i < Dist; ++i) {
			set(iterator_advance(First, i), summary.get(iterator_advance(summary_begin, i)))
		}
		delete summary
		*/
	}

	///@function shuffle(begin, end, [engine])
	function shuffle(First, Last, Engine) {
		var Urng = select_argument(Engine, irandom_range)
		var Dist = iterator_distance(First, Last)
		for (var i = Dist - 1; 0 < i; --i) {
	    swap(iterator_advance(First, i), iterator_advance(First, Urng(0, i)))
	  }
	}

	///@function random_shuffle(begin, end, [generator])
	function random_shuffle(First, Last, Generator) {
		var Gen = select_argument(Generator, irandom)
	  var Dist = iterator_distance(First, Last)
	  for (var i = Dist - 1; 0 < i; --i) {
	    swap(iterator_advance(First, i), iterator_advance(First, Gen(i + 1)))
	  }
	}
}

///@function iterator_distance(iterator_1, iterator_2)
function iterator_distance(ItA, ItB) {
	return abs(ItB - ItA)
}

///@function iterator_advance(iterator, distance)
function iterator_advance(It, Dist) {
	return It + floor(Dist)
}

///@function iterator_next(iterator)
function iterator_next(It) {
	return It + 1
}
