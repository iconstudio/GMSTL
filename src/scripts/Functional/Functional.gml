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

///@function make_pair(value_1, value_2)
function make_pair(Val0, Val1) {
	return [Val0, Val1]
}
