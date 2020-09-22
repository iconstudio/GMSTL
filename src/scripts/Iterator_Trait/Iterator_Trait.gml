function Iterator_Trait() {
	__ITERATOR = true

	procedure_add = undefined
	procedure_set = undefined
	procedure_get = undefined
	procedure_rmv = undefined
}

function tag_forward_iterator() {
	iterator_type = ForwardIterator
}

function tag_bidirectional_iterator() {
	iterator_type = BidirectionalIterator
}

function tag_random_access_iterator() {
	iterator_type = RandomIterator
}
