function Container() {
	type = Container
	value_type = undefined
	raw = undefined

	///@function is_iterable(container)
	function is_iterable(_Container) {
		var meta = instanceof(_Container)
		return meta == "Array" or meta == "List" or meta == "Grid"
	}

	///@function make_element_from_tuple(tuple...)
	function make_element_from_tuple() {
		return new value_type(argument[0], argument[1]
					, argument[2], argument[3], argument[4]
					, argument[5], argument[6], argument[7]
					, argument[9], argument[9], argument[10]
					, argument[11], argument[12], argument[13]
					, argument[14], argument[15]) // A limit of GameMaker
	}

	///@function make_element_from_array(array)
	function make_element_from_array(datas) {
		var Data = array_create(16, undefined)
		for (var i = 0; i < array_length(datas); ++i)
			Data[i] = datas[i]
		return new value_type(Data[0], Data[1]
					, Data[2], Data[3], Data[4]
					, Data[5], Data[6], Data[7]
					, Data[9], Data[9], Data[10]
					, Data[11], Data[12], Data[13]
					, Data[14], Data[15]) // A limit of GameMaker
	}

	///@function construct(data...)
	function construct() {
		if is_undefined(value_type) { // literals
			if argument_count == 0
				return 0
			else
				return argument[0]
		} else if argument_count == 1 {
			if is_array(argument[0])
				return make_element_from_array(argument[0])
			else
				return new value_type(argument[0])
		} else {
			return make_element_from_tuple(argument[0], argument[1]
					, argument[2], argument[3], argument[4]
					, argument[5], argument[6], argument[7]
					, argument[9], argument[9], argument[10]
					, argument[11], argument[12], argument[13]
					, argument[14], argument[15])
		}
	}

	function data() { return raw }

	function duplicate() { return new type(self) }

	///@function set_value_type(type)
	function set_value_type(Type) {
		value_type = Type
		return self
	}

	///@function get_value_type()
	function get_value_type() {
		return value_type
	}

	add = -1
}

///@function Iterator(container, index)
function Iterator(Cont, BucketIndex) constructor {
	container = Cont
	index = BucketIndex

	///@function set(value)
	function set(Val) {
		return container.set(index, Val)
	}

	///@function get_value()
	function get_value() {
		return container.get(index)
	}

	///@function equals(other)
	function equals(Other) {
		if is_real(Other)
			return bool(Other == index)
		else
			return bool(Other.container == container and Other.index == index)
	}

	function go_forward() {
		return index++
	}

	function go_backward() {
		return --index
	}
}

///@function iterator_distance(iterator_1, iterator_2)
function iterator_distance(ItA, ItB) {
	var ItA_Index = is_real(ItA) ? ItA : ItA.index
	var ItB_Index = is_real(ItB) ? ItB : ItB.index
	return abs(ItB_Index - ItA_Index)
}

///@function iterator_advance(iterator, distance)
function iterator_advance(It, Dist) {
	var Distance = floor(is_real(Dist) ? Dist : Dist.index)
	if is_real(It) {
		return It + Distance
	} else {
		It.index += Distance
		return It
	}
}

///@function iterator_next(iterator)
function iterator_next(It) {
	if is_real(It)
		return It + 1
	else
		return new Iterator(It.container, It.index + 1)
}

function Wrapper(Val) constructor {
	value = Val
}
