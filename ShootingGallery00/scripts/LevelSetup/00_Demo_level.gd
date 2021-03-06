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

# For logging time 
# ******************** 

onready var start_time = OS.get_ticks_msec()

func getElapsedTime():
	return (OS.get_ticks_msec() - start_time)

# Initialising 
# **************************
# using 'var' for semantic 'const's for GUI extension of parameterising  

# Sensitivity for mouse 
var MOUSE_SENSITIVITY_DEFAULT = 1 # Hacky bad PX fix: change to 2 so mouse can have full coverage in-spite of sticky targeting 

# Flags to wrap mouse pointer to the other side when an edge is reached (so for the player the screen becomes an infinite area to point with)
var didJustWarpMouseX = false
var didJustWarpMouseY = false


# Default movement delta for joystick
var JOYSTICK_ANALOG_STICK_DELTA = 800

# Sensityivity for Joystick
var JOYSTICK_SENSITIVITY_DEFAULT = 3

# A movement within 20% delta from initial state to be discarded
var JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT = 0.2


# Initialise pointer sizes 
# **************************
const INITIAL_POINTER_HIT_RADIUS = 1 # As per source paper, decoupling hit area to visual area       

const INITIAL_POINTER_RADIUS = 45        # By graphic design (need this as a ratio to override to final sizes)
const INTIAL_POINTER_SPRITE_SCALE = 0.5  # By graphic design
export var POINTER_RADIUS = 20           # Parameter to be set depending on screen size, player distance from screen and visual clarity (Human factors)

var pointerScaleFactor = POINTER_RADIUS / float(INITIAL_POINTER_RADIUS)

var pointerMouseRadius = POINTER_RADIUS
var pointerJoystickRadius = POINTER_RADIUS

# Initialise target sizes
const INITIAL_TARGET_RADIUS = 100          # By graphic design
export var TARGET_RADIUS = 100     # Parameterised


# Initialise scores
# ****************** 
var pointer00Score = 0 
var pointer01Score = 0

var DEFAULT_POINT_PER_HIT = 1

# Helper function to log change in pointer gravitational constant
func logChangeInGravity():
	# Logging change in gravity
	if gravityJoystick != NO_GRAVITY_CONSTANT:
		print("[" + str(getElapsedTime()) + "][INFO] Joystick: gravitational constant changed to: " + str(gravityJoystick))
		
	if gravityMouse != NO_GRAVITY_CONSTANT:
		print("[" + str(getElapsedTime()) + "][INFO] Mouse: gravitational constant changed to: " + str(gravityMouse))
		

func logScore():
	print("[" + str(getElapsedTime()) + "][SCORE] Mouse: " + str(pointer00Score) + ", Joystick: " + str(pointer01Score))

# Helper function called on successful hit by "Pointer00Area2D.gd"
func incrementPointer00Score():
	pointer00Score += 1
	logScore()
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)
	
	if targetAreaAdaptiveAssistOnMouse:
		var pointerCollisionShape = get_node("Pointer00Area2D/Pointer00HitArea")
		augmentMousePointerTargetAreaAdaptive(pointerCollisionShape)
		
	logChangeInGravity()

func decrementPointer00Score():
	pointer00Score -= 1
	logScore()
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)
	
	if targetAreaAdaptiveAssistOnMouse:
		var pointerCollisionShape = get_node("Pointer00Area2D/Pointer00HitArea")
		augmentMousePointerTargetAreaAdaptive(pointerCollisionShape)
		
	logChangeInGravity()

# Helper function called function on successful hit by "PointerArea01Area2D.gd"
func incrementPointer01Score():
	pointer01Score += 1
	logScore()
	
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)

	if targetAreaAdaptiveAssistOnMouse:
		var pointerCollisionShape = get_node("Pointer00Area2D/Pointer00HitArea")
		augmentMousePointerTargetAreaAdaptive(pointerCollisionShape)
		
	logChangeInGravity()

