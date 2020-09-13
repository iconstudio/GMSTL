/*
	Constructors:
		Grid(Width, Height)

	Initialize:
		new Grid(width, height)

	Usage:
		Recommend using internal functions to control the Grid.

		To Iterate a sequence on all values: (slow)
			for (var It = nbegin(); It != nend(); ++It) {
				myfunc(get_on(It))
			}

		To Iterate on lattices: (slow)
			for (var j = 0; j < height; ++j) { // row
				for (var i = 0; i < width; ++i) { // column
					myfunc(at(i, j))
				}
			}

		To Iterate on row: (very slow, please use internal functions if they can do the job)
			for (var k = 0; k < height; ++k) { // row
				for (var It = nbegin(k); It < nend(k); ++It) { // iterate
					myfunc(get_on(It))
				}
			}

		To Iterate a sequence with iterators (1): (so slow, please use internal functions if they can do the job)
			var It = new GridIterator(self, First)
			repeat Last - First {
				myfunc(It.get())
				It.go_forward()
			}
			delete It

		To Iterate a sequence with iterators (2): (so slow, please use internal functions if they can do the job)
			for (var It = new GridIterator(self, First); !It.equals(Last); It.go_forward()) {
				myfunc(It.get())
				It.go_forward()
			}
			delete It

*/
///@function Grid(width, height)
function Grid(Width, Height): Container() constructor {
	// elements are aligned by raw (tracking x, horizontal, left to right)
	type = Grid
	raw = ds_grid_create(Width, Height)
	width = Width
	height = Height
	inner_iterator = new GridIterator(self, 0)
	inner_size = width * height

	///@function first([row])
  function first() {
		if argument_count == 1
			return argument[0] * width
		else
			return 0
	}

	///@function last([row])
  function last() {
		if argument_count == 1
			return (argument[0] + 1) * width
		else
			return inner_size
	}

  ///@function set(x, y, value)
	function set(X, Y, Value) {
		raw[# X, Y] = Value
		return self
	}

  ///@function set_region(x1, y1, x2, y2, value)
	function set_region(X1, Y1, X2, Y2, Value) {
		ds_grid_set_region(raw, X1, Y1, X2, Y2, Value)
		return self
	}

  ///@function add_region(x1, y1, x2, y2, value)
	function add_region(X1, Y1, X2, Y2, Value) {
		ds_grid_add_region(raw, X1, Y1, X2, Y2, Value)
		return self
	}

  ///@function multiply_region(x1, y1, x2, y2, value)
	function multiply_region(X1, Y1, X2, Y2, Value) {
		ds_grid_multiply_region(raw, X1, Y1, X2, Y2, Value)
		return self
	}

  ///@function set_disk(x, y, radius, value)
	function set_disk(X, Y, Rads, Value) {
		ds_grid_set_disk(raw, X, Y, Rads, Value)
		return self
	}

  ///@function add_disk(x, y, radius, value)
	function add_disk(X, Y, Rads, Value) {
		ds_grid_add_disk(raw, X, Y, Rads, Value)
		return self
	}

  ///@function multiply_disk(x, y, radius, value)
	function multiply_disk(X, Y, Rads, Value) {
		ds_grid_multiply_disk(raw, X, Y, Rads, Value)
		return self
	}

	///@function at(x, y)
	function at(X, Y) { return raw[# X, Y] }

	///@function get(iterator)
	function get(It) { return at(It.x, It.y) }

	///@function get_on(index)
	function get_on(Index) {
		inner_iterator.set_index(Index)
		return at(inner_iterator.x, inner_iterator.y)
	}

	///@function check_all(x1, y1, x2, y2, predicate)
	function check_all(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		for (; Y1 < Y2; ++Y1) {
			for (var i = X1; i < X2; ++i) {
				var Value = at(i, Y1)
				if !pred(Value)
					return false
			}
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if pred(Value)
				return true
			First++
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if pred(Value)
				return false
			First++
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			pred(get(First))
			First++
		}
		return pred
	}

	///@function find(x1, y1, x2, y2, value)
	function find(X1, Y1, X2, Y2, Value) {
		var XR = ds_grid_value_x(raw, X1, Y1, X2, Y2, Value)
		var YR = ds_grid_value_y(raw, X1, Y1, X2, Y2, Value)
		if XR == -1 or YR == -1
			return undefined
		else
			return new GridIterator(XR, YR, self)
	}

	///@function find_disk(x, y, radius, value)
	function find_disk(X, Y, Rads, Value) {
		var XR = ds_grid_value_disk_x(raw, X, Y, Rads, Value)
		var YR = ds_grid_value_disk_y(raw, X, Y, Rads, Value)
		if XR == -1 or YR == -1
			return undefined
		else
			return new GridIterator(XR, YR, self)
	}

	///@function find_if(begin, end, predicate)
	function find_if(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		while First.not_equals(Last) {
			var Value = get(First)
			if !is_undefined(Value) and pred(Value)
				return First
			First++
		}
		return Last
	}

	///@function count(begin, end, value)
	function count(X1, Y1, X2, Y2, Value) {
		for (var it = First, Result = 0; it != Last; it.go()) {
			if get(it) == Value
				Result++
		}
		return Result
	}

	///@function count_if(begin, end, predicate)
	function count_if(X1, Y1, X2, Y2, Pred) {
		Pred = method(other, Pred)
		for (var it = First, Result = 0; it != Last; it.go()) {
			var Value = get(it)
			if pred(Value)
				Result++
		}
		return Result
	}

	///@function copy_to(x1, y1, x2, y2, destination_begin)
	function copy_to(X1, Y1, X2, Y2, DstIt) {
		var Dst = DstIt.container // Actual iteraters have its owner.
		var DstRaw = Dst.data()
		ds_grid_set_grid_region(DstRaw, raw, X1, Y1, X2, Y2, DstIt.x, DstIt.y)
	}

	function get_max(X1, Y1, X2, Y2) { return ds_grid_get_max(raw, X1, Y1, X2, Y2) }
	function get_min(X1, Y1, X2, Y2) { return ds_grid_get_min(raw, X1, Y1, X2, Y2) }
	function get_mean(X1, Y1, X2, Y2) { return ds_grid_get_mean(raw, X1, Y1, X2, Y2) }
	function get_sum(X1, Y1, X2, Y2) { return ds_grid_get_sum(raw, X1, Y1, X2, Y2) }

	function get_max_disk(X, Y, Rads) { return ds_grid_get_disk_max(raw, X, Y, Rads) }
	function get_min_disk(X, Y, Rads) { return ds_grid_get_disk_min(raw, X, Y, Rads) }
	function get_mean_disk(X, Y, Rads) { return ds_grid_get_disk_mean(raw, X, Y, Rads) }
	function get_sum_disk(X, Y, Rads) { return ds_grid_get_disk_sum(raw, X, Y, Rads) }

	///@function resize(width, height)
	function resize(Width, Height) {
		width = Width
		height = Height
		inner_size = width * height
		ds_grid_resize(raw, Width, Height)
	}

	///@function set_width(width)
	function set_width(Width) { resize(Width, height) }

	///@function set_height(height)
	function set_height(Height) { resize(width, Height) }

	///@function size()
	function size() { return inner_size }

	///@function get_width()
	function get_width() { return width }

	///@function get_height()
	function get_height() { return height }

	///@function clear(value)
	function clear(Value) { ds_grid_clear(raw, Value) }

	function sort_builtin(column, ascending) { ds_grid_sort(raw, column, ascending) }

	function shuffle_builtin() { ds_grid_shuffle(raw) }

	function destroy() {
		delete inner_iterator
		ds_grid_destroy(raw)
		raw = undefined
	}
}

///@function wrap_coordinates(index, width, height)
function wrap_coordinates(Index, Width, Height) {
	if Width == 1 {
		return [0, Index]
	} else if Height == 1 {
		return [Index, 0]
	} else {
		var factor = floor(Index / Width)
		return [Index - factor * Width, factor * Height]
	}
}

///@function GridColumnIterator(container, index)
function GridColumnIterator(Cont, Index): Iterator(Cont, Index) constructor {
}

///@function GridRowIterator(container, index)
function GridRowIterator(Cont, Index): Iterator(Cont, Index) constructor {
}

///@function GridRegionIterator(container, index)
function GridRegionIterator(Cont, Index): Iterator(Cont, Index) constructor {
}

///@function GridIterator(container, index)
function GridIterator(Cont, Index): Iterator(Cont, Index) constructor {
	function update_coordinates() {
		var Result = wrap_coordinates(index, container.width, container.height)
		x = Result[0]
		y = Result[1]
	}

	x = 0
	y = 0
	update_coordinates()

	///@function set(value)
	function set(Value) { return container.set(x, y, Value) }

	///@function get()
	function get() { return container.get(x, y) }

	///@function set_index(index)
	function set_index(Index) {
		set_index = Index
		update_coordinates()
		return index
	}

	function back() {
		--index
		update_coordinates()
		return index
	}

	function go() {
		++index
		update_coordinates()
		return index
	}

	function go_left() {
		--index
		update_coordinates()
		return index
	}

	function go_right() {
		++index
		update_coordinates()
		return index
	}

	function go_up() {
		index -= container.width
		update_coordinates()
		return index
	}

	function go_down() {
		index += container.width
		update_coordinates()
		return index
	}
}
