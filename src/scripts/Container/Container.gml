function Container() {
	type = Container
	iterator_type = undefined
	const_iterator_type = undefined
	raw = undefined

	function data() { return raw }

	function duplicate() { return new type(self) }
}

///@function is_iterable(container)
function is_iterable(container) {
	var meta = instanceof(container)
	return bool(meta != "Stack" and meta != "Queue" and meta != "Deque"
	and meta != "Priority_Deque"and meta != "Priority_Queue")
}
