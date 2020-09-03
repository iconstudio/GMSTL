function integral(condition, value_true, value_false) {
	return condition ? value_true : value_false
}

function comparator_equal(a, b) {
	return bool(a == b)
}

function comparator_less(a, b) {
	return bool(a < b)
}

function comparator_greater(a, b) {
	return bool(a > b)
}

///@function select_argument(parameter, default)
function select_argument(arg, def) {
	return integral(is_undefined(arg), def, arg)
}

///@function choice(index, ...)
function choice(index) {
	if index + 1 < argument_count
		return argument[index + 1]
	else 
		throw "Cannot access to the parameter."
}