func decrementPointer01Score():
	pointer01Score -= 1
	logScore()
	
	
	if targetAreaAdaptiveAssistOnJoystick:
		var pointerCollisionShape = get_node("Pointer01Area2D/Pointer01HitArea")
		augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape)

	if targetAreaAdaptiveAssistOnMouse:
		var pointerCollisionShape = get_node("Pointer00Area2D/Pointer00HitArea")
		augmentMousePointerTargetAreaAdaptive(pointerCollisionShape)
		
	logChangeInGravity()


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

var targetAreaStaticAssistOnJoystick = false; # Out of scope for experiment
var targetAreaStaticAssistOnMouse = false;    # Out of scope for experiment

export var TARGET_AREA_STATIC_ASSIST_FINAL_RADIUS = 20 # Final combination parameter
var TARGET_AREA_ADAPTIVE_ASSIST_MAX_DELTA = 10 # 10 levels as per source paper

export var targetAreaAdaptiveAssistOnJoystick = true;
export var targetAreaAdaptiveAssistOnMouse = true;

# final_target_area = pointer_instance_specific_default_target_area * (default_ratio + ((relative performance * delta)) 
var TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT = float (TARGET_AREA_STATIC_ASSIST_FINAL_RADIUS / TARGET_AREA_ADAPTIVE_ASSIST_MAX_DELTA) # ~> 1% increase w.r.t score difference 
# export var TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT = 0.10  # For obvious demo

# for edge cases, where we do not want the assist to break the game semantic
# i.e the ratio final_target_area/actual_target_area to be constrained to <= 1.2


func augmentAnyPointerTargetAreaStatic(pointerCollisionShape):
	var originalRadius = pointerCollisionShape.shape.radius
	
	pointerCollisionShape.shape.radius = TARGET_AREA_STATIC_ASSIST_FINAL_RADIUS
	var finalRadius = pointerCollisionShape.shape.radius
		
	if DEBUG_MODE:
		print("[" + str(getElapsedTime()) + "][INFO] Static Target Area assist enabled on " + pointerCollisionShape.get_name() + ": hit radius changed from " + str(originalRadius) + " to " + str(finalRadius))

func augmentJoystickPointerTargetAreaAdaptive(pointerCollisionShape):
	var scoreDifference = pointer00Score - pointer01Score
		
	var relativePerformance = 0  # Default when scores are at par or joystick pointer is performing better
		
	if scoreDifference > 0:
		relativePerformance = min(TARGET_AREA_ADAPTIVE_ASSIST_MAX_DELTA, scoreDifference)
		
	var originalRadius = pointerCollisionShape.shape.radius
	# pointerCollisionShape.shape.radius = INITIAL_POINTER_RADIUS * (TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT * relativePerformance) 
	var finalRadius = float(TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT * relativePerformance) 
	
	# Guard clause, keeping minimum radius as 1px 
	if finalRadius < INITIAL_POINTER_HIT_RADIUS:
		finalRadius = INITIAL_POINTER_HIT_RADIUS
		
	pointerCollisionShape.shape.radius =  finalRadius
	
	if originalRadius != finalRadius:
		print("[" + str(getElapsedTime()) + "][INFO] Joystick: hit radius changed from " + str(originalRadius) + " to " + str(finalRadius))
		

func augmentMousePointerTargetAreaAdaptive(pointerCollisionShape):
	var scoreDifference =  pointer01Score - pointer00Score
		
	var relativePerformance = 0  # Default when scores are at par or mouse pointer is performing better
		
	if scoreDifference > 0:
		relativePerformance = min(TARGET_AREA_ADAPTIVE_ASSIST_MAX_DELTA, scoreDifference)
		
	var originalRadius = pointerCollisionShape.shape.radius
	# pointerCollisionShape.shape.radius = INITIAL_POINTER_RADIUS * (1.0 + (TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT * relativePerformance) ) 
	var finalRadius = float(TARGET_AREA_ADAPTIVE_ASSIST_DELTA_DEFAULT * relativePerformance) 
	
	# Guard clause, keeping minimum radius as 1px 
	if finalRadius < INITIAL_POINTER_HIT_RADIUS:
		finalRadius = INITIAL_POINTER_HIT_RADIUS
	
	pointerCollisionShape.shape.radius = finalRadius
	
	if originalRadius != finalRadius:
		print("[" + str(getElapsedTime()) + "][INFO] Mouse: hit radius changed from " + str(originalRadius) + " to " + str(finalRadius))




