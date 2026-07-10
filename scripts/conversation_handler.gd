extends Node

signal end_conversation_sig(end_conversation: bool)
signal display_interaction(interaction: Interaction)
signal hide_display()


var curr_conversation:Conversation
var curr_interaction:Interaction
var local_flag_engine:Flag_Engine

func _ready() -> void:
	GameController.start_conversation.connect(start_conversation)


func start_conversation(conv):
	print("in start conversation (handler)")
	curr_conversation = conv
	curr_interaction = curr_conversation.get_start_interaction()


	local_flag_engine = Flag_Engine.new()
	#Start monitorting interactions?
	local_flag_engine.initialize_flags(curr_conversation.local_flags)

	display_interaction.emit(curr_interaction)

func get_next_open_interaction(curr_option: Interaction_Options):
	print(curr_option.option_text)
	for f in curr_option.option_flags:
		print(f.key, f.value)
		#curr_conversation.flag_enginge.update_interaction_statuses(f.key, f.value)
	
	print("getting next open step")
	var next_interaction = curr_conversation.get_next_open_interaction(curr_interaction.next_step)
	curr_interaction = next_interaction
	print("conversation handler: ", curr_interaction)
	display_interaction.emit(next_interaction)

func end_conversation():
	#Clean up
	local_flag_engine = null
	curr_conversation = null
	curr_interaction = null

	#ui/gameController clean up
	hide_display.emit()
	end_conversation_sig.emit()
