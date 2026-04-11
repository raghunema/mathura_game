extends Node

signal display_interaction(interaction: Interaction)
signal hide_display()

var conversation_db := load('res://resources/conversation_db.tres') as Conversation_DB 
var conversation_active = false
var curr_conversation:Conversation = null
var curr_interaction:Interaction = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	pass

#move this to npc script
func request_conversation(npc_id):
	if not conversation_active:
		#TO DO: find proper conversation here  and send the right one
		curr_conversation = conversation_db.conversation_list[0]
		
		if curr_conversation:
			conversation_active = true
			start_conversation(npc_id, curr_conversation)

func start_conversation(npc, conv):
	curr_conversation = conv
	curr_interaction = conv.interaction_steps[0]
	display_interaction.emit(curr_interaction) #emit signal to displayUI


func get_next_interaction(next_step: int):
	print(next_step)
	if next_step == 0:
		end_conversation()
		return

	curr_interaction = curr_conversation.interaction_steps[next_step]
	display_interaction.emit(curr_interaction)

func end_conversation():
	hide_display.emit()
	print('conversation ended')
	conversation_active = false
	curr_conversation = null
	curr_interaction = null
	

	

