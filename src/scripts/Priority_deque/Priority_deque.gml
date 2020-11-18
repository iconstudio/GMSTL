/*
	Constructors:
		Priority_deque()
		Priority_deque(Priority_deque) // duplicate
		Priority_deque(Arg)
		Priority_deque(Arg0, Arg1, ...)
		Priority_deque(Builtin-Array)
		Priority_deque(Builtin-List)
		Priority_deque(Container)
		Priority_deque(Iterator-Begin, Iterator-End)

	Initialize:
		new Priority_deque()

	Usage:
		si = 0
		function Build(Type, Priority, Index) constructor {
			type = Type
			priority = Priority
			index = Index
		}

		AI_Buildorder = new Priority_deque()
		AI_Buildorder.set_key_extractor(function(build) {
			return build.priority
		})
		AI_Buildorder.set_key_compare(function(A_priority, B_priority) {
			return bool(B_priority < A_priority)
		})

		AI_Buildorder.push(new Build("command_center", 150, si++))
		repeat 8
			AI_Buildorder.push(new Build("scv", 80, si++))
		AI_Buildorder.push(new Build("supply_depot", 80, si++))
		AI_Buildorder.push(new Build("scv", 80, si++))
		AI_Buildorder.push(new Build("barracks", 100, si++))

		do {
			show_debug_message(AI_Buildorder.pop_front())
		} until AI_Buildorder.empty()
		// Above items of priority 80 would not mixed up, because it is stable.

*/
function Priority_deque(): Container() constructor {
#region public
	///@function duplicate()
	static duplicate = function() {
		var Result = new Priority_deque()
		copy(raw.first(), raw.last(), Result.raw.first())
		return Result
	}

	///@function size()
	static size = function() { return raw.size() }

	///@function empty()
	static empty = function() { return raw.empty() }

	///@function front()
	static front = function() { return raw.front() }

	///@function back()
	static back = function() { return raw.back() }

	///@function push(value)
	static push = function(Value) { 
		if 0 < raw.size() {
			raw.push_back(Value)
			stable_sort(raw.first(), raw.last(), key_comparator)
		} else {
			raw.push_back(Value)
		}
	}

	///@function assign(begin, end)
	static assign = function(First, Last) {
		with raw {
			clear()
			foreach(First, Last, raw.push_back)
		}
		stable_sort(raw.first(), raw.last(), key_comparator)
	}

	///@function pop()
	static pop = function() { raw.pop_back() }

	///@function pop_front()
	static pop_front = function() { return raw.pop_front() }

	///@function pop_back()
	static pop_back = function() { return raw.pop_back() }

	///@function clear()
	static clear = function() { raw.clear() }

	///@function read(data_string)
	static read = function(Str) { raw.read(Str) }

	///@function write()
	static write = function() { return raw.write() }

	///@function destroy()
	static destroy = function() { raw.destroy(); delete raw }

	///@function set_key_extractor(compare_function)
	static set_key_extractor = function(Func) { key_extractor = Func }

	///@function set_key_compare(compare_function)
	static set_key_compare = function(Func) { key_inquire_comparator = method(other, Func) }

	static type = Priority_deque
	static is_iterable = false
#endregion

#region private
	///@function (index, value)
	static _Under_iterator_set = undefined

	///@function (index)
	static _Under_iterator_get = undefined

	///@function (value)
	static _Under_iterator_add = push

	///@function (index, value)
	static _Under_iterator_insert = undefined

	///@function (index)
	static _Under_iterator_next = undefined

	///@function (index)
	static _Under_iterator_prev = undefined

	raw = new List()
	key_extractor = function(Value) { return Value }
	key_inquire_comparator = compare_less
	key_comparator = function(a, b) {
		var A = key_extractor(a), B = key_extractor(b)
		if A == B
			return b < a
		else
			return key_inquire_comparator(A, B)
	}
#endregion

	// ** Contructor **
	if 0 < argument_count {
		if argument_count == 1 {
			var Item = argument[0]
			if is_array(Item) {
				// (*) Built-in Array
				for (var i = 0; i < array_length(Item); ++i) push(Item[i])
			} else if !is_nan(Item) and ds_exists(Item, ds_type_list) {
				// (*) Built-in List
				for (var i = 0; i < ds_list_size(Item); ++i) push(Item[| i])
			} else if Item.is_iterable {
				// (*) Container
				assign(Item.first(), Item.last())
			} else {
				// (*) Arg
				push(Item)
			}
		} else {
			// (*) Iterator-Begin, Iterator-End
			if argument_count == 2 {
				if is_struct(argument[0]) and is_iterator(argument[0])
				and is_struct(argument[1]) and is_iterator(argument[1]) {
					assign(argument[0], argument[1])
					exit
				}
			}
			// (*) Arg0, Arg1, ...
			for (var i = 0; i < argument_count; ++i) push(argument[i])
		}
	}
}
