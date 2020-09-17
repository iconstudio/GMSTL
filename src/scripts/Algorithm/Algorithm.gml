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

///@function erase(begin, end)
function erase(First, Last) {
	if is_real(First) {
		var Index = First
		First = Last.container.first()
		First.index = Index
		First.pointer = Index
	} else if !First.is_pure {
		First = First.duplicate()
	}
	var Cont = First.container

	var Result = First.duplicate() // last
	while First.not_equals(Last) {
		Cont.erase_at(First.get_index())
		First.go()
	}
	return Result
}

///@function check_all(begin, end, predicate)
function check_all(First, Last, Pred) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		if !Pred(First.get())
			return false
		First.go()
	}
	return true
}

///@function check_any(begin, end, predicate)
function check_any(First, Last, Pred) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		if Pred(First.get())
			return true
		First.go()
	}
	return false
}

///@function check_none(begin, end, predicate)
function check_none(First, Last, Pred) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		if Pred(First.get())
			return false
		First.go()
	}
	return true
}

///@function foreach(begin, end, predicate)
function foreach(First, Last, Pred) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		Pred(First.get())
		First.go()
	}
	return Pred
}

///@function find(begin, end, value, [comparator=compare_equal])
function find(First, Last, Value) {
	First = make_iterator(First)

	var Compare = 3 < argument_count ? argument[3] : compare_equal
	while First.not_equals(Last) {
		if Compare(First.get(), Value)
			return First
		First.go()
	}
	return Last
}

///@function find_if(begin, end, predicate)
function find_if(First, Last, Pred) {
	First = make_iterator(First)

	while First.not_equals(Last) {
		var Value = First.get()
		if Pred(Value)
			return First
		First.go()
	}
	return Last
}

