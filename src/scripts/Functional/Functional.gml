function integral(condition, value_true, value_false) {
	return condition ? value_true : value_false
}

function comparator_equal(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
	return bool(a == b)
}

function comparator_less(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
	return bool(a < b)
}

function comparator_greater(a, b) {
	if is_undefined(a) or is_undefined(b)
		return false
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
		return undefined
}
