///@function Iterator(container, index)
function Iterator(Cont, Index) constructor {
	ITERATOR = true

	///@function duplicate()
	function duplicate() { return new type(container, index) }

	///@function pure()
	function pure() { is_pure = true; return self }

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
		if is_iterator(Other)
			return bool(Other.container == container and Other.index == index)
		else if is_real(Other)
			return bool(Other == index)
		return false
	}

	///@function not_equals(iterator)
	function not_equals(Other) {
		if is_iterator(Other)
			return bool(Other.container != container or Other.index != index)
		else if is_real(Other)
			return bool(Other != index)
		return false
	}

	///@function distance(iterator)
	function distance(Other) { 
		if is_iterator(Other)
			return abs(Other.index - index)
		else if is_numeric(Other)
			return abs(Other - index)
		return 0
	}

	///@function advance(other)
	function advance(Other) { 
		if is_iterator(Other) {
			index += Other.index
			pointer += Other.index
			is_pure = false
		} else if is_numeric(Other) {
			index += Other
			pointer += Other
			is_pure = false
		} 
		return self
	}

	///@function subtract(other)
	function subtract(Other) {
		if is_iterator(Other)
			advance(-Other.index)
		else if is_numeric(Other)
			advance(-Other)
		return self
	}

	container = Cont
	type = Iterator
	index = Index // Wrapper Index of container
	pointer = Index // Actual index of container
	is_pure = false
}

///@function ConstIterator(container, index)
function ConstIterator(Cont, Index): Iterator(Cont, Index) constructor {
	type = ConstIterator

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

///@function ForwardIterator(container, index)
function ForwardIterator(Cont, Index): Iterator(Cont, Index) constructor {
	type = ForwardIterator

	///@function set(value)
	function set() { container.set(pointer, argument[0]) }

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
function BidirectionalIterator(Cont, Index): ConstIterator(Cont, Index) constructor {
	type = BidirectionalIterator

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

///@function RandomIterator(container, index)
///@description RandomIterator
function RandomIterator(Cont, Index): BidirectionalIterator(Cont, Index) constructor {
	type = RandomIterator

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

///@function ConstMapIterator(container, index)
function ConstMapIterator(Cont, Index): ConstIterator(Cont, Index) constructor {
	///@function get()
	function get() { return container.at(key) }

	///@function get_index()
	function get_index() { return index }

	///@function get_key()
	function get_key() { return key }

	///@function go()
	function go() { 
		index++
		pointer++
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_next(container.data(), key)
		return self
	}

	///@function back()
	function back() { 
		index--
		pointer--
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_previous(container.data(), key)
		return self
	}

	///@function next()
	function next() {
		var Result = duplicate()
		Result.go()
		return Result
	}

	///@function previous()
	function previous() {
		var Result = duplicate()
		Result.back()
		return Result
	}

	///@function advance(other)
	function advance(Other) { 
		if is_iterator(Other) {
			repeat Other.index go()
		} else if is_numeric(Other) {
			if Other < 0
				repeat -Other back()
			else
				repeat Other go()
		} 
		return self
	}

	key = ds_map_find_first(container.data())
	if !is_undefined(key) and 0 < Index {
		repeat Index
			key = ds_map_find_next(container.data(), key)
	}
}

///@function MapIterator(container, index)
function MapIterator(Cont, Index): ConstMapIterator(Cont, Index) constructor {
	function set(value) { container.insert(key, value) }
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
		if !Param.is_pure
			return Param.duplicate()
	}
	return Param
}

///@function make_const_iterator(parameter)
function make_const_iterator(Param) {
	if is_iterator(Param) {
		if is_const_iterator(Param) {
			if !Param.is_pure
				return Param.duplicate()
		}
		return (new ConstIterator(Param.container, Param.index)).pure()
	}
	return Param
}

///@function is_iterator(iterator)
function is_iterator(iterator) {
	if is_struct(iterator)
		return bool(variable_struct_exists(iterator, "ITERATOR"))
	else
		return false
}

///@function is_const_iterator(iterator)
function is_const_iterator(iterator) {
	var meta = instanceof(iterator)
	return bool(meta == "ConstIterator")
}
