extends Control

@onready var mainDialoguePanel = $DialgoueBox
@onready var npcName = $DialgoueBox/MarginContainer/VBoxContainer/NPCName
@onready var dialogueHolder = $DialgoueBox/MarginContainer/VBoxContainer/DialgoueText
@onready var optionsContainer = $DialgoueBox/MarginContainer/VBoxContainer/OptionsContainer
@onready var nextButton = $DialgoueBox/MarginContainer/VBoxContainer/Forward

# Called when the node enters the scene tree for the first time.
func _ready():
	print("in story_ui @ready:", ConversationHandler)
	hide_dialogue()
	ConversationHandler.display_interaction.connect(on_display_dialogue)
	ConversationHandler.hide_display.connect(hide_dialogue)
	nextButton.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_display_dialogue(interaction: Interaction):
	#reset options container
	for child in optionsContainer.get_children():
		child.queue_free()


	var interaction_step_id = interaction.step_id
	print("in story ui: ", interaction_step_id)

	var speaker = interaction.speaker
	var text = interaction.text
	var options = interaction.interactions_options

	if options.size() > 0: 

		for opt in options:
			var opt_button = Button.new()
			opt_button.text = opt.option_text
			opt_button.pressed.connect(_on_choice_press.bind(opt))
			optionsContainer.add_child(opt_button)
	else:
		nextButton.show()
		nextButton.pressed.connect(_on_choice_press.bind(interaction.next_step))
	
	npcName.text = speaker
	dialogueHolder.text = text
	
	show_dialogue()

func _on_choice_press(interaction_option):
	ConversationHandler.get_next_open_interaction(interaction_option)

func show_dialogue():
	mainDialoguePanel.visible = true

func hide_dialogue():
	mainDialoguePanel.visible = false
