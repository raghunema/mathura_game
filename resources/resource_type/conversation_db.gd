extends Resource

class_name Conversation_DB

@export var conversation_list:Array[Conversation]
@export var conv_dict: Dictionary = {}

func build_conv_dict()-> void:
	conv_dict.clear()
	for c in conversation_list:
		conv_dict[c.id] = c
