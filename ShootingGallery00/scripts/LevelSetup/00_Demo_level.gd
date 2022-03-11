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

# Sensitivity for mouse 
var MOUSE_SENSITIVITY_DEFAULT = 1


# Default movement delta for joystick
var JOYSTICK_ANALOG_STICK_DELTA = 800

# Sensityivity for Joystick
var JOYSTICK_SENSITIVITY_DEFAULT = 3

# A movement within 20% delta from initial state to be discarded
var JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT = 0.2


# Initialise pointer sizes 
# **************************
const INITIAL_POINTER_RADIUS = 45           # By graphic design (need this as a ratio to override to final sizes)
export var POINTER_RADIUS = 30      # Parameter to be set depending on screen size, player distance from screen and visual clarity (Human factors)

var pointerMouseRadius = POINTER_RADIUS
var pointerJoystickRadius = POINTER_RADIUS

# Initialise target sizes
const INITIAL_TARGET_RADIUS = 100          # By graphic design
export var TARGET_RADIUS = 100     # Parameterised


# Initialise scores
# ****************** 
var pointer00Score = 0 
var pointer01Score = 0

var DEFAULT_POINT_PER_HIT = 15

# Helper function called on successful hit by "Pointer00Area2D.gd"
func incrementPointer00Score():
	pointer00Score += 1
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)

# Helper function called function on successful hit by "PointerArea01Area2D.gd"
func incrementPointer01Score():
	pointer01Score += 1
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)


# For target assitance algorithm
#
# Pointer hit area (source paper named as Target Area):
# ================
# Rough algo: 
# --------- 
# For a given player 
#   1. Calculate relative performance (source paper chose score difference)
#   2. Increase hit area of the pointer (at the beginning for static, in real-time for adaptive)
#
#  As (graphic) designed, an radius of 45px of hitbox from enter is expected (defined at pointer instance)

export var targetAreaStaticAssistOnJoystick = false;
export var targetAreaStaticAssistOnMouse = false;

export var TARGET_AREA_STATIC_ASSIST_RATIO_DEFAULT = 1.2 # Debug value

export var targetAreaAdaptiveAssistOnJoystick = true;

# final_target_area = pointer_instance_specific_default_target_area * (default_ratio + ((relative performance * delta)) 
# export var TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT = 0.01 # ~> 1% increase w.r.t score difference  
export var TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT = 0.10  # For obvious demo

# for edge cases, where we do not want the assist to break the game semantic
# i.e the ratio final_target_area/actual_target_area to be constrained to <= 1.2
export var TARGET_AREA_ADAPTIVE_ASSIST_MAX_ASSIST = 20 # Debug value

func augmentAnyPointerTargetAreaStatic(pointerCollisionShape):
	var originalRadius = pointerCollisionShape.shape.radius
	pointerCollisionShape.shape.radius = INITIAL_POINTER_RADIUS * TARGET_AREA_STATIC_ASSIST_RATIO_DEFAULT
	var finalRadius = pointerCollisionShape.shape.radius
		
	if DEBUG_MODE:
		print("[INFO] Static Target Area assist enabled on " + pointerCollisionShape.get_name() + ": pointer radius changed from " + str(originalRadius) + " to " + str(finalRadius))

func augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape):
	var scoreDifference = pointer00Score - pointer01Score
		
	var relativePerformance = 1  # Default when scores are at par or joystick pointer is performing better
		
	if scoreDifference > 0:
		relativePerformance = min(TARGET_AREA_ADAPTIVE_ASSIST_MAX_ASSIST, scoreDifference)
		
	var originalRadius = pointerCollisionShape.shape.radius
	pointerCollisionShape.shape.radius = INITIAL_POINTER_RADIUS * (1.0 + (TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT * relativePerformance) ) 
	var finalRadius = pointerCollisionShape.shape.radius
	
	if originalRadius != finalRadius:
		print("[INFO] Adaptive Target Area assist enabled on Joystick: pointer radius changed from " + str(originalRadius) + " to " + str(finalRadius))




# Sticky targets:
# ================
# Rough algo: 
# --------- 
# For a given player 
#   1. If their porinter hit area is overlapping with target area, reduce CDR (i.e. augment sensitivity)




# Hidden variables always accounted for when calculating movement
var stickyDampJoystick = 1.0
var stickyDampMouse = 1.0

export var stickyTargetStaticAssistOnMouse = true;
export var STICKY_TARGET_ASSIST_STATIC_MOUSE_SENSITIVITY_DAMP = 0.5

export var stickyTargetStaticAssistOnJoystick = true;
export var STICKY_TARGET_ASSIST_STATIC_JOYSTICK_SENSITIVITY_DAMP = 0.2     # For obvious demo

