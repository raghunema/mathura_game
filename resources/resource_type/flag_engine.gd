extends Resource

class_name Flag_Engine

var flags: Dictionary # flag.condition -> flag
var flag_interaction_dict: Dictionary # flag -> [interactions], if a flag changes, re-run if that interactions is open

#set a condition to a value
func set_flag(condition: String, val:bool):
	assert(flags.has(condition), "Flag not found: '%s'" % condition) #assert condition should make sure flag.condition exists

	var curr_flag = flags[condition] #dict for O(1) lookup
	curr_flag.status = val
	flags[condition] = curr_flag
	return curr_flag.status
			
#check if a flag is true/false
func check_flag(condition:String, val:bool):
	assert(flags.has(condition), "Flag not found: '%s'" % condition)

	var f = flags[condition]
	return f.status == val

#get a flag's value
func get_flag(condition: String):
	assert(flags.has(condition), "Flag not found: '%s'" % condition)
	var f = flags[condition]
	return f.status

func intialize_flags(conv_flags):
	for f in conv_flags:
		flags[f.condition] = f

func intialize_flag_inter_dict(interactions):
	for i in interactions:    
		for f in i.flags:
			if not flag_interaction_dict.has(f):
				flag_interaction_dict[f] = []
			
			flag_interaction_dict[f].append(i)


#update interactions are open/closed at the moment
func update_interaction_statuses(condition, value):
	self.set_flag(condition, value)

	for f in flags:
		if f.condition == condition:
			if not flag_interaction_dict.has(f):
				return
		
		for i in flag_interaction_dict[f]:
			if i.status == 'completed':
				continue

			var all_flags_met = true
			for cond in i.flags: #i.flags will be a set of strings or actually a flag object?
				if check_flag(cond, false):
					all_flags_met = false
					break

			i.status = 'open' if all_flags_met else 'locked'

		
