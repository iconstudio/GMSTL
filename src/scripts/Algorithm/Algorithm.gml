///@function assign(begin, end)
function assign(First, Last) {
	First = make_iterator(First)

	var Output = first()
	while First.not_equals(Last) {
		Output.set(First.get())
		First.go()
		Output.go()
	}
	return Output
}

///@function erase(begin, [end])
function erase(First, Last) {
	First = make_iterator(First)

	if argument_count == 1 {
		erase_one(First)
	} else if argument_count == 2 {
		var Result = First.duplicate()
		while First.not_equals(Last) {
			erase_one(First)
			First.go()
			Result.go() // last
		}
	}
	return Result
}

///@function check_all(begin, end, predicate)
function check_all(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		if !Pred(First.get())
			return false
		First.go()
	}
	return true
}

///@function check_any(begin, end, predicate)
function check_any(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		if Pred(First.get())
			return true
		First.go()
	}
	return false
}

///@function check_none(begin, end, predicate)
function check_none(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)
	
	while First.not_equals(Last) {
		if Pred(First.get())
			return false
		First.go()
	}
	return true
}

///@function foreach(begin, end, predicate)
function foreach(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)
	
	while First.not_equals(Last) {
		Pred(First.get())
		First.go()
	}
	return Pred
}

///@function find(begin, end, value, [comparator=compare_equal])
function find(First, Last, Value, Comparator) {
	First = make_const_iterator(First)

	var Compare = select_argument(Comparator, compare_equal)
	while First.not_equals(Last) {
		if Compare(First.get(), Value)
			return First
		First.go()
	}
	return Last
}

///@function find_if(begin, end, predicate)
function find_if(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		var Value = First.get()
		if !is_undefined(Value) and Pred(Value)
			return First
		First.go()
	}
	return Last
}

///@function count(begin, end, value)
function count(First, Last, Value) {
	First = make_const_iterator(First)

	var Result = 0
	while First.not_equals(Last) {
		if First.get() == Value
			Result++
		First.go()
	}
	return Result
}

///@function count_if(begin, end, predicate)
function count_if(First, Last, Pred) {
	First = make_const_iterator(First)
	Pred = method(other, Pred)

	var Result = 0
	while First.not_equals(Last) {
		if Pred(First.get())
			Result++
		First.go()
	}
	return Result
}

///@function swap(iterator_1, iterator_2)
function swap(ItA, ItB) {
	var Temp = ItA.get()
	ItA.set(ItB.get())
	ItB.set(Temp)
}

///@function swap_range(begin, end, output)
function swap_range(First, Last, Output) {
	First = make_iterator(First)
	Output = make_iterator(Output)

	while First.not_equals(Last) {
	  swap(First, Output)
		First.go()
		Output.go()
	}
	return Output
}

///@function copy(begin, end, output)
function copy(First, Last, Output) {
	First = make_iterator(First)
	Output = make_iterator(Output)

	while First.not_equals(Last) {
		Output.set(First.get())
		First.go()
		Output.go()
	}
	return Output
}

///@function copy_n(begin, number, output)
function copy_n(First, Number, Output) {
	First = make_iterator(First)
	Output = make_iterator(Output)

	repeat Number {
		Output.set(First.get())
		First.go()
		Output.go()
	}
	return Output
}

///@function copy_if(begin, end, output, predicate)
function copy_if(First, Last, Output, Pred) {
	First = make_iterator(First)
	Output = make_iterator(Output)
	Pred = method(other, Pred)

	var Value = 0
	while First.not_equals(Last) {
		Value = First.get()
		if !is_undefined(Value) and Pred(Value)
			Output.set(Value)
		First.go()
		Output.go()
	}
	return Output
}

///@function replace(begin, end, old_value, new_value)
function replace(First, Last, OldVal, NewVal) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		if First.get() == OldVal
			First.set(NewVal)
		First.go()
	}
}