# Sticky targets:
# ================
# Rough algo: 
# --------- 
# For a given player 
#   1. If their porinter hit area is overlapping with target area, reduce CDR (i.e. augment sensitivity)

# Hidden variables always accounted for when calculating movement
var NO_DAMP = 1.0   # For no damping

var stickyDampJoystick = NO_DAMP
var stickyDampMouse = NO_DAMP

var stickyTargetStaticAssistOnMouse = false; # Out of scope for experiment
var stickyTargetStaticAssistOnJoystick = false; # Out of scope for experiment

# Note: right now static assists overrides adaptive assists, check setDamp* and unsetDamp* helper functions
export var stickyTargetAdaptiveAssistOnMouse = true;
export var STICKY_TARGET_ASSIST_STATIC_MOUSE_SENSITIVITY_DAMP = 0.4 # Final combination parameter
var STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE = 10  # 10 levels as per source paper
var STICKY_TARGET_ADAPTIVE_ASSIST_DELTA_MOUSE = float(STICKY_TARGET_ASSIST_STATIC_MOUSE_SENSITIVITY_DAMP / STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE)    # Final combinationa parameter


export var stickyTargetAdaptiveAssistOnJoystick = true;
export var STICKY_TARGET_ASSIST_STATIC_JOYSTICK_SENSITIVITY_DAMP = 0.4  # Final combination parameter
var STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK = 10 # 10 levels as per source paper
var STICKY_TARGET_ADAPTIVE_ASSIST_DELTA_JOYSTICK = float(STICKY_TARGET_ASSIST_STATIC_JOYSTICK_SENSITIVITY_DAMP / STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK)   # Final combinationa parameter


# Called by "Pointer00Area2D.gd"
func setDampMouse():
	if stickyTargetStaticAssistOnMouse:
		stickyDampMouse = STICKY_TARGET_ASSIST_STATIC_MOUSE_SENSITIVITY_DAMP
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Static Sticky target activated for mouse pointer with damping of: " + str(stickyDampMouse))
	
	
	elif stickyTargetAdaptiveAssistOnMouse: 
		var scoreDifference = pointer01Score - pointer00Score
		
		var relativePerformance = 0  # Default when scores are at par or mouse pointer is performing better
		
		if scoreDifference > 0:
			relativePerformance = min(STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE, scoreDifference)
			
		stickyDampMouse = NO_DAMP - (STICKY_TARGET_ADAPTIVE_ASSIST_DELTA_MOUSE * relativePerformance)
		if stickyDampMouse != NO_DAMP:
			print("[" + str(getElapsedTime()) + "][INFO] Adaptive Sticky target activated for mouse pointer with damping of: " + str(stickyDampMouse))
		
func unsetDampMouse():
	if stickyTargetStaticAssistOnMouse: 
		stickyDampMouse = NO_DAMP # Reset value
		# Force mouse cursor to pointer to mitigate unreachable areas
		# Input.warp_mouse_position(get_node("Pointer00Area2D").position) # Doeesn't work as wrapping is detected as mouse movement 
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Static Sticky target de-activated for mouse pointer")
			
	elif stickyTargetAdaptiveAssistOnMouse: # Note: extra branch just for logging, could've concataneted with the above
		var oldStickyDampMouse = stickyDampMouse
		stickyDampMouse = NO_DAMP # Reset value
		if DEBUG_MODE and (oldStickyDampMouse != NO_DAMP):
			print("[" + str(getElapsedTime()) + "][INFO] Adaptive Sticky target de-activated for mouse pointer")

