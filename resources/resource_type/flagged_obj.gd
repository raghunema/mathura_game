extends Resource

class_name Flagged_Obj

enum State {LOCKED, OPEN, COMPLETED}

@export var state: State = State.LOCKED
@export var flags: Array[String] = []

# #or do this inside the flag_engine itself??
# func _on_flags_changed(flag_engine: Flag_Engine) -> void: 
# 	var all_met = true

# 	for cond in flags: 
# 		if flag_engine.check_flag(cond, false):
# 			all_met = false
# 			break

# 	state = State.OPEN if all_met else State.LOCKED
