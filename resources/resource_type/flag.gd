extends Resource

class_name Flag

enum Flag_State {CLOSED, OPEN}

@export var condition: String
@export var status: Flag_State = Flag_State.CLOSED

func open_flag():
    status = Flag_State.OPEN

func close_flag():
    status = Flag_State.CLOSED