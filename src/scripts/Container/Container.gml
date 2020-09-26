function Container() {
	function data() { return raw }

	static duplicate = function() { return new type(self) }

	function make_self() { return new type() }

	type = Container
	iterator_type = undefined

	raw = undefined
	procedure_add = undefined
	procedure_set = undefined
	procedure_get = undefined
	procedure_rmv = undefined
}

///@function is_iterable(container)
function is_iterable(container) {
	var meta = instanceof(container)
	return bool(meta != "Stack" and meta != "Queue" and meta != "Deque"
	and meta != "Priority_deque"and meta != "Priority_queue")
}
