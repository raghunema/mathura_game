extends Node

var conversation_db := load('res://resources/conversation_db.tres') as Conversation_DB 
var conversation_active = false
var curr_conversation:Conversation = null

signal start_conversation(conv: Conversation)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	pass

#move this to npc script
func request_conversation(npc_id):
	print("requesting conversationw with: ", npc_id)
	if not conversation_active:
		#TO DO: find proper conversation here  and send the right one
		curr_conversation = conversation_db.conversation_list[0]
		print("starting conversation:", curr_conversation.name)
		if curr_conversation:
			conversation_active = true
			start_conversation.emit(curr_conversation)
	

func end_conversation():
	print('conversation ended')
	conversation_active = false
	curr_conversation = null

	

	
