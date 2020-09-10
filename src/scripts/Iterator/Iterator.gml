///@function ConstIterator(container, index)
function ConstIterator(Cont, Index) constructor {
	container = Cont
	type = ConstIterator
	index = Index // Wrapper Index of container
	pointer = Index // Actual index of container
	is_pure = false

	///@function duplicate()
	function duplicate() { return new type(container, index) }

	///@function pure()
	function pure() {
		is_pure = true
		return self
	}

	///@function get()
	function get() { return container.at(pointer) }

	///@function get_index()
	function get_index() { return index }

	///@function go()
	function go() { 
		index++
		pointer++
		is_pure = false
		return self
	}

	///@function next()
	function next() {
		var Result = duplicate()
		Result.go()
		return Result
	}

	///@function equals(iterator)
	function equals(Other) {
		if is_numeric(Other)
			return bool(Other == index)
		else if is_iterator(Other)
			return bool(Other.container == container and Other.index == index)
		return false
	}

	///@function not_equals(iterator)
	function not_equals(Other) {
		if is_numeric(Other)
			return bool(Other != index)
		else if is_iterator(Other)
			return bool(Other.container != container or Other.index != index)
		return false
	}

	///@function distance(iterator)
	function distance(Other) { 
		if is_numeric(Other)
			return abs(Other - index)
		else if is_iterator(Other)
			return abs(Other.index - index)
		return 0
	}

	///@function advance(other)
	function advance(Other) { 
		if is_numeric(Other) {
			index += Other
			pointer += Other
			is_pure = false
		} else if is_iterator(Other) {
			index += Other.index
			pointer += Other.index
			is_pure = false
		}
		return self
	}

	///@function subtract(other)
	function subtract(Other) {
		if is_numeric(Other)
			advance(-Other)
		else if is_iterator(Other)
			advance(-Other.index)
		return self
	}
}

///@function ForwardIterator(container, index)
function ForwardIterator(Cont, Index): ConstIterator(Cont, Index) constructor {
	type = ForwardIterator

	function set(value) { container.set(pointer, value) }

	///@function swap(iterator)
	function swap(Other) {
		if is_iterator(Other) {
			var Temp = get()
			set(Other.get())
			Other.set(Temp)
		}
	}
}

///@function BidirectionalIterator(container, index)
function BidirectionalIterator(Cont, Index): ForwardIterator(Cont, Index) constructor {
	type = BidirectionalIterator

	function back() { 
		index--
		pointer--
		is_pure = false
		return self
	}

	///@function previous()
	function previous() {
		var Result = duplicate()
		Result.back()
		return Result
	}
}

///@function Iterator(container, index)
///@description Iterator
function Iterator(Cont, Index): BidirectionalIterator(Cont, Index) constructor {
	type = Iterator

	///@function set_index(index)
	function set_index(Index) {
		if index != Index {
			index = Index
			pointer = Index
			is_pure = false
		}
		return self
	}
}

///@function iterator_distance(iterator_1, iterator_2)
function iterator_distance(ItA, ItB) {
	if is_real(ItA) and is_real(ItB)
		abs(ItB - ItA)
	else if is_iterator(ItA)
		return ItA.distance(ItB)
	else if is_iterator(ItB)
		return ItB.distance(ItA)
	return 0
}

///@function iterator_advance(iterator, distance)
function iterator_advance(It, Distance) {
	if is_real(It) {
		return It + Distance
	} else if is_iterator(It) {
		return It.duplicate().advance(Distance)
	}
	return undefined
}

function Wrapper(Value) constructor {
	value = Value
}

///@function make_iterator(parameter)
function make_iterator(Param) {
	if is_iterator(Param) {
		if Param.is_pure
			return Param
		else
			return Param.duplicate()
	}
	return undefined
}

///@function make_const_iterator(parameter)
function make_const_iterator(Param) {
	if is_iterator(Param) {
		if is_const_iterator(Param) {
			if Param.is_pure
				return Param
			else
				return Param.duplicate()
		}
		return (new ConstIterator(Param.container, Param.index)).pure()
	}
	return undefined
}

///@function is_iterator(iterator)
function is_iterator(iterator) {
	var meta = instanceof(iterator)
	return bool(meta == "ForwardIterator" or meta == "BidirectionalIterator"
	and meta == "ConstIterator" or meta == "Iterator")
}

///@function is_random_iterator(iterator)
function is_random_iterator(iterator) {
	var meta = instanceof(iterator)
	return bool(meta == "Iterator")
}

///@function is_const_iterator(iterator)
function is_const_iterator(iterator) {
	var meta = instanceof(iterator)
	return bool(meta == "ConstIterator")
}
