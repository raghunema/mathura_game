#singleton?
extends RefCounted
class_name Flag_Engine

var flags: Dictionary # flag.condition -> flag
var flag_depen_dict: Dictionary # flag -> [flag_dependency], if a flag changes, re-run if that dependency state
#var open_flagged_objs: Array[Flagged_Obj]

#set a condition to a value
func set_flag(condition: String, val:Flag.Flag_State):
	assert(flags.has(condition), "Flag not found: '%s'" % condition) #assert condition should make sure flag.condition exists

	var curr_flag = flags[condition] #dict for O(1) lookup

	if val == Flag.Flag_State.OPEN:
		curr_flag.open_flag()
	else:
		curr_flag.close_flag() 

	return curr_flag.status

#check if a flag is open/closed
func check_flag(condition:String, val:Flag.Flag_State):
	assert(flags.has(condition), "Flag not found: '%s'" % condition)

	var f = flags[condition]
	return f.status == val

#get a flag's value
func get_flag(condition: String):
	assert(flags.has(condition), "Flag not found: '%s'" % condition)
	var f = flags[condition]
	return f.status

func initialize_flags(conditions: Array[String]): #Array of conidtions
	for c in conditions:
		var new_flag = Flag.new()
		new_flag.condition = c
		flags[c] = new_flag

	for c in conditions:
		print(c, flags[c])

func add_flag_obj_to_dict(flagged_obj: Flagged_Obj):
	for cond in flagged_obj.flags: #string
		if not flag_depen_dict.has(cond):
			var arr: Array[Flagged_Obj] = []
			flag_depen_dict[cond] = arr
		
		flag_depen_dict[cond].append(flagged_obj)

func initialize_dict(fg_objs: Array[Flagged_Obj]):
	#we could duoble index this array based on if objs are locked/open/completed

	for fg_obj in fg_objs:
		add_flag_obj_to_dict(fg_obj)
	

#set flag and update flagged_objs based
func update_depen_statuses(condition: String, val: Flag.Flag_State):
	set_flag(condition, val)

	if not flag_depen_dict.has(condition):
		return 
	
	var affected: Array[Flagged_Obj] = flag_depen_dict[condition]
	var opened: Array[Flagged_Obj] = []

	for fg_obj in affected:
		var all_met := true

		for cond in fg_obj.flags: 
			if check_flag(cond, Flag.Flag_State.CLOSED):
				all_met = false
				break

		var org_state = fg_obj.state
		fg_obj.state = Flagged_Obj.State.OPEN if all_met else Flagged_Obj.State.LOCKED
		if (fg_obj.state == Flagged_Obj.State.OPEN) and (org_state != Flagged_Obj.State.OPEN):
			#open_flagged_objs.append(fg_obj)
			opened.append(fg_obj)

	return opened

		
