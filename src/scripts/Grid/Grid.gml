/*
	Constructors:
		Grid(Width, Height)

	Initialize:
		new Multimap(width, height)
		set_value_type(type)

	Usage:
		To Iterate:
			for (var It = ibegin(); It != iend(); ++It)
				myfunc(get_key(It))

		To Iterate on lattices:
			

*/
///@function Grid(width, height)
function Grid(Width, Height): Container() constructor {
	// elements are aligned by raw (tracking x, horizontal, left to right)
	type = Grid
	raw = ds_grid_create(Width, Height)
	width = Width
	height = Height
	__ibegin = 0//new GridIterator(self, 0)
	__iend = width * height//new GridIterator(self, width * height)

	///@function ibegin()
  function ibegin() { return __ibegin }

	///@function iend()
  function iend() { return __iend }

  ///@function set(x, y, value)
	function set(X, Y, Val) {
		raw[# X, Y] = Val
		return self
	}

  ///@function set_region(x1, y1, x2, y2, value)
	function set_region(X1, Y1, X2, Y2, Val) {
		ds_grid_set_region(raw, X1, Y1, X2, Y2, Val)
		return self
	}

  ///@function set_disk(x, y, radius, value)
	function set_disk(X, Y, Rads, Val) {
		ds_grid_set_disk(raw, X, Y, Rads, Val)
		return self
	}

	///@function get(x, y)
	function get(X, Y) { return raw[# X, Y] }

	///@function check_all(x1, y1, x2, y2, predicate)
	function check_all(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !pred(Val)
				return false
			First++
		}
		return true
	}

	///@function check_any(begin, end, predicate)
	function check_any(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if pred(Val)
				return true
			First++
		}
		return false
	}

	///@function check_none(begin, end, predicate)
	function check_none(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if pred(Val)
				return false
			First++
		}
		return true
	}

	///@function foreach(begin, end, predicate)
	function foreach(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			pred(get(First))
			First++
		}
		return pred
	}

	///@function find(x1, y1, x2, y2, value)
	function find(X1, Y1, X2, Y2, Val) {
		var XR = ds_grid_value_x(X1, Y1, X2, Y2, Val)
		var YR = ds_grid_value_y(X1, Y1, X2, Y2, Val)
		if XR == -1 or YR == -1
			return undefined
		else
			return new GridIterator(XR, YR, self)
	}

	///@function find_disk(x, y, radius, value)
	function find_disk(X, Y, Rads, Val) {
		var XR = ds_grid_value_disk_x(X, Y, Rads, Val)
		var YR = ds_grid_value_disk_y(X, Y, Rads, Val)
		if XR == -1 or YR == -1
			return undefined
		else
			return new GridIterator(XR, YR, self)
	}

	///@function find_if(begin, end, predicate)
	function find_if(First, Last, Pred) {
		var pred = method(other, Pred)
		while First != Last {
			var Val = get(First)
			if !is_undefined(Val) and pred(Val)
				return First
			First++
		}
		return Last
	}

	///@function count(begin, end, value)
	function count(First, Last, Val) {
		for (var it = First, Result = 0; it != Last; ++it) {
			if get(it) == Val
				Result++
		}
		return Result
	}

	///@function count_if(begin, end, predicate)
	function count_if(First, Last, Pred) {
		var pred = method(other, Pred)
		for (var it = First, Result = 0; it != Last; ++it) {
			var Val = get(it)
			if pred(Val)
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
		//__iend.index = size()
		__iend = size()
		ds_grid_resize(raw, Width, Height)
	}

	///@function set_width(width)
	function set_width(Width) { resize(Width, height) }

	///@function set_height(height)
	function set_height(Height) { resize(width, Height) }

	///@function size()
	function size() { return width * height }

	///@function get_width()
	function get_width() { return width }

	///@function get_height()
	function get_height() { return height }

	///@function clear(value)
	function clear(Val) { ds_grid_clear(raw, Val) }

	function sort_builtin(column, ascending) { ds_grid_sort(raw, column, ascending) }

	function shuffle_builtin() { ds_grid_shuffle(raw) }

	function destroy() {
		ds_grid_destroy(raw)
		raw = undefined
	}
}

///@function GridIterator(container, index)
function GridIterator(Cont, Index): Iterator(Cont, Index) constructor {
	function update_coordinates() {
		var factor = floor(index / container.width)
		x = index - factor * container.width
		y = factor * container.height
	}

	x = 0
	y = 0
	update_coordinates()

	///@function set(value)
	function set(Val) { return container.set(x, y, Val) }

	///@function get()
	function get() { return container.get(x, y) }

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