# Called by "Pointer01Area2D.gd"
func setDampJoystick():
	if stickyTargetStaticAssistOnMouse:
		stickyDampJoystick = STICKY_TARGET_ASSIST_STATIC_JOYSTICK_SENSITIVITY_DAMP
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Static Sticky target activated for joystick pointe with damping of: " + str(stickyDampJoystick))
			
	elif stickyTargetAdaptiveAssistOnJoystick: 
		var scoreDifference =  pointer00Score - pointer01Score
		
		var relativePerformance = 0  # Default when scores are at par or joystick pointer is performing better
		
		if scoreDifference > 0:
			relativePerformance = min(STICKY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK, scoreDifference)
			
		stickyDampJoystick = NO_DAMP - (STICKY_TARGET_ADAPTIVE_ASSIST_DELTA_JOYSTICK * relativePerformance)
		if stickyDampJoystick != NO_DAMP: 
			print("[" + str(getElapsedTime()) + "][INFO] Adaptive Sticky target activated for joystick pointer with damping of: " + str(stickyDampJoystick))
		
func unsetDampJoystick():
	if stickyTargetStaticAssistOnMouse:
		stickyDampJoystick = NO_DAMP # Reset value
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Static Sticky target de-activated for joystick pointer")
			
	elif stickyTargetAdaptiveAssistOnJoystick: # Note: extra branch just for logging, could've concataneted with the above
		var oldStickyDampJoystick = stickyDampJoystick
		stickyDampJoystick = NO_DAMP # Reset value
		if DEBUG_MODE and (oldStickyDampJoystick != NO_DAMP):
			print("[" + str(getElapsedTime()) + "][INFO] Adaptive Sticky target de-activated for joystick pointer")

# Target Gravity technique: Gravity offset by target
# ================
# Rough algo: 
# --------- 
# For a given game state 
#   1. Calculte the offset in the movement of a pointer w.r.t weights of targets (still possible to shoot) 
#   2. Apply the offset to the relative movement of the pointer

# Hidden variables always accounted for when calculating movement
var NO_GRAVITY_OFFSET = Vector2(0.0, 0.0)   # Default value passed into every pointer render loop
# var TARGET_RADIUS_WEIGHT_BETA = 1     # Diminishing the radial weight, doesn't work

var SCALE_GRAVITY_EFFECT_MOUSE = 0.001    # This gives some control

var SCALE_GRAVITY_EFFECT_JOYSTICK = 0.10  # Need different scaling to escape gravity well for the same gravitational constant as mouse, experimentally determined 

# Hidden variables to swith from static or adaptive gravity as set
var NO_GRAVITY_CONSTANT = 0.0
var gravityMouse = NO_GRAVITY_CONSTANT     #  Default with no gravity 
var gravityJoystick = NO_GRAVITY_CONSTANT  #  Default with no gravity

var gravityOffsetMouse = NO_GRAVITY_OFFSET
var gravityOffsetJoystick = NO_GRAVITY_OFFSET

var gravityTargetStaticAssistOnMouse = false; # Out of scope for experiment
export var GRAVITY_TARGET_STATIC_ASSIST_MOUSE = 1.0 # Final combination parameter 
# export var GRAVITY_TARGET_STATIC_ASSIST_MOUSE = 2.0/1000000000000000000 # Still doesn't work as bulleseyes are way too big w.r.t source experiment

export var gravityTargetAdaptiveAssistOnMouse = true; 
var GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE = 10 # 10 levels as per source paper
var GRAVITY_TARGET_ADAPTIVE_ASSIST_DELTA_MOUSE = float(GRAVITY_TARGET_STATIC_ASSIST_MOUSE / float(GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE))  


var gravityTargetStaticAssistOnJoystick = false # Out of scope for experiment
export var GRAVITY_TARGET_STATIC_ASSIST_JOYSTICK = 1.0 # Final combination parameter

export var gravityTargetAdaptiveAssistOnJoystick = true;
var GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK = 10 # 10 levels as per source paper
var GRAVITY_TARGET_ADAPTIVE_ASSIST_DELTA_JOYSTICK = float(GRAVITY_TARGET_STATIC_ASSIST_JOYSTICK / float(GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK))