///@function replace_if(begin, end, predicate, new_value)
function replace_if(First, Last, Pred, NewVal) {
	First = make_iterator(First)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		var Value = First.get()
		if !is_undefined(Value) and Pred(Value)
			First.set(NewVal)
		First.go()
	}
}

///@function replace_copy(begin, end, output, old_value, new_value)
function replace_copy(First, Last, Output, OldVal, NewVal) {
	First = make_iterator(First)
	Output = make_iterator(Output)

	while First.not_equals(Last) {
		var Value = First.get()
		if Value == OldVal
			Output.set(NewVal)
		else
			Output.set(Value)
		First.go()
		Output.go()
	}
	return Output
}

///@function remove(begin, end, value)
function remove(First, Last, Value) {
	First = make_iterator(First)

	var Result = First.duplicate()
	while First.not_equals(Last) {
		if First.get() == Value
			erase_one(Result)
		else
			Result.go()
		First.go()
	}
	return Result
}

///@function remove_if(begin, end, predicate)
function remove_if(First, Last, Pred) {
	First = make_iterator(First)
	Pred = method(other, Pred)

	var Result = First.duplicate()
	while First.not_equals(Last) {
		if Pred(First.get())
			erase_one(Result)
		else
			Result.go()
		First.go()
	}
	return Result
}

///@function move(begin, end, output)
function move(First, Last, Output) {
	First = make_iterator(First)
	Output = make_iterator(Output)

	while First.not_equals(Last) {
		Output.set(First.get())

		First.go()
		Output.go()
	}
	erase(First, Last)
	return Output
}

///@function fill(begin, end, value)
function fill(First, Last, Value) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		First.set(Value)
		First.go()
	}
}

///@function rotate(begin, middle, end)
function rotate(First, Middle, Last) {
	First = make_iterator(First)
	Middle = make_iterator(Middle)

	var Next = Middle // copied
	while First.equals(Next) {
		First.swap(Next)
		First.go()
		Next.go()

		if Next.equals(Last)
			Next = Middle
		else if First.equals(Middle)
			Middle = Next
	}
	return Middle
}

///@function reverse(begin, end)
function reverse(First, Last) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		Last.back()
		if First.equals(Last)
			break
	  First.swap(Last)
	  First.go()
	}
}

///@function transform(begin, end, output, unary_predicate)
function transform(First, Last, Output, Pred) {
	First = make_iterator(First)
	Output = make_iterator(Output)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		Output.set(Pred(First.get()))
		First.go()
		Output.go()
	}
	return Output
}

///@function transform_binary(begin, end, another_begin, output, binary_predicate)
function transform_binary(First, Last, PairFirst, Output, Pred) {
	First = make_iterator(First)
	PairFirst = make_iterator(PairFirst)
	Output = make_iterator(Output)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		Output.set(Pred(First.get(), PairFirst.get()))
		First.go()
		PairFirst.go()
		Output.go()
	}
	return Output
}

///@function min_element(begin, end, [comparator=compare_less])
function min_element(First, Last, Comparator) {
	if First.equals(Last)
		return Last

	var Result = First.duplicate()
	var Cursor = First.next()
	var Compare = select_argument(Comparator, compare_less)
	while Cursor.not_equals(Last) {
		if Compare(Cursor.get(), Result.get()) {
			delete Result
		  Result = Cursor.duplicate()
		}
		Cursor.go()
	}
	delete Cursor
	gc_collect()
	return Result
}

///@function max_element(begin, end, [comparator=compare_less])
function max_element(First, Last, Comparator) {
	if First.equals(Last)
		return Last

	var Result = First.duplicate()
	var Cursor = First.next()
	var Compare = select_argument(Comparator, compare_less)
	while Cursor.not_equals(Last) {
		if Compare(Result.get(), Cursor.get()) {
			delete Result
		  Result = Cursor.duplicate()
		}
		Cursor.go()
	}
	delete Cursor
	gc_collect()
	return Result
}