# Called by "Pointer00Area2D.gd"
func setDampMouse():
	if stickyTargetStaticAssistOnMouse:
		stickyDampMouse = STICKY_TARGET_ASSIST_STATIC_MOUSE_SENSITIVITY_DAMP
		if DEBUG_MODE:
			print("[INFO] Sticky target activated for mouse pointer")
		
func unsetDampMouse():
	if stickyTargetStaticAssistOnMouse:
		stickyDampMouse = 1.0 # Reset value
		if DEBUG_MODE:
			print("[INFO] Sticky target de-activated for mouse pointer")
			

# Called by "Pointer01Area2D.gd"
func setDampJoystick():
	if stickyTargetStaticAssistOnMouse:
		stickyDampJoystick = STICKY_TARGET_ASSIST_STATIC_JOYSTICK_SENSITIVITY_DAMP
		if DEBUG_MODE:
			print("[INFO] Sticky target activated for joystick pointer")
		
func unsetDampJoystick():
	if stickyTargetStaticAssistOnMouse:
		stickyDampJoystick = 1.0 # Reset value
		if DEBUG_MODE:
			print("[INFO] Sticky target de-activated for joystick pointer")


# Called when the node enters the scene tree for the first time.
#  Note: all child nodes' _ready() is called before their parent node's _ready()
func _ready():
	
	# Override pointer sizes
	var pointerScaleFactor = POINTER_RADIUS / float(INITIAL_POINTER_RADIUS)
	
	if DEBUG_MODE:
		print("[INFO] Scaling pointer sizes to: x" + str(pointerScaleFactor))
	get_node("Pointer00Area2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	get_node("Pointer01Area2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	
	# Scaling on fire effects
	get_node("pointer_00_on_mouse_down_particle2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	get_node("pointer_01_on_RT_particle2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	
	# Override target sizes
	# TODO: Change to class based access
	# TODO: Add guard clauses
	var targetScaleFactor = TARGET_RADIUS / float(INITIAL_TARGET_RADIUS)
	if DEBUG_MODE:
		print("[INFO] Scaling target sizes to: x" + str(targetScaleFactor))
	for targetArea2D in get_node("Shooting_gallery_config_00").get_children():
		# Debug: 
		# print(targetArea2D.get_name())
		targetArea2D.scale = Vector2(targetScaleFactor, targetScaleFactor)
		
	if DEBUG_MODE: 
		print("[INFO] Screen size: " + str(OS.get_screen_size().x) + "px x " + str(OS.get_screen_size().y) + "px")
		print("[INFO] Screen DPI: " + str(OS.get_screen_dpi()))
		print("[INFO] Pointer radius: " + str(POINTER_RADIUS) + "px, Target radius: " + str(TARGET_RADIUS) + "px")
	
	
	
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
		
		
	# Attach each pointer's score to labels
	get_node("ScoreUI/Pointer00Score").text = str(pointer00Score * DEFAULT_POINT_PER_HIT)
	get_node("ScoreUI/Pointer01Score").text = str(pointer01Score * DEFAULT_POINT_PER_HIT)
	# get_node("ScoreUI/Pointer00Score").text = str(9999999999)
	# get_node("ScoreUI/Pointer01Score").text = str(9999999999)
	
	# Joystick Pointer hit area augment on start
	if targetAreaStaticAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentAnyPointerTargetAreaStatic(pointerCollisionShape)
		
	elif targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)
		
	
	# Mouse Pointer hit area augment on start 
	if targetAreaStaticAssistOnMouse: 
		var pointerCollisionShape = get_node("Pointer00Area2D/Pointer00HitArea")
		augmentAnyPointerTargetAreaStatic(pointerCollisionShape)


# Tutorial Ref: https://gamefromscratch.com/godot-3-tutorial-keyboard-mouse-and-joystick-input/
# Event based handling of pointer movement
func _input(event):
	if event is InputEventMouseMotion:
		# TODO: make attachment dynamic as per selected input device
		get_node("Pointer00Area2D").translate(event.relative * MOUSE_SENSITIVITY_DEFAULT * stickyDampMouse)


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
	
	# Refresh each pointer's score to labels
	get_node("ScoreUI/Pointer00Score").text = str(pointer00Score * DEFAULT_POINT_PER_HIT)
	get_node("ScoreUI/Pointer01Score").text = str(pointer01Score * DEFAULT_POINT_PER_HIT)
	
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
			# Algo:                        time_elapsed * constant_pixel_movement * joystick_cdr * value from analog stick
			XboxPointerNodeSprite.position.x += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_RA * stickyDampJoystick
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_RA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_RA * stickyDampJoystick
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.y > viewportMaxY): XboxPointerNodeSprite.position.y = viewportMaxY
			elif (XboxPointerNodeSprite.position.y < viewportMinY): XboxPointerNodeSprite.position.y = viewportMinY
		
		# for Left Analog
		# ---
		#   Translate x
		if(abs(delX_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.x += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_LA * stickyDampJoystick
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_LA * stickyDampJoystick
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