func getActiveTargetList():
	# TODO: Need to make this dynamic
	var listOfAllTargets = $Shooting_gallery_config_00.get_children()
	# Debug: 
	# print("No. of targets found: " + str(listOfAllTargets.size()))
	
	var listOfVisibleTargets = []
	
	for node in listOfAllTargets:
		# Gaurd clause to check if it is a bullseye is visible  
		if node.has_method("hit") and node.is_visible():
			listOfVisibleTargets.append(node)
			
	# Debug: 
	# print("No. of visible targets found: " + str(listOfVisibleTargets.size()))
	
	return listOfVisibleTargets

# Need to call wherever mouse position changed is being tracked (right now it's event based on _input(event): )
func augmentMousePointerGravity():
	
	# Check whether to apply static or adaptive gravitational constant 
	if gravityTargetStaticAssistOnMouse:
		gravityMouse = GRAVITY_TARGET_STATIC_ASSIST_MOUSE
		
	elif gravityTargetAdaptiveAssistOnMouse:
		var scoreDifference = pointer01Score - pointer00Score
		
		var relativePerformance = 0  # Default when scores are at par or mouse pointer is performing better
		
		if scoreDifference > 0:
			relativePerformance = min(GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_MOUSE, scoreDifference)
			
		gravityMouse = NO_GRAVITY_CONSTANT + (GRAVITY_TARGET_ADAPTIVE_ASSIST_DELTA_MOUSE * relativePerformance)
		# Note: Floods the console output (as it is called every redner cycle), moving to increment/decrement functions
		# if gravityMouse != NO_GRAVITY_CONSTANT:
			# print("[INFO] Adaptive Gravity assist, mouse pointer gravitational constant changed to: " + str(gravityMouse))
	
	
	# Calulate "warped pointer" vector as per Eq (1) and Eq (2) of source paper
	# Get current position of the mouse pointer 
	var originalMousePosition = get_node("Pointer00Area2D").position
	
	var listOfVisibleTargets = getActiveTargetList()
	
	var partial_sum_weights = 0
	var partial_sum_weighted_position = Vector2(0.0, 0.0)
	var finalPositionOfAugmentedPointer = originalMousePosition # Default value
	
	if listOfVisibleTargets.size() > 0:
		for target in listOfVisibleTargets:
			# Note: weight of the pointer is set to 1.0 as per Eq (1) of source paper 
			# TODO: get_child(1) is Hacky needs to be refactored
			var weight = (gravityMouse * pow(2, target.get_child(1).shape.radius))  /  (originalMousePosition.distance_squared_to(target.position) + 1 ) # Eq (1) 
			# Debug: 
			# print("  Target position: " + str(target.position.x) + ", " + str(target.position.y) + " :: weight: " + str(weight))
			
			# Denominator of Eq(2) 
			partial_sum_weights += weight
			
			# Numeretor of Eq(2) 
			partial_sum_weighted_position += Vector2(weight * target.position.x, weight * target.position.y) 
		
		# Divided by 0 guard clause 
		if partial_sum_weights != 0:
			# Eq(2)  
			finalPositionOfAugmentedPointer = Vector2(partial_sum_weighted_position.x/partial_sum_weights, partial_sum_weighted_position.y/partial_sum_weights)
	
		# Change the gravityOffsetMouse
		gravityOffsetMouse = finalPositionOfAugmentedPointer - originalMousePosition
	
	# There are no targets to shoot, force offset to be 0.0
	else: 
		gravityOffsetMouse = NO_GRAVITY_OFFSET
	
	# Debug: 
	# print("Offset calculated for mouse: " + str(gravityOffsetMouse.x) + ", " + str(gravityOffsetMouse.y) )
	
	# Scaling down the offset from gravity so the pointer does not get stuck in gravity wells of bullseye 
	gravityOffsetMouse.x *= SCALE_GRAVITY_EFFECT_MOUSE
	gravityOffsetMouse.y *= SCALE_GRAVITY_EFFECT_MOUSE
	
	# Debug: 
	# print("Diminished Offset calculated for mouse: " + str(gravityOffsetMouse.x) + ", " + str(gravityOffsetMouse.y) )
	

