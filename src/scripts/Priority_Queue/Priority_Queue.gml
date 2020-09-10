/*
	Constructors:
		Priority_Queue(comparator, stable)

	Initialize:
		new Priority_Queue(cmpfunc, boolean)

	Usage:
		function Build(Type, Priority, Upgradable) {
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
///@function Priority_Queue(comparator, [stable=true])
function Priority_Queue(Comparator, Is_Stable): Container() constructor {
	type = Priority_Queue
	raw = new List()
	comparator = Comparator
	is_stable = select_argument(Is_Stable, true)

	function duplicate() {
		var Result = new Priority_Queue(self.comparator, self.is_stable)
		for (var It = raw.first(); It != raw.last(); ++It)
			Result.push(raw.get(It))
		return Result
	}

	///@function push(value)
	function push(Value) { 
		raw.push_back(Value)
		var Size = raw.size()
		if 1 < Size {
			if is_stable
				raw.stable_sort(0, Size, comparator)
			else
				raw.sort(0, Size, comparator)
		}
	}

	///@function pop()
	function pop() { raw.pop_front() }

	///@function pop_front()
	function pop_front() { return raw.pop_front() }

	///@function emplace(tuple)
	function emplace(Params) { push(construct(Params)) }

	///@function top()
  function top() { return raw.front() }

	function size() { return raw.size() }

	function empty() { return raw.empty() }

	function clear() { raw.clear() }

	///@function read(data_string)
	function read(Str) { raw.read(Str) }

	function write() { return raw.write() }
}
