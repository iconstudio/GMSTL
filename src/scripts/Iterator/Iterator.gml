function tag_const_iterator() {}

function tag_forward_iterator() {}

function tag_bidirectional_iterator() {}

function tag_random_access_iterator() {}

///@function Iterator_trait(storage)
function Iterator_trait(Index) constructor {
	///@function 
	static _Under_iterator_get = function() { return storage._Under_iterator_get(index) }

	///@function 
	static _Under_iterator_next = function() {
		index_backward = index
		if is_undefined(index)
			index = index_forward
		else
			index = storage._Under_iterator_next(index)
		index_modified = true
		return self
	}

	///@function 
	static _Under_copy = function(Other) {
		if category != Other.category
			throw "Types of two iterators unmatched."
		Other.storage = storage
		Other.value = value
		Other.index = index
		
		return Other
	}

	///@function 
	static _Under_duplicate = function() {
		var Result = new type(storage)
		return _Under_copy(Result)
	}

	///@function 
	static _Under_move = function(Other) {
		var Result = Other._Under_copy(self)
		delete Other
		gc_collect()
		return Result
	}

	///@function pure()
	static pure = function() { is_pure = true; return self }

	///@function impure()
	static impure = function() { is_pure = false; return self }

	__ITERATOR = true
	storage = undefined
	is_pure = false
	value = undefined
	index = Index
	index_forward = Index
	index_backward = Index
	index_modified = true
	static type = undefined
	static category = undefined
}

///@function Const_iterator(index)
function Const_iterator(Index): Iterator_trait(Index) constructor {
	///@function duplicate()
	static duplicate = _Under_duplicate

	///@function get()
	static get = function() {
		if index_modified {
			value = _Under_iterator_get()
			index_modified = false
		}
		return value
	}

	///@function go_next()
	static go_next = function() { return _Under_iterator_next() }

	///@function make_next()
	static make_next = function() { return (duplicate().go_next().pure()) }

	///@function equals(iterator)
	static equals = function(It) {
		if is_real(It) {
			return bool(It == index)
		} else if is_undefined(It) {
			if is_undefined(index)
				return true
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.storage == storage and It.index == index)
		}
		return false
	}

	///@function not_equals(iterator)
	static not_equals = function(It) {
		if is_real(It) {
			return bool(It != index)
		} else if is_undefined(It) {
			if !is_undefined(index)
				return true
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.storage != storage or It.index != index)
		}
		return false
	}

	///@function advance(other)
	static advance = function(Other) {
		if is_real(Other) {
			if Other < 0
				throw "Cannot use negative index for advancing forward iterators."
			repeat Other
				go_next()
		} else {
			repeat Other.index
				go_next()
		}
		return self
	}

	///@function distance(other)
	static distance = function(Other) { 
		if !is_struct(Other) {
			return 0
		} else {
			var Result = 0
			var Checker = duplicate()
			while !is_undefined(Checker) {
				if Checker.equals(Other)
					break
				Checker.go_next()
				Result++
			}
			return Result
		}
		return 0
	}

	static type = Const_iterator
	static category = tag_const_iterator
}

///@function Forward_iterator(index)
function Forward_iterator(Index): Const_iterator(Index) constructor {
	///@function 
	static _Under_iterator_set = function(Index, Value) { return storage._Under_iterator_set(Index, Value) }

	///@function 
	static _Under_iterator_insert = function(Value) {
		index_modified = true
		return _Under_iterator_insert(Value)
	}

	///@function set(value)
	static set = function(Value) { return _Under_iterator_set(index, Value) }

	///@function insert(value)
	static insert = function(Value) { return _Under_iterator_insert(index, Value) }

	///@function swap(iterator)
	static swap = function(It) {
		is_pure = false
		var Temp = get()
		self.set(It.get())
		It.set(Temp)
	}

	static type = Forward_iterator
	static category = tag_forward_iterator
}

///@function Bidirectional_iterator(index)
function Bidirectional_iterator(Index): Forward_iterator(Index) constructor {
	///@function 
	static _Under_iterator_prev = function() {
		index_forward = index
		if is_undefined(index)
			index = index_backward
		else
			index = storage._Under_iterator_prev(index)
		index_modified = true
		return self
	}

	///@function go_prev()
	static go_prev = function() { return _Under_iterator_prev(); index_modified = true }

	///@function make_previous()
	static make_previous = function() { return (_Under_duplicate().go_prev().pure()) }

	///@function advance(other)
	static advance = function(Other) {
		if is_real(Other) {
			if Other < 0 {
				repeat -Other
					go_prev()
			} else {
				repeat Other
					go_next()
			}
		} else {
			var Times = Other.index
			repeat Times
				go_next()
		}
		return self
	}

	static type = Bidirectional_iterator
	static category = tag_bidirectional_iterator
}

///@function Random_iterator(index)
function Random_iterator(Index): Bidirectional_iterator(Index) constructor {
	///@function advance(other)
	static advance = function(Other) {
		if is_real(Other) {
			index += Other
		} else {
			index += Other.index
		}
		index_modified = true
		return self
	}

	///@function distance(other)
	static distance = function(Other) { 
		if is_real(Other) {
			return abs(Other - index)
		} else {
			if Other.category != category or Other.storage != storage
				throw "Cannot get a distance between different types of iterator."
			else
				return abs(Other.index - index)
		}
		return 0
	}

	///@function fore_than(iterator)
	static fore_than = function(It) {
		if is_real(It) {
			return bool(index < It)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.storage == storage and It.index < index)
		}
		return false
	}

	///@function back_than(iterator)
	static back_than = function(It) {
		if is_real(It) {
			return bool(It < index)
		} else {
			if It.category != category
				throw "Cannot compare different type of iterators."
			else
				return bool(It.storage == storage and index < It.index)
		}
		return false
	}

	static type = Random_iterator
	static category = tag_random_access_iterator
}

///@function Iterator(index)
function Iterator(Index) {
	if is_undefined(Index)
		return undefined
	if !is_struct(self)
		throw "Cannot make a iterator on outer scope!"

	return _Under_make_iterator(Index).pure()
}

///@function iterator_distance(iterator_1, iterator_2)
function iterator_distance(ItA, ItB) {
	if is_real(ItA) and is_real(ItB) {
		return abs(ItB - ItA)
	} else {
		var CheckA = is_iterator(ItA), CheckB = is_iterator(ItB)
		if CheckA and !CheckB {
			return ItA.distance(ItB)
		} else if !CheckA and CheckB {
			return ItB.distance(ItA)
		} else { // both are iterator
			var TagA = ItA.category, TagB = ItB.category
			if TagA == TagB and TagA == tag_random_access_iterator {
				return ItA.distance(ItB)
			} else if TagA != tag_random_access_iterator or TagB != tag_random_access_iterator {
				var Result = 0, Cursor = ItA.duplicate()
				while Cursor.not_equals(ItB) {
					Result++
					Cursor.go_next()
				}
				return Result
			}
		}
	}
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

///@function check_iterator(parameter)
function check_iterator(Param) {
	if is_iterator(Param) {
		if !Param.is_pure
			return Param.duplicate()
		else
			return Param.impure()
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
