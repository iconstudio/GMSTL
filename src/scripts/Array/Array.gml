///@function List(size or id or items...)
function Array(Items) constructor {
	type = Array
	raw = 0
	_size = 0
	Algorithm()

	function data() { return raw }

	function duplicate() { return new Array(self) }

	///@function set(iterator, value)
  function set(It, Val) {
		if It < iend()
			raw[It] = Val
		return self
	}

	///@function get(iterator)
  function get(It) { return raw[It] }

	///@function at(index)
  function at(i) { return raw[i] }

	///@function size()
	function size() { return _size }

	///@function ibegin()
  function ibegin() { return 0 }

	///@function iend()
  function iend() { return size() }

	///@function front()
  function front() { return at(0) }

	///@function back()
  function back() { return at(_size - 1) }

	///@function allocate(size)
	function allocate(Size) {
		raw = array_create(Size, 0)
	}

	if 0 < argument_count and !is_undefined(argument[0]) {
		if argument_count == 1 and is_numeric(argument[0]) {
			var Item = argument[0]

			if ds_exists(Item, ds_type_list) {
				ds_list_copy(raw, Item)
			} else if is_struct(Item) {
				_size = Item.size()
				allocate(_size)
				var First = 0
				for (var It = Item.ibegin(); It != Item.iend(); ++It) {
					set(First++, Item.get(It))
				}
			} else if is_array(Item) {
				_size = array_length(Item)
				allocate(_size)
				array_copy(raw, 0, Item, 0, _size)
			} else {
				ds_list_add(raw, Item)
			}
		} else {
			_size = argument_count
			allocate(_size)
			for (var i = 0; i < argument_count; ++i) {
				set(i, argument[i])
			}
		}
	}
}