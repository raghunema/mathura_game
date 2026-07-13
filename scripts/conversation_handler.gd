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
	print("curr interaction: ", curr_interaction)
	print("interaction_option: ", curr_option.option_text)

	var opened_inters: Array[Flagged_Obj]
	for f in curr_option.option_flags:
		print("curr option flag: ", f)
		opened_inters = local_flag_engine.update_depen_statuses(f, Flag.Flag_State.OPEN)

	print("getting next open step")
	if curr_interaction.next_step != null and int(curr_interaction.next_step) != -1:
		var next_step = int(curr_interaction.next_step)
		curr_interaction = curr_conversation.interaction_steps[next_step]
		
	print("conversation handler: ", curr_interaction)
	display_interaction.emit(curr_interaction)

func end_conversation():
	#Clean up
	local_flag_engine = null
	curr_conversation = null
	curr_interaction = null

	#ui/gameController clean up
	hide_display.emit()
	end_conversation_sig.emit()
