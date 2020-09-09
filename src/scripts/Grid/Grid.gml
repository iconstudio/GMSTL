/*
	Constructors:
		Grid(Width, Height)

	Initialize:
		new Grid(width, height)
		set_value_type(type)

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
	__iend = new GridIterator(self, inner_size)

	///@function ibegin()
  function ibegin() { return new GridIterator(self, 0) }

	///@function iend()
  function iend() { return __iend }

	///@function nbegin([row])
  function nbegin() {
		if argument_count == 1
			return argument[0] * width
		else
			return 0
	}

	///@function nend([row])
  function nend() {
		if argument_count == 1
			return (argument[0] + 1) * width
		else
			return inner_size
	}

  ///@function set(x, y, value)
	function set(X, Y, Val) {
		raw[# X, Y] = Val
		return self
	}

  ///@function insert_on(index, value)
	function insert_on(Index, Val) {
		inner_iterator.set_index(Index)
		set(inner_iterator.x, inner_iterator.y, Val)
		return self
	}

  ///@function set_region(x1, y1, x2, y2, value)
	function set_region(X1, Y1, X2, Y2, Val) {
		ds_grid_set_region(raw, X1, Y1, X2, Y2, Val)
		return self
	}

  ///@function add_region(x1, y1, x2, y2, value)
	function add_region(X1, Y1, X2, Y2, Val) {
		ds_grid_add_region(raw, X1, Y1, X2, Y2, Val)
		return self
	}

  ///@function multiply_region(x1, y1, x2, y2, value)
	function multiply_region(X1, Y1, X2, Y2, Val) {
		ds_grid_multiply_region(raw, X1, Y1, X2, Y2, Val)
		return self
	}

  ///@function set_disk(x, y, radius, value)
	function set_disk(X, Y, Rads, Val) {
		ds_grid_set_disk(raw, X, Y, Rads, Val)
		return self
	}

  ///@function add_disk(x, y, radius, value)
	function add_disk(X, Y, Rads, Val) {
		ds_grid_add_disk(raw, X, Y, Rads, Val)
		return self
	}

  ///@function multiply_disk(x, y, radius, value)
	function multiply_disk(X, Y, Rads, Val) {
		ds_grid_multiply_disk(raw, X, Y, Rads, Val)
		return self
	}

	///@function at(x, y)
	function at(X, Y) { return raw[# X, Y] }

	///@function get_on(index)
	function get_on(Index) {
		inner_iterator.set_index(Index)
		return at(inner_iterator.x, inner_iterator.y)
	}

	///@function exists(x1, y1, x2, y2, value)
	function exists(X1, Y1, X2, Y2, Val) { return ds_grid_value_exists(raw, X1, Y1, X2, Y2, Val) }

	///@function exists_disk(x, y, radius, value)
	function exists_disk(X, Y, Rads, Val) { return ds_grid_value_disk_exists(raw, X, Y, Rads, Val) }

	///@function max_region(x1, y1, x2, y2)
	function max_region(X1, Y1, X2, Y2) { return ds_grid_get_max(raw, X1, Y1, X2, Y2) }

	///@function min_region(x1, y1, x2, y2)
	function min_region(X1, Y1, X2, Y2) { return ds_grid_get_min(raw, X1, Y1, X2, Y2) }

	///@function mean_region(x1, y1, x2, y2)
	function mean_region(X1, Y1, X2, Y2) { return ds_grid_get_mean(raw, X1, Y1, X2, Y2) }

	///@function sum_region(x1, y1, x2, y2)
	function sum_region(X1, Y1, X2, Y2) { return ds_grid_get_sum(raw, X1, Y1, X2, Y2) }

	///@function max_disk(x, y, radius)
	function max_disk(X, Y, Rads) { return ds_grid_get_disk_max(raw, X, Y, Rads) }

	///@function min_disk(x, y, radius)
	function min_disk(X, Y, Rads) { return ds_grid_get_disk_min(raw, X, Y, Rads) }

	///@function mean_disk(x, y, radius)
	function mean_disk(X, Y, Rads) { return ds_grid_get_disk_mean(raw, X, Y, Rads) }

	///@function sum_disk(x, y, radius)
	function sum_disk(X, Y, Rads) { return ds_grid_get_disk_sum(raw, X, Y, Rads) }

	///@function check_all(x1, y1, x2, y2, predicate)
	function check_all(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred)
		for (var j = Y1; j < Y2; ++j) {
			for (var i = X1; i < X2; ++i) {
				if !pred(at(i, j))
					return false
			}
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred)
		for (var j = Y1; j < Y2; ++j) {
			for (var i = X1; i < X2; ++i) {
				if pred(at(i, j))
					return true
			}
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred)
		for (var j = Y1; j < Y2; ++j) {
			for (var i = X1; i < X2; ++i) {
				if pred(at(i, j))
					return false
			}
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred)
		for (var j = Y1; j < Y2; ++j) { // row first
			for (var i = X1; i < X2; ++i) {
				pred(at(i, j))
			}
		}
		return pred
	}

	///@function find(x1, y1, x2, y2, value)
	function find(X1, Y1, X2, Y2, Val) {
		for (var i = X1; i < X2; ++i) { // column first
			for (var j = Y1; j < Y2; ++j) {
				if at(i, j) == Val
					return wrap_coordinates(i, j, width)
			}
		}
		return undefined
	}

	///@function find_disk(x, y, radius, value)
	function find_disk(X, Y, Rads, Val) {
		var XR = ds_grid_value_disk_x(raw, X, Y, Rads, Val)
		var YR = ds_grid_value_disk_y(raw, X, Y, Rads, Val)
		if XR == -1 or YR == -1
			return undefined
		else
			return wrap_coordinates(XR, YR, width)
	}

	///@function find_if(x1, y1, x2, y2, predicate)
	function find_if(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred)
		for (var Val = 0, i = X1; i < X2; ++i) { // column first
			for (var j = Y1; j < Y2; ++j) {
				Val = at(i, j)
				if!is_undefined(Val) and pred(Val)
					return wrap_coordinates(i, j, width)
			}
		}
		return undefined
	}

	///@function count(x1, y1, x2, y2, value)
	function count(X1, Y1, X2, Y2, Val) {
		for (var i = X1, Result = 0; i < X2; ++i) {
			for (var j = Y1; j < Y2; ++j) {
				if at(i, j) == Val
					Result++
			}
		}
		return Result
	}

	///@function count_if(x1, y1, x2, y2, predicate)
	function count_if(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred), Result = 0
		for (var i = X1; i < X2; ++i) {
			for (var j = Y1; j < Y2; ++j) {
				if pred(at(i, j))
					Result++
			}
		}
		return Result
	}

	///@function swap(x1, y1, x2, y2)
	function swap(X1, Y1, X2, Y2) {
		var Temp = at(X1, Y1)
		set(X1, Y1, at(X2, Y2))
		set(X2, Y2, Temp)
	}

	///@function copy_to(x1, y1, x2, y2, destination_begin)
	function copy_to(X1, Y1, X2, Y2, DstIt) {
		var Dst = DstIt.container // Actual iteraters have its owner.
		var DstRaw = Dst.data()
		ds_grid_set_grid_region(DstRaw, raw, X1, Y1, X2, Y2, DstIt.x, DstIt.y)
	}

	///@function reverse(x1, y1, x2, y2)
	function reverse(X1, Y1, X2, Y2) {
		for (var j = Y1; j < Y2; ++j)
			reverse_column(j)
		for (var i = X1; i < X2; ++i)
			reverse_row(i)
	}

	///@function reverse_column(row)
	function reverse_column(Row) {
		if 1 < width {
			var First = 0, Last = width
			while (First != Last) and (First != --Last) {
		    swap(First, Row, Last, Row)
		    First++
		  }
		}
	}

	///@function reverse_row(column)
	function reverse_row(Column) {
		if 1 < height {
			var First = 0, Last = height
			while (First != Last) and (First != --Last) {
		    swap(Column, First, Column, Last)
		    First++
		  }
		}
	}

	///@function transform(x1, y1, x2, y2, predicate)
	function transform(X1, Y1, X2, Y2, Pred) {
		var pred = method(other, Pred), Val = 0
		for (var j = Y1; j < Y2; ++j) {
			for (var i = X1; i < X2; ++i) {
				Val = at(i, j)
				set(i, j, pred(Val))
			}
		}
	}

	///@function resize(width, height)
	function resize(Width, Height) {
		width = Width
		height = Height
		inner_size = width * height
		__iend.index = inner_size
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
	function clear(Val) { ds_grid_clear(raw, Val) }

	function sort_builtin(column, ascending) { ds_grid_sort(raw, column, ascending) }

	function shuffle_builtin() { ds_grid_shuffle(raw) }

	function destroy() {
		delete inner_iterator
		delete __iend
		ds_grid_destroy(raw)
		raw = undefined
	}
}

///@function wrap_coordinates(x, y, width)
function wrap_coordinates(X, Y, Width) {
	return X + Y * Width
}

///@function disemble_coordinates(index, width, height)
function disemble_coordinates(Index, Width, Height) {
	if Width == 1 {
		return [0, Index]
	} else if Height == 1 {
		return [Index, 0]
	} else {
		var factor = floor(Index / Width)
		return [Index - factor * Width, factor * Height]
	}
}

///@function GridIterator(container, index)
function GridIterator(Cont, Index): Iterator(Cont, Index) constructor {
	function update_coordinates() {
		var Result = disemble_coordinates(index, container.width, container.height)
		x = Result[0]
		y = Result[1]
	}

	x = 0
	y = 0
	update_coordinates()

	///@function set(value)
	function set(Val) { return container.set(x, y, Val) }

	///@function get()
	function get() { return container.at(x, y) }

	///@function set_index(index)
	function set_index(Index) {
		if index != Index {
			index = Index
			update_coordinates()
		}
		return index
	}

	///@function swap(other)
	function swap(Other) {
		var Temp = get()
		set(Other.get())
		Other.set(Temp)
	}

	function go_backward() {
		--index
		update_coordinates()
		return index
	}

	function go_forward() {
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
