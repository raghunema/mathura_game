extends Node

signal end_conversation_sig(end_conversation: bool)
signal display_interaction(interaction: Interaction)
signal hide_display()


var curr_conversation:Conversation
var curr_interaction:Interaction

func _ready() -> void:
	GameController.start_conversation.connect(start_conversation)


func start_conversation(conv):
	curr_conversation = conv
	curr_interaction = curr_conversation.start_conversation()

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
	hide_display.emit()
	end_conversation_sig.emit()
