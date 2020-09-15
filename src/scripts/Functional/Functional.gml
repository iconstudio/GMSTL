function integral(condition, value_true, value_false) {
	return condition ? value_true : value_false
}

function compare_equal(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
	return bool(a == b)
}

function compare_less(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
	return bool(a < b)
}

function compare_greater(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
	return bool(a > b)
}

function compare_complex_less(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false

	//var A_is_unmeasurable = is_struct(a) or is_method(a)
	var A_is_string = is_string(a), B_is_string = is_string(b)
	var A_is_number = is_numeric(a), B_is_number = is_numeric(b)
	if A_is_string and B_is_string {
		return compare_string_less(a, b)
	} else if A_is_string and B_is_number { // push strings to back of numbers
		return false
	} else if A_is_number and B_is_string { // pull numbers
		return true
	} else { // both are number
		return bool(a < b)
	}
}

function compare_string_less(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false

	var LenA = string_length(a)
	var LenB = string_length(b)
	if LenA == 0 and LenB != 0 {
		return true
	} else if LenA != 0 and LenB == 0 {
		return false
	} else if LenA == 0 and LenB == 0 {
		return false
	} else if a == b {
		return false
	} else {
		var ItA = 0, ItB = 0, ValueA, ValueB
		while ItA != LenA {
			if ItB == LenB
				return false
			ValueA = string_ord_at(a, ItA + 1)
			ValueB = string_ord_at(b, ItB + 1)
			if !(ValueA < ValueB)
				return false

			ItA++
			ItB++
		}
		return true
	}
}

///@function select_argument(parameter, default)
function select_argument(Param, Default) {
	return integral(is_undefined(Param), Default, Param)
}

///@function choice(index, ...)
function choice(index) {
	if index + 1 < argument_count
		return argument[index + 1]
	else 
		return undefined
}

///@function make_pair(value_1, value_2)
function make_pair(Val0, Val1) {
	return [Val0, Val1]
}

///@function string_weak_hash(string)
function string_weak_hash(Str) {
	var sum = 0
	for (var i = 1; i <= string_length(Str); ++i) {
		sum += string_ord_at(Str, i) * 26
		sum += i * 26
		sum %= 10009
	}
	return sum
}
