function Container() {
#region public
	function data() { return raw }

	static duplicate = function() { return new type(self) }

	static type = Container
	static iterator_type = undefined
#endregion

#region private
	///@function 
	static underlying_make_iterator = function(Index) {
		var Iter = new iterator_type(Index)
		Iter.storage = self
		return Iter
	}

	raw = undefined
#endregion
}

///@function is_iterable(container)
function is_iterable(container) {
	var meta = instanceof(container)
	return bool(meta != "Stack" and meta != "Queue" and meta != "Deque"
	and meta != "Priority_deque"and meta != "Priority_queue")
}