///@function lower_bound(begin, end, value, [comparator=compare_less])
function lower_bound(First, Last, Value, Comparator) { // return the first and largest element which less than value.
	First = make_iterator(First)

	var Compare = select_argument(Comparator, compare_less)
	var It, Step, count = First.distance(Last)
	while 0 < count {
		Step = count * 0.5
		It = iterator_advance(First, Step)

		if Compare(It.get(), Value) {
			It.go()
		  First = It
		  count -= Step + 1
		} else {
			count = Step
		}
	}
	return First
}

///@function upper_bound(begin, end, value, [comparator=compare_less])
function upper_bound(First, Last, Value, Comparator) { // return a greater element to the value.
	First = make_iterator(First)

	var Compare = select_argument(Comparator, compare_less)
	var It, Step, count = First.distance(Last)
	while 0 < count {
		Step = count * 0.5
		It = iterator_advance(First, Step)

		if !Compare(Value, It.get()) {
			It.go()
		  First = It
		  count -= Step + 1
		} else {
			count = Step
		}
	}
	return First
}

///@function binary_search(begin, end, value, [comparator=compare_less])
function binary_search(First, Last, Value, Comparator) {
	First = make_iterator(First)

	var Compare = select_argument(Comparator, compare_less)
	First = lower_bound(First, Last, Value, Compare)
	var FirstVal = First.get()
	return First.not_equals(Last) and !Compare(Value, FirstVal)
}

///@function sort(begin, end, [comparator])
///@description quick sort
function sort(First, Last, Comparator) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	if Last.index <= 1
		exit

	var Compare = select_argument(Comparator, compare_less)
	var Pivot = First.duplicate(), Pivot_Next, Value = 0
	for (var It = First.next(); It.index < First.index + Last.index; It.go()) {
		Value = It.get()
		if Compare(Value, Pivot.get()) {
			Pivot_Next = Pivot.next()

			It.set(Pivot_Next.get())
			Pivot_Next.set(Pivot.get())
			Pivot.set(Value)

			Pivot.go()
		}
	}
	delete It

	sort(First, Pivot.duplicate().subtract(First), Compare)
	if Pivot.index < First.index + Last.index
		sort(Pivot.next(), Last.subtract(Pivot.distance(First) + 1), Compare)
	delete Pivot
	delete Pivot_Next
	gc_collect()
}

///@function stable_sort(begin, end, [comparator=compare_less])
///@description selection sort
function stable_sort(First, Last, Comparator) {
	First = make_iterator(First)

	var Compare = select_argument(Comparator, compare_less)
	while First.not_equals(Last) {
		var selection = min_element(First, Last, Compare)
		selection.swap(First)
		First.go()
	}
}

///@function insertion_sort(begin, end, [comparator=compare_less])
function insertion_sort(First, Last, Comparator) {
	First = make_iterator(First).go()

	var Compare = select_argument(Comparator, compare_less)
	while First.not_equals(Last) {
		var Value = First.get()
		for(var It = First.previous(); 0 <= It.get_index() and Compare(Value, It.get()); It.back()) {
			It.next().set(It.get())
		}
		It.next().set(Value)

		First.go()
	}
}

///@function merge_sort(begin, end, [comparator=compare_less])
function merge_sort(First, Last, Comparator) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	var Dist = First.distance(Last)
	if Dist <= 1
		exit

	var Compare = select_argument(Comparator, compare_less)
	var Middle = iterator_advance(First, Dist * 0.5)
	merge_sort(First, Middle, Compare)
	merge_sort(Middle, Last, Compare)
	inplace_merge(First, Middle, Last, Compare)
}

///@function IMPLEMENTED FROM VS
///@description sort median of three elements to middle
function sort_median(First, Middle, Last, Comparator) {
	if Comparator(get(Middle), First.get()) {
		Middle.swap(First)
	}

	if Comparator(Last.get(), Middle.get()) { // swap middle and last, then test first again
		Last.swap(Middle)

		if Comparator(Middle.get(), First.get())
			Middle.swap(First)
	}
}

