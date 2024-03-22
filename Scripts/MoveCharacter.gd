#make CharacterBody2D node accessible 
extends CharacterBody2D
#define gravity variable as a vector2
var gravity : Vector2
#export variables jump height, movement speed, horizontal air coefficient, speed limit, and friction so they can be easily changeable in inspector
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	#set gravity to vector2 with x = 0 and y = 100
	gravity = Vector2(0, 100)
	pass # Replace with function body.

# function that gets an input from the player and makes the appropriate changes to variables
func _get_input():
	#if the godotbot is touching the floor then take these actions
	if is_on_floor():
		#if the player input is telling the godotbot to move left 
		if Input.is_action_pressed("move_left"):
			#then change the godotbot's velocity by adding negative movement_speed to the x-value of the godotbot's velocity
			#movement_speed is negative because left is negative
			#change the x-value because that controls left and right movement
			velocity += Vector2(-movement_speed,0)
		#if the player input is telling the godotbot to move right
		if Input.is_action_pressed("move_right"):			
			#then change the godotbot's velocity by adding positive movement_speed to the x-value of the godotbot's velocity
			#movement_speed is positive because right is positive
			#change the x-value because that controls left and right movement
			velocity += Vector2(movement_speed,0)
		#if the player input is telling the godotbot to jump 
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			#then change the godotbot's velocity by adding negative jump_height to the y-value of the godotbot's velocity
			#movement_speed is negative because up is negative
			#change the y-value because that controls up and down movement
			velocity += Vector2(0,-jump_height)

	#if the godotbot is up in the air then take these actions
	if not is_on_floor():
		#if input tells godotbot to move left
		if Input.is_action_pressed("move_left"):
			#change the godotbot's velocity by adding negative movement_speed times the horizontal_air_coefficient to the x-value of velocity
			#need to multiply movement speed by the air coefficient to account for air resistance when godotbot is in the air
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		#if input tells godotbot to move right
		if Input.is_action_pressed("move_right"):
			#change the godotbot's velocity by adding positive movement_speed times the horizontal_air_coefficient to the x-value of velocity
			#need to multiply movement speed by the air coefficient to account for air resistance when godotbot is in the air
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

#function to put a cap on the speed of the godotbot
func _limit_speed():
	#check if the current horizontal speed of the godotbot has exceeded the speed limit in right direction
	if velocity.x > speed_limit:
		#if speed limit has been exceeded then lower the horizontal speed of the godotbot's x-axis velocity by changing it to the max allowed speed while keeping y-axis velocity the same
		velocity = Vector2(speed_limit, velocity.y)

	#check if the current horizontal speed of the godotbot has exceeded the speed limit in left direction
	if velocity.x < -speed_limit:
		#if speed limit has been exceeded then lower the horizontal speed of the godotbot's x-axis velocity by changing it to the max allowed speed while keeping y-axis velocity the same
		velocity = Vector2(-speed_limit, velocity.y)

#function to add friction between the godotbot and the ground it moves on
func _apply_friction():
	#check if the godotbot is touching the ground and that the godotbot is not currently trying to move left or right
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		#decrease the horizontal velocity of the godotbot by subtracting the current horizontal velocity times the friction coefficient from the 
		velocity -= Vector2(velocity.x * friction, 0)
		#check if the velocity in the x direction is close enough to zero
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

#function to add gravity to the godotbot
func _apply_gravity():
	#check if the godotbot is touching the ground or not
	if not is_on_floor():
		#if in the air then apply gravity to its velocity
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#call function to check if there are any inputs to the godotbot that would change its actions
	_get_input()
	#call function to make sure godotbot isn't over the max speed
	_limit_speed()
	#call function to apply friction to godotbot
	_apply_friction()
	#call function to apply gravity to godotbot
	_apply_gravity()

	#call function that will allow the godotbot to actually move around
	move_and_slide()
	pass
