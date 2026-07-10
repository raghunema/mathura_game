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
