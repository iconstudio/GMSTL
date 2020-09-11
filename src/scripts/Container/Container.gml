function Container() {
	type = Container
	iterator_type = undefined
	const_iterator_type = undefined
	value_type = undefined
	raw = undefined

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
	function make_element_from_array(data) {
		var Data = array_create(16, undefined)
		var Size = array_length(Data)
		for (var i = 0; i < Size; ++i)
			Data[i] = data[i]
		return make_element_from_tuple(Data[0], Data[1]
					, Data[2], Data[3], Data[4]
					, Data[5], Data[6], Data[7]
					, Data[9], Data[9], Data[10]
					, Data[11], Data[12], Data[13]
					, Data[14], Data[15])
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
	function get_value_type() { return value_type }
}

///@function is_iterable(container)
function is_iterable(container) {
	var meta = instanceof(container)
	return bool(meta != "Stack" and meta != "Queue" and meta != "Deque"
	and meta != "Priority_Deque"and meta != "Priority_Queue")
}