///@function IMPLEMENTED FROM VS
///@description sort median element to middle
function predict_median(First, Middle, Last, Comparator) {
	var _Count = iterator_distance(First, Last)
	if 40 < _Count { // Tukey's ninther
		var Step     = (_Count + 1) >> 3 // +1 can't overflow because range was made inclusive in caller
		var _Two_step = Step << 1 // note: intentionally discards low-order bit
		sort_median(First, First + Step, First + _Two_step, Comparator)
		sort_median(Middle - Step, Middle, Middle + Step, Comparator)
		sort_median(Last - _Two_step, Last - Step, Last, Comparator)
		sort_median(First + Step, Middle, Last - Step, Comparator)
	} else {
		sort_median(First, Middle, Last, Comparator)
	}
}

///@function IMPLEMENTED FROM VS
///@description partition [First, Last), using Comparator
function partition_by_median_guess(First, Last, Comparator) {
	var Middle = First + (iterator_distance(First, Last) >> 1) // shift for codegen (== * 0.5)
	predict_median(First, Middle, Last - 1, Comparator)

	var _Pfirst = Middle
	var _Plast  = _Pfirst + 1
	while First < _Pfirst && !Comparator(get(_Pfirst - 1), get(_Pfirst)) && !Comparator(get(_Pfirst), get(_Pfirst - 1)) {
		--_Pfirst
	}

	while _Plast < Last && !Comparator(get(_Plast), get(_Pfirst)) && !Comparator(get(_Pfirst), get(_Plast)) {
		++_Plast
	}

	var _Gfirst = _Plast
	var _Glast  = _Pfirst
	for (;;) { // partition
		for (; _Gfirst < Last; ++_Gfirst) {
			if Comparator(get(_Pfirst), get(_Gfirst)) {
			} else if Comparator(get(_Gfirst), get(_Pfirst)) {
				break
			} else if _Plast != _Gfirst {
				swap(_Plast, _Gfirst)
				_Plast++
			} else {
				_Plast++
			}
		}

		for (; First < _Glast; --_Glast) {
			if Comparator(get(_Glast - 1), get(_Pfirst)) {
			} else if Comparator(get(_Pfirst), get(_Glast - 1)) {
					break
			} else if --_Pfirst != _Glast - 1 {
					swap(_Pfirst, _Glast - 1)
			}
		}

		if _Glast == First and _Gfirst == Last {
			return [_Pfirst, _Plast]
		}

		if _Glast == First { // no room at bottom, rotate pivot upward
			if _Plast != _Gfirst {
					swap(_Pfirst, _Plast)
			}

			_Plast++
			_Pfirst.swap(_Gfirst)
			_PFirst.go()
			_GFirst.go()
		} else if _Gfirst == Last { // no room at top, rotate pivot downward
			if --_Glast != --_Pfirst {
					swap(_Glast, _Pfirst)
			}

			swap(_Pfirst, --_Plast)
		} else {
			swap(_Gfirst, --_Glast)
			_GFirst.go()
		}
	}
}

///@function nth_element(begin, nth, end, [comparator=compare_less])
function nth_element(First, Nth, Last, Comparator) {
	First = make_iterator(First)
	Nth = make_iterator(Nth)
	Last = make_iterator(Last)
	if First.equals(Last) or Nth.equals(Last)
		exit

	var Compare = select_argument(Comparator, compare_less)
	while 32 < First.distance(Last) { // divide and conquer, ordering partition containing Nth
		var Middle = partition_by_median_guess(First, Last, Compare)

		if Middle.index <= Nth.index {
			First = Middle
		} else if Middle.index <= Nth.index {
			exit
		} else {
			Last = Middle
		}
  }

  insertion_sort(First, Last, Compare)
}

