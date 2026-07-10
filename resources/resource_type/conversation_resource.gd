extends Flagged_Obj #or resource

class_name Conversation

#Set of flags that will open this conversation will be in flagged_obj resource type
@export var name:String
@export var npc:String
@export var interaction_steps:Array[Interaction]
@export var local_flags:Array[String] #flags that the interactions care about


func get_start_interaction() -> Interaction:
	var curr_interaction = interaction_steps[0]
	return curr_interaction


# func update_interaction_status(interaction_step, status):
# 	var i = interaction_steps[interaction_step]
# 	i.status = status

# func get_next_open_interaction(next_interaction_step: String):
# 	print(next_interaction_step)
	
# 	if next_interaction_step.length() > 0:
# 		update_interaction_status(next_interaction_step, 'completed') 
# 		return interaction_steps[int(next_interaction_step)]
# 	if next_interaction_step == 'end':
# 		return null

#var next_interaction = null

# for i in open_interactions:
# 	if next_interaction == null:
# 		next_interaction = i 
# 	elif int(i.step_id) < int(next_interaction.step_id):
# 		next_interaction = i
