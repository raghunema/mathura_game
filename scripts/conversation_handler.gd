extends Node

signal end_conversation_sig(end_conversation: bool)
signal display_interaction(interaction: Interaction)
signal hide_display(hide_display: bool)


var curr_conversation:Conversation
var curr_interaction:Interaction
var local_flag_engine:Flag_Engine

func _ready() -> void:
	GameController.start_conversation.connect(start_conversation)


func start_conversation(conv):
	print("(handler) in start conversation")
	curr_conversation = conv
	curr_interaction = curr_conversation.get_start_interaction()

	local_flag_engine = Flag_Engine.new()
	#Start monitorting interactions?
	local_flag_engine.initialize_flags(curr_conversation.local_flags)
	local_flag_engine.initialize_dict(curr_conversation.interaction_steps)

	display_interaction.emit(curr_interaction)

func get_next_open_interaction(curr_option: Interaction_Option):
	print("(handler) curr interaction: ", curr_interaction)
	print("(handler) interaction_option: ", curr_option.option_text)
	print("(handler)", curr_option.option_flags)

	var opened_inters: Array[Flagged_Obj] = []

	#Update Dependencies based on the current option's flags
	for f in curr_option.option_flags:
		print("curr option flag: ", f)

		var state: Flag.Flag_State 
		if curr_option.option_flags[f] == true:
			state = Flag.Flag_State.OPEN
		else:
			state = Flag.Flag_State.CLOSED

		var result = local_flag_engine.update_depen_statuses(f, state)
		var new_opened: Array[Flagged_Obj] = result["opened"]
		var new_closed: Array[Flagged_Obj] = result["closed"]

		#Don't appened duplicate interactions
		for i in new_opened: 
			if not opened_inters.has(i):
				opened_inters.append(i)
		
		for i in new_closed:
			if opened_inters.has(i):
				opened_inters.erase(i)


	print("(handler) getting next open step")
	#If the the next interaction is pre-defined
	if curr_interaction.next_step != null and int(curr_interaction.next_step) != -1:
		var next_step = int(curr_interaction.next_step)
		curr_interaction = curr_conversation.interaction_steps[next_step]


	#Explicitly over writing a predefined step if an interaction opens up	
	#If we need to figure what the next correct opened interaction will be 
	if opened_inters.size() > 0:
		curr_interaction = opened_inters[0]

		for i in opened_inters: # i is a 'Flagged_Obj' but works cause 'Interaction' extends 'Flagged_Obj'
			if i.step_id < curr_interaction.step_id:
				curr_interaction = i


	#print("(handler)", curr_interaction.text)
	display_interaction.emit(curr_interaction)

func end_conversation():
	#Clean up
	local_flag_engine = null
	curr_conversation = null
	curr_interaction = null

	#ui/gameController clean up
	hide_display.emit(true)
	end_conversation_sig.emit(true)
