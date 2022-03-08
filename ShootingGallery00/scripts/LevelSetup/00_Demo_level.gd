# This is a container for initialising constants and expected behaviours 
# of pointing devices. 
#
# Rough algorithm:
# -------------------- 
# 0. Initialise device specific specific sensitivity (CDR) parameters  
# 1. Setup parameters for target assistance algorithms 

# Note: Godot gives us pixel level co-ordinate systems, therefore all measures are in pixels

extends Node

export var DEBUG_MODE = true


# Initialising 
# **************************
# using 'var' for semantic 'const's for GUI extension of parameterising  
# 
# Sensitivity for mouse 
export var MOUSE_SENSITIVITY_DEFAULT = 1


# Default movement delta for joystick
export var JOYSTICK_ANALOG_STICK_DELTA = 800

# Sensityivity for Joystick
export var JOYSTICK_SENSITIVITY_DEFAULT = 3

# A movement within 20% delta from initial state to be discarded
export var JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT = 0.2



# For target assitance algorithm
#
# Target area:
# ================
# Rough algo: 
# --------- 
# For a given player 
#   1. Calculate relative performance (source paper chose score difference)
#   2. Increase hit area of the pointer (at the beginning for static, in real-time for adaptive)
#
#  As (graphic) designed, an area of ~ 70 x 70 of hitbox is expected (defined at pointer instance)

export var targetAreaAssistOnJoystick = false;

export var TARGET_AREA_DEFAULT_RADIUS = 45

export var TARGET_AREA_ASSIST_RATIO_DEFAULT = 1.2 # Debug value

# final_target_area = pointer_instance_specific_default_target_area * (default_ratio + ((relative performance * delta)) 
export var TARGET_AREA_ASSIST_DELTA_DEFAULT = 0.01  

# for edge cases, where we do not want the assist to break the game semantic
# i.e the ratio final_target_area/actual_target_area to be constrained to <= 1.2
export var TARGET_AREA_ASSIST_MAX_RATIO_DEFAULT = 5 # Debug value



# Called when the node enters the scene tree for the first time.
#  Note: all child nodes' _ready() is called before their parent node's _ready()
func _ready():
	# Attach the pointer to the mouse 
	# TODO: make attachment dynamic as per selected input device
	# Input.warp_mouse_position(get_node("Pointer00Area2D").position)
	get_node("Pointer00Area2D").position = get_viewport().get_mouse_position()  	 
	
	# Register event to monitor if joystick connected or disconnected
	Input.connect("joy_connection_changed", self, "outputJoystickConnectionStatus")
	
	if DEBUG_MODE:
		print("[INFO] Visual debugger is on")
		# Show FPS counter
		get_node("Debug_FPS_counter").show()
	else:
		get_node("Debug_FPS_counter").hide()
		
	
	# Debug:
	if targetAreaAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		# print(pointerCollisionShape.shape.radius)
		pointerCollisionShape.shape.radius = TARGET_AREA_DEFAULT_RADIUS * TARGET_AREA_ASSIST_RATIO_DEFAULT


# Tutorial Ref: https://gamefromscratch.com/godot-3-tutorial-keyboard-mouse-and-joystick-input/
# Event based handling of pointer movement
func _input(event):
	if event is InputEventMouseMotion:
		# TODO: make attachment dynamic as per selected input device
		get_node("Pointer00Area2D").translate(event.relative * MOUSE_SENSITIVITY_DEFAULT)


# return first deviceId of a connected XBox Controller
# TODO: Move to a global scope
func getDeviceIdOfXboxController():
	# Check if at least 1 joystick is connected
	if Input.get_connected_joypads().size() > 0:
		# Get device id of first "Xbox 360 Controller" if present
		var XBOX_Controller_id = null
		for deviceId in Input.get_connected_joypads():
			if Input.get_joy_name(deviceId) == "Xbox 360 Controller":
				XBOX_Controller_id = deviceId
				break
		
		return XBOX_Controller_id
		
# return first deviceId of a connected XBox Controller
# TODO: Move to a global scope
func getDeviceIdOfPlaystationController():
	# Check if at least 1 joystick is connected
	if Input.get_connected_joypads().size() > 0:
		# Get device id of first "Xbox 360 Controller" if present
		var PS_Controller_id = null
		for deviceId in Input.get_connected_joypads():
			if Input.get_joy_name(deviceId) == "TODO - CHange to Dualshock":
				PS_Controller_id = deviceId
				break
		
		return PS_Controller_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
# Note: 
# this is simiar to the draw() function for processing
# Gravity assist needs to augment cursors here as it works irrespective of whether 
# the pointer is being moved or not
func _process(delta):
	if DEBUG_MODE:
		# Set FPS display
		get_node("Debug_FPS_counter").text = str(Performance.get_monitor(Performance.TIME_FPS))
	
	# Connect joystick to pointer movement and fire
	# ......... 
	var XBOX_Controller_id = getDeviceIdOfXboxController()
			
	# Found one!
	if XBOX_Controller_id != null:
		# Debug: Check all button presses
		# for button_id in range(JOY_BUTTON_MAX):
			# if Input.is_joy_button_pressed(XBOX_Controller_id, button_id):
				# print("Button id: " + str(button_id) + " pressed, named as: " + Input.get_joy_button_string(button_id))
		
		# Get the pointer node assigned to XBOX Controller 
		# TODO: make attachment dynamic as per selected input device
		var XboxPointerNodeSprite = get_node("Pointer01Area2D")
		
		# Global constants for right and left analog stick, Ref: @GlobalScope	
		var delX_RA = Input.get_joy_axis(XBOX_Controller_id, JOY_ANALOG_RX)
		var delY_RA = Input.get_joy_axis(XBOX_Controller_id, JOY_ANALOG_RY)
		
		var delX_LA = Input.get_joy_axis(XBOX_Controller_id, JOY_ANALOG_LX)
		var delY_LA = Input.get_joy_axis(XBOX_Controller_id, JOY_ANALOG_LY)
		
		var viewportMinX = 0 # By definition
		var viewportMinY = 0 # By definition
		var viewportMaxX = get_viewport().size.x
		var viewportMaxY = get_viewport().size.y
		# Note: Utilising augmented viewport sizes may be useful for atypical input devices  
		
		# for Right Analog
		# ---
		#   Translate x:
		if(abs(delX_RA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			# Algo: time_elapsed: constant_pixel_movement * joystick_cdr * value from analog stick
			XboxPointerNodeSprite.position.x += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_RA
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_RA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_RA
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.y > viewportMaxY): XboxPointerNodeSprite.position.y = viewportMaxY
			elif (XboxPointerNodeSprite.position.y < viewportMinY): XboxPointerNodeSprite.position.y = viewportMinY
		
		# for Left Analog
		# ---
		#   Translate x
		if(abs(delX_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.x += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_LA
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_LA
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.y > viewportMaxY): XboxPointerNodeSprite.position.y = viewportMaxY
			elif (XboxPointerNodeSprite.position.y < viewportMinY): XboxPointerNodeSprite.position.y = viewportMinY

func outputJoystickConnectionStatus(deviceId, isConnected):
	if isConnected: 
		if DEBUG_MODE:
			print("[INFO] Joystick id: " + str(deviceId) + " connected")
		
		# Check if input hw is recognised 
		if Input.is_joy_known(deviceId):
			if DEBUG_MODE:
				print("[INFO] Joystick recognised: " + Input.get_joy_name(deviceId))
	
	# at disconnection 
	else:
		if DEBUG_MODE:
			print("[INFO] Joystick id: " + str(deviceId) + " disconnected")