///@function count(begin, end, value)
function count(First, Last, Value) {
	First = make_iterator(First)

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
	First = make_iterator(First)

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

	var Value = 0
	while First.not_equals(Last) {
		Value = First.get()
		if Pred(Value)
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

	while First.not_equals(Last) {
		var Value = First.get()
		if Pred(Value)
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
	if is_real(First) {
		var Index = First
		First = Last.container.first()
		First.index = Index
		First.pointer = Index
	} else if !First.is_pure {
		First = First.duplicate()
	}
	var Cont = First.container

	var Result = First.duplicate()
	while First.not_equals(Last) {
		if First.get() == Value
			Cont.erase_at(Result.get_index())
		else
			Result.go()
		First.go()
	}
	return Result
}

///@function remove_if(begin, end, predicate)
function remove_if(First, Last, Pred) {
	if is_real(First) {
		var Index = First
		First = Last.container.first()
		First.index = Index
		First.pointer = Index
	} else if !First.is_pure {
		First = First.duplicate()
	}
	var Cont = First.container

	var Result = First.duplicate()
	while First.not_equals(Last) {
		if Pred(First.get())
			Cont.erase_at(Result.get_index())
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

	while First.not_equals(Last) {
		Output.set(Pred(First.get(), PairFirst.get()))
		First.go()
		PairFirst.go()
		Output.go()
	}
	return Output
}

///@function min_element(begin, end, [comparator=compare_less])
function min_element(First, Last) {
	if First.equals(Last)
		return Last

	var Result = First.duplicate()
	var Cursor = First.next()
	var Compare = 2 < argument_count ? argument[2] : compare_less
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
function max_element(First, Last) {
	if First.equals(Last)
		return Last

	var Result = First.duplicate()
	var Cursor = First.next()
	var Compare = 2 < argument_count ? argument[2] : compare_less
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
function lower_bound(First, Last, Value) { // return the first and largest element which less than value.
	First = make_iterator(First)

	var Compare = 3 < argument_count ? argument[3] : compare_less
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
function upper_bound(First, Last, Value) { // return a greater element to the value.
	First = make_iterator(First)

	var Compare = 3 < argument_count ? argument[3] : compare_less
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
function binary_search(First, Last, Value) {
	First = make_iterator(First)

	var Compare = 3 < argument_count ? argument[3] : compare_less
	First = lower_bound(First, Last, Value, Compare)
	var FirstVal = First.get()
	return bool(First.not_equals(Last) and !Compare(Value, FirstVal))
}

///@function sort(begin, end, [comparator])
///@description quick sort
function sort(First, Last) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	if Last.index <= 1
		exit

	var Compare = 2 < argument_count ? argument[2] : compare_less
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
		sort(Pivot.next().pure(), Last.subtract(Pivot.distance(First) + 1), Compare)
	delete Pivot
	delete Pivot_Next
	gc_collect()
}

///@function stable_sort(begin, end, [comparator=compare_less])
///@description selection sort
function stable_sort(First, Last) {
	First = make_iterator(First)

	var selection, Compare = 2 < argument_count ? argument[2] : compare_less
	while First.not_equals(Last) {
		selection = min_element(First, Last, Compare)
		selection.swap(First)
		First.go()
		delete selection
	}
	gc_collect()
}

///@function insertion_sort(begin, end, [comparator=compare_less])
function insertion_sort(First, Last) {
	First = make_iterator(First).go()

	var Compare = 2 < argument_count ? argument[2] : compare_less
	while First.not_equals(Last) {
		var Value = First.get()
		for(var It = First.previous(); 0 <= It.get_index() and Compare(Value, It.get()); It.back()) {
			It.next().set(It.get())
		}
		It.next().set(Value)

		First.go()
		delete It
	}
	gc_collect()
}

///@function merge_sort(begin, end, [comparator=compare_less])
function merge_sort(First, Last) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	var Dist = First.distance(Last)
	if Dist <= 1
		exit

	var Compare = 2 < argument_count ? argument[2] : compare_less
	var Middle = iterator_advance(First, Dist * 0.5)
	merge_sort(First, Middle, Compare)
	merge_sort(Middle, Last, Compare)
	inplace_merge(First, Middle, Last, Compare)
}

///@function IMPLEMENTED FROM VS
///@description sort median of three elements to middle
function sort_median(First, Middle, Last, Comparator) {
	if Comparator(Middle.get(), First.get())
		Middle.swap(First)

	if Comparator(Last.get(), Middle.get()) { // swap middle and last, then test first again
		Last.swap(Middle)

		if Comparator(Middle.get(), First.get())
			Middle.swap(First)
	}
}

///@function IMPLEMENTED FROM VS
///@description sort median element to middle
function predict_median(First, Middle, Last, Comparator) {
	First = make_iterator(First)
	Middle = make_iterator(Middle)

	var Distance = iterator_distance(First, Last)
	if 40 < Distance { // Tukey's ninther
		var Step = (Distance + 1) >> 3 // +1 can't overflow because range was made inclusive in caller
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
	First = make_iterator(First)
	Last = make_iterator(Last)

	var Middle = iterator_advance(First, (iterator_distance(First, Last) >> 1)) // shift for codegen (== * 0.5)
	predict_median(First, Middle, Last.previous(), Comparator)

	var _Pfirst = Middle.duplicate()
	var _Pbefore = _Pfirst.previous()
	var _Plast = _Pfirst.next()
	while First.get_index() < _Pfirst.get_index() && !Comparator(_Pbefore.get(), _Pfirst.get()) && !Comparator(_Pfirst.get(), _Pbefore.get()) {
		_Pfirst.back()
		_Pbefore.back()
	}
	delete _Pbefore

	while _Plast.get_index() < Last.get_index() && !Comparator(_Plast.get(), _Pfirst.get()) && !Comparator(_Pfirst.get(), _Plast.get()) {
		_Plast.go()
	}

	var _Gfirst = _Plast.duplicate()
	var _Glast = _Pfirst.duplicate()
	for (;;) { // partition
		for (; _Gfirst < Last; _Gfirst.go()) {
			if Comparator(_Pfirst.get(), _Gfirst.get()) {
			} else if Comparator(_Gfirst.get(), _Pfirst.get()) {
				break
			} else if _Plast.not_equals(_Gfirst) {
				swap(_Plast, _Gfirst)
				_Plast.go()
			} else {
				_Plast.go()
			}
		}

		for (; First.get_index() < _Glast.get_index(); _Glast.back()) {
			var _Gfore = _Glast.previous()
			if Comparator(_Gfore.get(), _Pfirst.get()) {
			} else if Comparator(_Pfirst.get(), _Gfore.get()) {
				break
			} else if _Pfirst.back().not_equals(_Gfore) {
				swap(_Pfirst, _Gfore)
			}
			delete _Gfore
		}

		if _Glast.equals(First) and _Gfirst.equals(Last) {
			return [_Pfirst, _Plast]
		}

		if _Glast.equals(First) { // no room at bottom, rotate pivot upward
			if _Plast.not_equals(_Gfirst) {
				swap(_Pfirst, _Plast)
			}

			_Plast.go()
			_Pfirst.swap(_Gfirst)
			_Pfirst.go()
			_Gfirst.go()
		} else if _Gfirst.equals(Last) { // no room at top, rotate pivot downward
			if _Glast.back().not_equals(_Pfirst.back()) {
				swap(_Glast, _Pfirst)
			}

			swap(_Pfirst, _Plast.back())
		} else {
			swap(_Gfirst, _Glast.back())
			_Gfirst.go()
		}
	}
	delete _Pfirst
	delete _Plast
	delete _Gfirst
	delete _Glast
	gc_collect()
}

///@function nth_element(begin, nth, end, [comparator=compare_less])
function nth_element(First, Nth, Last) {
	First = make_iterator(First)
	Nth = make_iterator(Nth)
	Last = make_iterator(Last)
	if First.equals(Last) or Nth.equals(Last)
		exit

	var Compare = 3 < argument_count ? argument[3] : compare_less
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
function is_sorted(First, Last) {
	First = make_iterator(First)
	if First.equals(Last)
		return true

	var Compare = 2 < argument_count ? argument[2] : compare_less
	var Next = First.next()
	while Next.not_equals(Last) {
		if Compare(Next.get(), First.get()) {
			delete Next
			gc_collect()
		  return false
		}
		First.go()
		Next.go()
	}
	delete Next
	gc_collect()
	return true
}

///@function unguarded_partition(begin, end, pivot, [comparator=compare_less])
function unguarded_partition(First, Last, Pivot) {
	First = make_iterator(First)
	Last = make_iterator(Last)

	var Compare = 3 < argument_count ? argument[3] : compare_less
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
function merge(First, Last, OtherFirst, OtherLast, Output) {
	First = make_iterator(First)
	Last = make_iterator(Last)
	OtherFirst = make_iterator(OtherFirst)
	OtherLast = make_iterator(OtherLast)

	var Compare = 5 < argument_count ? argument[5] : compare_less
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
function inplace_merge(First, Middle, Last) {
	First = make_iterator(First)
	Middle = make_iterator(Middle)
	Last = make_iterator(Last)

	var Compare = 3 < argument_count ? argument[3] : compare_less
	var Temp = duplicate()
	Temp.merge(self, First, Middle, self, Middle, Last, First, Compare)
	copy(Temp.first(), Temp.last(), First)
	delete Temp
}

///@function shuffle(begin, end, [engine=irandom_range])
function shuffle(First, Last) {
	First = make_iterator(First)

	var Urng = 2 < argument_count ? argument[2] : irandom_range
	var Dist = iterator_distance(First, Last)
	for (var i = Dist - 1; 0 < i; --i) {
	  swap(iterator_advance(First, i), iterator_advance(First, Urng(0, i)))
	}
}

///@function random_shuffle(begin, end, [generator=irandom])
function random_shuffle(First, Last) {
	First = make_iterator(First)

	var Gen = 2 < argument_count ? argument[2] : irandom
	var Dist = iterator_distance(First, Last)
	for (var i = Dist - 1; 0 < i; --i) {
	  swap(iterator_advance(First, i), iterator_advance(First, Gen(i + 1)))
	}
}
