///@function Priority_Queue([comparator=compare_less], [stable=true])
/*
	Constructors:
		Priority_Queue(cmpfunc, boolean)

	Initialize:
		new Priority_Queue(cmpfunc, flag)

	Usage:
		function Build(Type, Priority, Upgradable) constructor {
			type = Type
			priority = Priority
			upg_enabled = Upgradable
		}

		AI_Buildorder = new Priority_Queue(function(build_1, build_2) {
			return bool(build1.priority < build2.priority)
		})

		AI_Buildorder.push(new Build(Bldg.Terran.command_center, 150, false))
		repeat 9
			AI_Buildorder.push(new Build(Unit.Terran.scv, 80, false))
		AI_Buildorder.push(new Build(Bldg.Terran.supply_depot, 80, false))
		// Above items of priority 80 would not mixed up, because it is a stable queue.
	
*/
function Priority_Queue(Comparator, Is_Stable): Container() constructor {
	///@function duplicate()
	static duplicate = function() {
		var Result = new Priority_Queue(comparator, self.is_stable)
		copy(raw.first(), raw.last(), Result.raw.first())
		return Result
	}

	///@function size()
	static size = function() { return raw.size() }

	///@function top()
  static top = function() { return raw.front() }

	///@function cfirst()
  static cfirst = function() { return raw.cfirst() }

	///@function clast()
  static clast = function() { return raw.clast() }

	///@function push(value)
	static push = function(Value) { 
		if 1 < raw.size() {
			var Last = raw.last()
			var Position = lower_bound(raw.first(), Last, Value, comparator)
			if Position.not_equals(Last) and !comparator(Value, Position.get())
				raw.insert(Position.get_index(), Value)
			else
				raw.push_back(Value)
			//sorter(raw.first(), raw.last(), comparator)
		} else {
			raw.push_back(Value)
		}
	}

	///@function pop()
	static pop = function() { raw.pop_front() }

	///@function pop_front()
	static pop_front = function() { return raw.pop_front() }

	///@function empty()
	static empty = function() { return raw.empty() }

	///@function clear()
	static clear = function() { raw.clear() }

	///@function read(data_string)
	static read = function(Str) { raw.read(Str) }

	///@function write()
	static write = function() { return raw.write() }

	type = Priority_Queue
	raw = new List()
	comparator = select_argument(Comparator, compare_less)
	is_stable = select_argument(Is_Stable, true)
	sorter = integral(is_stable, stable_sort, sort) 
}
