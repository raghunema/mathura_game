extends Resource

class_name Interaction

@export var step_id:String
@export var speaker:String
@export var text:String
@export var next_step:int

#@export var interaction_triggers:Array
@export var interactions_options:Array[Interaction_Options]
#@export var interaction_effects:Array[Effects] a set of effects/flags for the interaction
