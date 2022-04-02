extends Area2D

var isButtonHitByJoy = false
var isButtonHitByMouse = false

# For only one hit
var hasButtonBeenHitOnceByJoy = false
var hasButtonBeenHitOnceByMouse = false

# Function that identifies joystick hit-able areas masquerading as buttons
func hitJoyButton():
	isButtonHitByJoy = true
	
func hitMouseButton():
	isButtonHitByMouse = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isButtonHitByJoy and (hasButtonBeenHitOnceByJoy == false):
		# print("		Collission partially captured") # Works
		if get_parent().get_parent().has_method("joystickFiredOnBeginButton"):
			get_parent().get_parent().joystickFiredOnBeginButton()
			hasButtonBeenHitOnceByJoy = true
			
	
	if isButtonHitByMouse and (hasButtonBeenHitOnceByMouse == false):
		# print("		Collission partially captured") # Works
		if get_parent().get_parent().has_method("mouseFiredOnBeginButton"):
			get_parent().get_parent().mouseFiredOnBeginButton()
			hasButtonBeenHitOnceByMouse = true
	
