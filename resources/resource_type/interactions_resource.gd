extends Resource

class_name Interaction

@export var step_id:String
@export var speaker:String
@export var text:String
@export var next_step:String

@export var interaction_triggers:Array[String] #All these flags need to be true (maybe make this into a string such that complex logic can be handeled?)
@export var interactions_options:Array[Interaction_Options]
@export var status: String = 'locked' # locked, open, completed - do not repeat interactions