# Need to call wherever joystick position changed is being tracked (right now it's polling based on _process(delta): )
func augmentJoystickPointerGravity():
	
	# Check whether to apply static or adaptive gravitational constant 
	if gravityTargetStaticAssistOnJoystick:
		gravityJoystick = GRAVITY_TARGET_STATIC_ASSIST_JOYSTICK
		
	elif gravityTargetAdaptiveAssistOnJoystick:
		var scoreDifference = pointer00Score - pointer01Score
		
		var relativePerformance = 0  # Default when scores are at par or joystick pointer is performing better
		
		if scoreDifference > 0:
			relativePerformance = min(GRAVITY_TARGET_ADAPTIVE_ASSIST_MAX_DELTA_JOYSTICK, scoreDifference)
			
		gravityJoystick = NO_GRAVITY_CONSTANT + (GRAVITY_TARGET_ADAPTIVE_ASSIST_DELTA_JOYSTICK * relativePerformance)
		
		# Note: Floods the console output (as it is called every redner cycle), moving to increment/decrement functions
		# if gravityJoystick != NO_GRAVITY_CONSTANT:
			# print("[INFO] Adaptive Gravity assist, joystick pointer gravitational constant changed to: " + str(gravityJoystick))
	
	
	# Calulate "warped pointer" vector as per Eq (1) and Eq (2) of source paper
	# Get current position of the mouse pointer 
	var originalJoystickPosition = get_node("Pointer01Area2D").position
	
	var listOfVisibleTargets = getActiveTargetList()
	
	var partial_sum_weights = 0
	var partial_sum_weighted_position = Vector2(0.0, 0.0)
	var finalPositionOfAugmentedPointer = originalJoystickPosition # Default value
	
	if listOfVisibleTargets.size() > 0:
		for target in listOfVisibleTargets:
			# Note: weight of the pointer is set to 1.0 as per Eq (1) of source paper 
			# TODO: get_child(1) is Hacky needs to be refactored
			var weight = (gravityJoystick * pow(2, target.get_child(1).shape.radius))  /  (originalJoystickPosition.distance_squared_to(target.position) + 1 ) # Eq (1) 
			# Debug: 
			# print("  Target position: " + str(target.position.x) + ", " + str(target.position.y) + " :: weight: " + str(weight))
			
			# Denominator of Eq(2) 
			partial_sum_weights += weight
			
			# Numeretor of Eq(2) 
			partial_sum_weighted_position += Vector2(weight * target.position.x, weight * target.position.y) 
		
		# Divided by 0 guard clause 
		if partial_sum_weights != 0:
			# Eq(2)  
			finalPositionOfAugmentedPointer = Vector2(partial_sum_weighted_position.x/partial_sum_weights, partial_sum_weighted_position.y/partial_sum_weights)
	
		# Change the gravityOffsetMouse
		gravityOffsetJoystick = finalPositionOfAugmentedPointer - originalJoystickPosition
	
	# There are no targets to shoot, force offset to be 0.0
	else: 
		gravityOffsetJoystick = NO_GRAVITY_OFFSET
	
	# Debug: 
	# print("Total Offset calculated for joystick: " + str(gravityOffsetJoystick.x) + ", " + str(gravityOffsetJoystick.y) )
	
	# Scaling down the offset from gravity so the pointer does not get stuck in gravity wells of bullseye 
	gravityOffsetJoystick.x *= SCALE_GRAVITY_EFFECT_JOYSTICK
	gravityOffsetJoystick.y *= SCALE_GRAVITY_EFFECT_JOYSTICK
	
	# Debug: 
	# print("Diminished Offset calculated for joystick: " + str(gravityOffsetJoystick.x) + ", " + str(gravityOffsetJoystick.y) )

