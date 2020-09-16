///@function Iterator(container, index)
function Iterator(Cont, Index) constructor {
	ITERATOR = true

	///@function duplicate()
	static duplicate = function() { return new type(container, index) }

	///@function pure()
	static pure = function() { is_pure = true; return self }

	///@function impure()
	static impure = function() { is_pure = false; return self }

	///@function get()
	static get = function() { return container.at(pointer) }

	///@function get_index()
	static get_index = function() { return index }

	///@function go()
	static go = function() { 
		index++
		pointer++
		is_pure = false
		return self
	}

	///@function next()
	static next = function() {
		var Result = duplicate().go()
		return Result
	}

	///@function advance(other)
	///@desc add it multiple times
	static advance = function(Other) {
		if is_iterator(Other)
			repeat Other.index go()
		else if is_real(Other) and 0 < Other
			repeat Other go()
		else
			throw "Cannot use the negative index for advancing normal iterators."
		return self
	}

	///@function equals(iterator)
	static equals = function(Other) {
		if is_iterator(Other)
			return bool(Other.container == container and Other.index == index)
		else if is_real(Other)
			return bool(Other == index)
		return false
	}

	///@function not_equals(iterator)
	static not_equals = function(Other) {
		if is_iterator(Other)
			return bool(Other.container != container or Other.index != index)
		else if is_real(Other)
			return bool(Other != index)
		return false
	}

	///@function distance(iterator)
	static distance = function(Other) { 
		if is_iterator(Other)
			return abs(Other.index - index)
		else if is_real(Other)
			return abs(Other - index)
		return 0
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

	///@function back()
	static back = function() { 
		index--
		pointer--
		is_pure = false
		return self
	}

	///@function previous()
	static previous = function() {
		var Result = duplicate().back()
		return Result
	}

	///@function advance(other)
	///@desc add or sub it multiple times
	static advance = function(Other) {
		if is_iterator(Other) {
			repeat Other.index go()
		} else if is_real(Other) {
			if 0 < Other
				repeat Other go()
			else if Other < 0
				repeat -Other back()
		} else {
			throw "NaN value used on a iterator."
		}
		return self
	}

	///@function subtract(other)
	static subtract = function(Other) {
		if is_iterator(Other)
			advance(-Other.index)
		else if is_real(Other)
			advance(-Other)
		return self
	}
}

///@function ForwardIterator(container, index)
function ForwardIterator(Cont, Index): Iterator(Cont, Index) constructor {
	type = ForwardIterator

	///@function set(value)
	static set = function() { container.set(pointer, argument[0]) }

	///@function swap(iterator)
	static swap = function(Other) {
		if is_iterator(Other) {
			var Temp = get()
			self.set(Other.get())
			Other.set(Temp)
		}
	}
}

///@function BidirectionalIterator(container, index)
function BidirectionalIterator(Cont, Index): ConstIterator(Cont, Index) constructor {
	type = BidirectionalIterator

	///@function set(value)
	static set = function() { container.set(pointer, argument[0]) }

	///@function swap(iterator)
	static swap = function(Other) {
		if is_iterator(Other) {
			var Temp = get()
			self.set(Other.get())
			Other.set(Temp)
		}
	}
}

///@function RandomIterator(container, index)
///@description RandomIterator
function RandomIterator(Cont, Index): BidirectionalIterator(Cont, Index) constructor {
	type = RandomIterator

	///@function set_index(index)
	static set_index = function(Index) {
		if index != Index {
			index = Index
			pointer = Index
			is_pure = false
		}
		return self
	}

	///@function advance(other)
	static advance = function(Other) {
		if is_iterator(Other) {
			index += Other.index
			pointer += Other.index
			is_pure = false
		} else if is_real(Other) {
			index += Other
			pointer += Other
			is_pure = false
		} 
		return self
	}

	///@function subtract(other)
	static subtract = function(Other) {
		if is_iterator(Other)
			advance(-Other.index)
		else if is_real(Other)
			advance(-Other)
		return self
	}
}

///@function ConstMapIterator(container, index)
function ConstMapIterator(Cont, Index): ConstIterator(Cont, Index) constructor {
	///@function get()
	static get = function() { return container.at(key) }

	///@function get_index()
	static get_index = function() { return index }

	///@function get_key()
	function get_key() { return key }

	///@function go()
	static go = function() { 
		index++
		pointer++
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_next(container.data(), key)
		return self
	}

	///@function back()
	static back = function() { 
		index--
		pointer--
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_previous(container.data(), key)
		return self
	}

	///@function advance(other)
	static advance = function(Other) {
		if is_iterator(Other) {
			repeat Other.index go()
		} else if is_real(Other) {
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
	static set = function(value) { container.insert(key, value) }
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