///@function is_sorted(begin, end, [comparator=compare_less])
function is_sorted(First, Last, Comparator) {
	First = make_iterator(First)
	if First.equals(Last)
		return true

	var Compare = select_argument(Comparator, compare_less)
	var Next = First.next()
	while Next.not_equals(Last) {
		if Compare(Next.get(), First.get())
		  return false
		First.go()
		Next.go()
	}
	return true
}

///@function unguarded_partition(begin, end, pivot, [comparator=compare_less])
function unguarded_partition(First, Last, Pivot, Comparator) {
	First = make_iterator(First)
	Last = make_iterator(Last)

	var Compare = select_argument(Comparator, compare_less)
	while true {
	  while Compare(First.get(), Pivot.get())
			First.go()

	  Last.back()
	  while Compare(Pivot.get(), Last.get())
			Last.back()

	  if !(First.get_index() < Last.get_index())
			return First
	  First.swap(Last)
	  First.go()
	}
}

///@function partition(begin, end, predicate)
function partition(First, Last, Pred) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	Pred = method(other, Pred)

	while First.not_equals(Last) {
		var Value = First.get()
		while !is_undefined(Value) and Pred(Value) {
		  First.go()
		  if First.equals(Last)
				return First
			Value = First.get()
		}

		do {
		  Last.back()
		  if First.equals(Last)
				return First
			Value = Last.get()
		} until !is_undefined(Value) and Pred(Value)

		First.swap(Last)
		First.go()
	}
	return First
}

///@function is_partitioned(begin, end, predicate)
function is_partitioned(First, Last, Pred) {
	First = make_iterator(First)

	var Value = First.get()
	while First.not_equals(Last) and !is_undefined(Value) and Pred(Value) {
		First.go()
		Value = First.get()
	}

	while First.not_equals(Last) {
		if !is_undefined(Value) and Pred(Value)
			return false
		First.go()
		Value = First.get()
	}
	return true
}

///@function merge(begin, end, other_begin, other_end, output, [comparator=compare_less])
function merge(First, Last, OtherFirst, OtherLast, Output, Comparator) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	OtherFirst = make_iterator(OtherFirst)
	OtherLast = make_iterator(OtherLast)

	var Compare = select_argument(Comparator, compare_less)
	while true {
		if First.equals(Last)
			return copy(OtherFirst, OtherLast, Output)

		if OtherFirst.equals(OtherLast)
			return copy(First, Last, Output)

		var Src1_Val = First.get()
		var Src2_Val = OtherFirst.get()
		if Compare(Src2_Val, Src1_Val) {
			Output.set(Src2_Val)
			OtherFirst.go()
		} else {
			Output.set(Src1_Val)
			First.go()
		}

		Output.go()
	}
	return Output
}

///@function inplace_merge(begin, middle, end, [comparator=compare_less])
function inplace_merge(First, Middle, Last, Comparator) {
	First = make_iterator(First)
	Middle = make_iterator(Middle)
	Last = make_iterator(Last)

	var Compare = select_argument(Comparator, compare_less)
	var Temp = duplicate()
	Temp.merge(self, First, Middle, self, Middle, Last, First, Compare)
	copy(Temp.first(), Temp.last(), First)
	delete Temp
}

///@function shuffle(begin, end, [engine=irandom_range])
function shuffle(First, Last, Engine) {
	First = make_iterator(First)

	var Urng = select_argument(Engine, irandom_range)
	var Dist = iterator_distance(First, Last)
	for (var i = Dist - 1; 0 < i; --i) {
	  swap(iterator_advance(First, i), iterator_advance(First, Urng(0, i)))
	}
}

///@function random_shuffle(begin, end, [generator=irandom])
function random_shuffle(First, Last, Generator) {
	First = make_iterator(First)

	var Gen = select_argument(Generator, irandom)
	var Dist = iterator_distance(First, Last)
	for (var i = Dist - 1; 0 < i; --i) {
	  swap(iterator_advance(First, i), iterator_advance(First, Gen(i + 1)))
	}
}
