extends Resource

class_name Conversation

@export var name:String
@export var npc:String
@export var interaction_steps:Array[Interaction]
@export var flags:Array[Flag]
@export var flag_engine:Flag_Engine

var open_interactions:Array[Interaction]
var closed_interactions:Array[Interaction]

func initialize():
	#3. Create flag dictionary
	flag_engine.intialize_flags(flags)
	#2. Flag-Interaction dict for easier condition manipulation
	flag_engine.intialize_flag_inter_dict(interaction_steps)
	#3. Update open/closed arrays
	update_iteraction_arrays()


func start_conversation() -> Interaction:
	var curr_interaction = interaction_steps[0]
	return curr_interaction

#do i need this??
func update_iteraction_arrays(): #should add lazy updating instead of looping thorugh all interactions
	closed_interactions = []
	open_interactions = []

	for i in interaction_steps:
		if i.status == 'open':
			open_interactions.push_back(i)
		else:
			closed_interactions.push_back(i)

func update_interaction_status(interaction_step, status):
	var i = interaction_steps[interaction_step]
	i.status = status

func get_next_open_interaction(next_interaction_step: String):
	print(next_interaction_step)
	
	if next_interaction_step.length() > 0:
		update_interaction_status(next_interaction_step, 'completed') 
		return interaction_steps[int(next_interaction_step)]
	if next_interaction_step == 'end':
		return null


	var next_interaction = null

	for i in open_interactions:
		if next_interaction == null:
			next_interaction = i 
		elif int(i.step_id) < int(next_interaction.step_id):
			next_interaction = i
