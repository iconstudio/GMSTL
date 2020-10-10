function Container() {
#region public
	///@function data()
	static data = function() { return raw }

	///@function duplicate()
	static duplicate = function() { return new type(self) }

	///@function assign(begin, end)
	static assign = function(First, Last) { clear(); foreach(First, Last, _Under_iterator_add) }

	static type = Container
	static iterator_type = undefined
#endregion

#region private
	///@function 
	static _Under_make_iterator = function(Index) {
		var Iter = new iterator_type(Index)
		Iter.storage = self
		return Iter
	}

	///@function (index, value)
	static _Under_iterator_set = undefined

	///@function (index)
	static _Under_iterator_get = undefined

	///@function function(value)
	static _Under_iterator_add = undefined

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = undefined

	///@function (index)
	static _Under_iterator_prev = undefined

	raw = undefined
#endregion
}

///@function is_iterable(container)
function is_iterable(container) {
	var meta = instanceof(container)
	return bool(meta != "Stack" and meta != "Queue" and meta != "Deque"
	and meta != "Priority_deque"and meta != "Priority_queue")
}