# Called when the node enters the scene tree for the first time.
#  Note: all child nodes' _ready() is called before their parent node's _ready()
func _ready():
	
	if DEBUG_MODE: 
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("[" + str(getElapsedTime()) + "][INFO] Vebose meta-info logging is on")
	# Hide mouse cursor if DEBUG_MODE is false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		print("[" + str(getElapsedTime()) + "][INFO] OS Mouse pointer hidden")
	
	# Override pointer sizes
	pointerScaleFactor = (POINTER_RADIUS / float(INITIAL_POINTER_RADIUS)) * INTIAL_POINTER_SPRITE_SCALE
	
	if DEBUG_MODE:
		print("[" + str(getElapsedTime()) + "][INFO] Scaling pointer sizes to: x" + str(pointerScaleFactor))
	get_node("Pointer00Area2D/Pointer00").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	get_node("Pointer01Area2D/Pointer01").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	
	# Scaling on fire effects
	get_node("pointer_00_on_mouse_down_particle2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	get_node("pointer_01_on_RT_particle2D").scale = Vector2(pointerScaleFactor, pointerScaleFactor)
	
	# Set pointer hit area 
	get_node("Pointer00Area2D/Pointer00HitArea").shape.radius = INITIAL_POINTER_HIT_RADIUS
	get_node("Pointer01Area2D/Pointer01HitArea").shape.radius = INITIAL_POINTER_HIT_RADIUS
	
	# Override target sizes
	# TODO: Change to class based access
	# TODO: Add guard clauses
	var targetScaleFactor = TARGET_RADIUS / float(INITIAL_TARGET_RADIUS)
	if DEBUG_MODE:
		print("[" + str(getElapsedTime()) + "][INFO] Scaling target sizes to: x" + str(targetScaleFactor))
	for targetArea2D in get_node("Shooting_gallery_config_00").get_children():
		# Debug: 
		# print(targetArea2D.get_name())
		targetArea2D.scale = Vector2(targetScaleFactor, targetScaleFactor)
		
	if DEBUG_MODE: 
		print("[" + str(getElapsedTime()) + "][INFO] Screen size: " + str(OS.get_screen_size().x) + "px x " + str(OS.get_screen_size().y) + "px")
		print("[" + str(getElapsedTime()) + "][INFO] Screen DPI: " + str(OS.get_screen_dpi()))
		print("[" + str(getElapsedTime()) + "][INFO] Pointer radius: " + str(POINTER_RADIUS) + "px, Target radius: " + str(TARGET_RADIUS) + "px")
	
	
	
	# Attach the pointer to the mouse 
	# TODO: make attachment dynamic as per selected input device
	# Input.warp_mouse_position(get_node("Pointer00Area2D").position)
	get_node("Pointer00Area2D").position = get_viewport().get_mouse_position()  	 
	
	# Register event to monitor if joystick connected or disconnected
	Input.connect("joy_connection_changed", self, "outputJoystickConnectionStatus")
	
	if DEBUG_MODE:
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
		
		if !(didJustWarpMouseX or didJustWarpMouseY):
			
			# if gravityTargetStaticAssistOnMouse or gravityTargetAdaptiveAssistOnMouse:
			augmentMousePointerGravity()

			# TODO: make attachment dynamic as per selected input device			
			get_node("Pointer00Area2D").translate((event.relative * MOUSE_SENSITIVITY_DEFAULT * stickyDampMouse) + gravityOffsetMouse)
		
		# For infinite relative movement
		elif didJustWarpMouseX:
			didJustWarpMouseX = false # Reset
		elif didJustWarpMouseY:
			didJustWarpMouseY = false # Reset
		
		# Bound to available screen area 
		var viewportMinX = 0 # By definition
		var viewportMinY = 0 # By definition
		# var viewportMaxX = OS.get_screen_size().x
		# var viewportMaxY = OS.get_screen_size().y
		var viewportMaxX = get_viewport().size.x - 1 # Counting starts from 0th pixel
		var viewportMaxY = get_viewport().size.y - 1 # Counting starts from 0th pixel
		
		# Debug: 
		# print("Max X:: " + str(OS.get_screen_size().x) + ":" + str(get_viewport().size.x) + ":" + str(ProjectSettings.get_setting("display/window/size/width")))
		
		if (get_node("Pointer00Area2D").position.x > viewportMaxX): get_node("Pointer00Area2D").position.x = viewportMaxX
		elif (get_node("Pointer00Area2D").position.x < viewportMinX): get_node("Pointer00Area2D").position.x = viewportMinX
		
		if (get_node("Pointer00Area2D").position.y > viewportMaxY): get_node("Pointer00Area2D").position.y = viewportMaxY
		elif (get_node("Pointer00Area2D").position.y < viewportMinY): get_node("Pointer00Area2D").position.y = viewportMinY
		
		# Check if mouse pointer is at the edge
		var EDGE_OFFSET = 5 # Wrap to the other edge with an offset (so we're not stuck with an infinite loop)
		var mouseX = get_viewport().get_mouse_position().x
		var mouseY = get_viewport().get_mouse_position().y
		
		# Debug: 
		# print("Max X: " + str(OS.get_screen_size().x) + ", MouseX: " + str(mouseX))
		
		if mouseX <= viewportMinX:
			Input.warp_mouse_position(Vector2(viewportMaxX - EDGE_OFFSET, mouseY))
			didJustWarpMouseX = true

		elif mouseX >= viewportMaxX:
			Input.warp_mouse_position(Vector2(viewportMinX + EDGE_OFFSET, mouseY))
			didJustWarpMouseX = true

		if mouseY <= viewportMinY:
			Input.warp_mouse_position(Vector2(mouseX, viewportMaxY - EDGE_OFFSET))
			didJustWarpMouseX = true

		elif mouseY >= viewportMaxY:
			Input.warp_mouse_position(Vector2(mouseX, viewportMinY + EDGE_OFFSET))
			didJustWarpMouseX = true
		
		# Wrap mouse to pointer location (to offset for CDR changes)
		# Input.warp_mouse_position(get_node("Pointer00Area2D").position) # Doesn't work (conflicts with above)


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
		
		augmentJoystickPointerGravity()
		
		# for Right Analog
		# ---
		#   Translate x:
		if(abs(delX_RA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			# Algo:                        time_elapsed * constant_pixel_movement * joystick_cdr * value from analog stick
			XboxPointerNodeSprite.position.x += (delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_RA * stickyDampJoystick) + gravityOffsetJoystick.x
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_RA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += (delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_RA * stickyDampJoystick) + gravityOffsetJoystick.y
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.y > viewportMaxY): XboxPointerNodeSprite.position.y = viewportMaxY
			elif (XboxPointerNodeSprite.position.y < viewportMinY): XboxPointerNodeSprite.position.y = viewportMinY
		
		# for Left Analog
		# ---
		#   Translate x
		if(abs(delX_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.x += (delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delX_LA * stickyDampJoystick) + gravityOffsetJoystick.x 
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.x > viewportMaxX): XboxPointerNodeSprite.position.x = viewportMaxX
			elif (XboxPointerNodeSprite.position.x < viewportMinX): XboxPointerNodeSprite.position.x = viewportMinX
		
		#   Translate y
		if(abs(delY_LA) > JOYSTICK_ANALOG_STICK_DEADZONE_DEFAULT):
			XboxPointerNodeSprite.position.y += (delta * JOYSTICK_ANALOG_STICK_DELTA * JOYSTICK_SENSITIVITY_DEFAULT * delY_LA * stickyDampJoystick) + gravityOffsetJoystick.y
			# Constrain to viewport 
			if (XboxPointerNodeSprite.position.y > viewportMaxY): XboxPointerNodeSprite.position.y = viewportMaxY
			elif (XboxPointerNodeSprite.position.y < viewportMinY): XboxPointerNodeSprite.position.y = viewportMinY

func outputJoystickConnectionStatus(deviceId, isConnected):
	if isConnected: 
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Joystick id: " + str(deviceId) + " connected")
		
		# Check if input hw is recognised 
		if Input.is_joy_known(deviceId):
			if DEBUG_MODE:
				print("[" + str(getElapsedTime()) + "][INFO] Joystick recognised: " + Input.get_joy_name(deviceId))
	
	# at disconnection 
	else:
		if DEBUG_MODE:
			print("[" + str(getElapsedTime()) + "][INFO] Joystick id: " + str(deviceId) + " disconnected")

