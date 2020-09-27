function tag_none_iterator() {}

function tag_const_iterator() {}

function tag_forward_iterator() {}

function tag_bidirectional_iterator() {}

function tag_random_access_iterator() {}

///@function Iterator_trait(container)
function Iterator_trait(Storage) constructor {
	///@function 
	static underlying_copy = function(Other) {
		if category != Other.category
			throw "Types of two iterators unmatched."
		value = Other.value
		index = Other.index
		pointer_index = Other.pointer_index
		index_modified = false
		return Other
	}

	///@function 
	static underlying_duplicate = function() {
		var Result = new type(container)
		return Result.underlying_copy(self)
	}

	///@function 
	static underlying_move = function(Other) {
		var Result = Other.underlying_copy(self)
		delete Other
		gc_collect()
		return Result
	}

	///@function pure()
	static pure = function() { is_pure = true; return self }

	///@function impure()
	static impure = function() { is_pure = false; return self }

	///@function swap_with(iterator)
	static swap_with = function(It) {
		is_pure = false
		var Temp = get()
		self.set(It.get())
		It.set(Temp)
	}

	__ITERATOR = true
	category = tag_none_iterator
	storage = Storage
	underlying_iterator_get = method(Storage, Storage.underlying_iterator_get)
	underlying_iterator_next = method(Storage, Storage.underlying_iterator_next)

	container = undefined
	is_pure = false

	value = undefined
	index = 0
	index_modified = true
}

function Const_iterator(Storage): Iterator_trait(Storage) constructor {
	///@function get()
	static get = function() {
		if index_modified {
			value = underlying_iterator_get(index)
			index_modified = false
		}
		return value
	}

	///@function go_next()
	static go_next = function() { return underlying_iterator_next(index) }

	///@function make_next()
	static make_next = function() { return (underlying_duplicate().go_next()) }

	///@function equals(iterator)
	static equals = function(It) {
		if is_real(It) {
			return bool(It == index)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.container == container and It.index == index)
		}
		return false
	}

	///@function not_equals(iterator)
	static not_equals = function(It) {
		if is_real(It) {
			return bool(It != index)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.container != container or It.index != index)
		}
		return false
	}

	category = tag_const_iterator
}

function Forward_iterator(Storage): Const_iterator(Storage) constructor {
	///@function set(value)
	static set = function(Value) { return underlying_iterator_set(index, Value) }

	///@function insert(value)
	static insert = function(Value) { return underlying_iterator_insert(index, Value) }

	category = tag_forward_iterator
	underlying_iterator_set = method(Storage, Storage.underlying_iterator_set)
	underlying_iterator_insert = method(Storage, Storage.underlying_iterator_insert)
}

function Bidirectional_iterator(Storage): Forward_iterator(Storage) constructor {
	///@function go_prev()
	static go_prev = function() { return underlying_iterator_next(index) }

	///@function make_previous()
	static make_previous = function() { return (underlying_duplicate().go_prev()) }

	category = tag_bidirectional_iterator
}

function Random_iterator(Storage): Bidirectional_iterator(Storage) constructor {
	///@function less_than(iterator)
	static less_than = function(It) {
		if is_real(It) {
			return bool(index < It)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.container == container and index < It.index)
		}
		return false
	}

	///@function greater_than(iterator)
	static greater_than = function(It) {
		if is_real(It) {
			return bool(It < index)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.container == container and It.index < index)
		}
		return false
	}

	category = tag_random_access_iterator
}


///@function Iterator(container, index)
function Iterator(Cont, Index): Iterator_trait() constructor {
	///@function duplicate()
	static duplicate = function() { return underlying_duplicate() }

	///@function get()
	static get = function() { return container.at(pointer_index) }

	///@function get_index()
	static get_index = function() { return index }

	///@function go_next()
	static go_next = function() { 
		index++
		pointer_index++
		is_pure = false
		return self
	}

	///@function next()
	static next = function() {
		var Result = duplicate().go_next()
		return Result
	}

	///@function advance(other)
	///@desc add it multiple times
	static advance = function(Other) {
		if is_iterator(Other)
			repeat Other.index go_next()
		else if is_real(Other) and 0 < Other
			repeat Other go_next()
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
	index = Index
	pointer_index = Index
	type = Iterator
	is_pure = false
}

///@function ForwardIterator(container, index)
function ForwardIterator(Cont, Index): Iterator(Cont, Index) constructor {
	type = ForwardIterator

	///@function set(value)
	static set = function() { container.set_at(pointer_index, argument[0]) }

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
function BidirectionalIterator(Cont, Index): Iterator(Cont, Index) constructor {
	type = BidirectionalIterator

	///@function set(value)
	static set = function() { container.set_at(pointer_index, argument[0]) }

	///@function back()
	static back = function() { 
		index--
		pointer_index--
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
			repeat Other.index go_next()
		} else if is_real(Other) {
			if 0 < Other
				repeat Other go_next()
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
			pointer_index = Index
			is_pure = false
		}
		return self
	}

	///@function advance(other)
	static advance = function(Other) {
		if is_iterator(Other) {
			index += Other.index
			pointer_index += Other.index
			is_pure = false
		} else if is_real(Other) {
			index += Other
			pointer_index += Other
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

///@function MapIterator(container, index)
function MapIterator(Cont, Index): Iterator(Cont, Index) constructor {
	static set = function(value) { container.insert(key, value) }

	///@function get()
	static get = function() { return container.at(key) }

	///@function get_index()
	static get_index = function() { return index }

	///@function get_key()
	function get_key() { return key }

	///@function go_next()
	static go_next = function() { 
		index++
		pointer_index++
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_next(container.data(), key)
		return self
	}

	///@function back()
	static back = function() { 
		index--
		pointer_index--
		is_pure = false
		if !is_undefined(key)
			key = ds_map_find_previous(container.data(), key)
		return self
	}

	///@function advance(other)
	static advance = function(Other) {
		if is_iterator(Other) {
			repeat Other.index go_next()
		} else if is_real(Other) {
			if Other < 0
				repeat -Other back()
			else
				repeat Other go_next()
		} 
		return self
	}

	key = ds_map_find_first(container.data())
	if !is_undefined(key) and 0 < Index {
		repeat Index
			key = ds_map_find_next(container.data(), key)
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
		if !Param.is_pure
			return Param.duplicate()
	}
	return Param
}


///@function is_iterator(iterator)
function is_iterator(iterator) {
	if is_struct(iterator)
		return variable_struct_exists(iterator, "__ITERATOR")
	else
		return false
}
