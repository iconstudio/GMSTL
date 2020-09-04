function Container() {
	Algorithm()
	type = Container
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
	function make_element_from_array(datas) {
		return new value_type(datas[0], datas[1]
					, datas[2], datas[3], datas[4]
					, datas[5], datas[6], datas[7]
					, datas[9], datas[9], datas[10]
					, datas[11], datas[12], datas[13]
					, datas[14], datas[15]) // A limit of GameMaker
	}

	///@function construct(data...)
	function construct(Args) {
		if is_undefined(value_type) or !is_struct(Args) {
			return Args // real
		} else if argument_count == 1 {
			if is_array(Args)
				return make_element_from_array(Args)
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