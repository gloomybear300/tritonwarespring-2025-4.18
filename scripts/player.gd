extends CharacterBody2D

@onready var ray_cast_box: Area2D = $RayCastBox

var currentPlatform: Node2D = null

var breathMax:float=100
var breathLoss:float=-0.4
var breath:float=breathMax

# Horizontal Movement
var inDir=0
var grdAcceleration = 50    # Increased acceleration on ground
var grdDeceleration = 30     # Increased deceleration on ground
var airAcceleration = 20     # Increased acceleration in air
var airDeceleration = 15     # Increased deceleration in air
var speed = 400              # Increased speed (faster horizontal movement)
var platformSpeed=0

# Jumping
const gravity = 70           # Increased gravity (falling speed increased)
const maxFallSpeed = 800    # Increased max fall speed
const jumpMaxHeight = -800  # Maximum jump height
const jumpMinHeight = -200   # Minimum jump height
const timeForFullJump = 0.4
var timeHeld = 0
var jumps = 2
var isJumping = false        # To track if the jump has been initiated
var isFalling = false

#Coyote Timer
const timeForCoyote = 0.1
var coyoteTimer = 1

# Buffer to queue jump input
var jumpBuffered = false     # Flag to indicate if the jump has been buffered
var jumpBufferTime = 0.1     # 0.1 second buffer time
var jumpBufferTimer = 0      # Timer to track buffered input

const downAcc = 75           # Increased downward acceleration when pressing down

#Wall Jump
const wallJumpPower=-500
const wallJumpPushBack=700
const gravityWall=1

#Rope
@onready var ropeOrigin = Vector2($/root/Game.get_viewport_rect().size.x/2,0)
#Rope Distance
var maxRopeDist=500
var ropeDist:float=maxRopeDist
var minRopeDist=50
var ropeDistError:float=10

#Rope Mechanics
var swingTanMult=27
var ropePullDelta=6
var ropeJumpAngle = PI/6
var canRopeJump=false
var ropeJumps = 0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var pSprite = "default"

var pSpriteRun={
	"default":"1_r"
}
var pSpriteJump={
	"default":"1_j"
}

func _ready() -> void:
	var skin_id = str(randi() % 7 + 1)
	pSpriteRun["default"] = skin_id + "_r"
	pSpriteJump["default"] = skin_id + "_j"

	sprite.animation=pSpriteRun[pSprite]
	sprite.play()
	
func _physics_process(delta: float) -> void:
	if is_on_floor():
		# Only reset jump buffer if we don't have a buffered jump
		if jumpBuffered and jumpBufferTimer >= jumpBufferTime:
			jumpBuffered = false
		sprite.animation=pSpriteRun[pSprite]
		if inDir==0:
			sprite.speed_scale = 0
			sprite.frame=0
		else:
			sprite.speed_scale = 1
	else:
		sprite.animation=pSpriteJump[pSprite]
		
	if velocity.x<0:
		sprite.flip_h = true
	elif velocity.x>0:
		sprite.flip_h = false
		
	if isFalling:
		movement(airAcceleration, airDeceleration, delta)
	else:
		movement(grdAcceleration, grdDeceleration, delta)

	jump(delta)
	handleRope(delta)
	move_and_slide()
	
	

func movement(acceleration: float, deceleration: float, delta: float) -> void:
	if currentPlatform!=null:
		platformSpeed=currentPlatform.get_speed()
	else:
		platformSpeed=0
	inDir = Input.get_axis("left", "right")
	if inDir == 0:
		# Apply friction
		velocity.x = move_toward(velocity.x, platformSpeed, deceleration)
	else:
		# Accelerate player
		velocity.x = move_toward(velocity.x, inDir * speed + platformSpeed, acceleration)
	
		
func jump(delta):
	applyGravity(delta)
	if is_on_floor():
		jumps=1
		isFalling = false
		isJumping = false
		coyoteTimer=0
	else:
		coyoteTimer+=delta	#Allows player to jump slightly after falling off platform
		if coyoteTimer>=timeForCoyote and jumps>0:
			jumps-=1
		isFalling=true
	# Check if jump is buffered
	if jumpBuffered:
		jumpBufferTimer += delta
		if jumpBufferTimer >= jumpBufferTime:
			jumpBuffered = false  # Reset buffer after the time is over
	
	if Input.is_action_just_pressed("jump") and (jumps > 0 or ((canRopeJump) and ropeJumps>0)) and not isJumping:
		velocity.y = jumpMaxHeight
		isJumping = true
		jumps = max(0, jumps - 1)  # Only consume jump if available
		timeHeld = 0
		ropeJumps -=1
	
	# Buffer jump if not on the ground
	if Input.is_action_just_pressed("jump") and jumps == 0 and !isJumping:
		jumpBuffered = true
		jumpBufferTimer = 0  # Reset the buffer timer
		
	if Input.is_action_just_pressed("jump") and is_on_wall():
		if get_wall_normal().x > 0:		#Wall on Left
			velocity.y+=wallJumpPower
			velocity.x+=wallJumpPushBack
		elif get_wall_normal().x < 0:	#Wall on Right
			velocity.y+=wallJumpPower
			velocity.x-=wallJumpPushBack
	
	# Execute buffered jump when landing (if the buffer is active)
	if is_on_floor() and jumpBuffered:
		jumpBuffered = false  # Clear the buffered jump once it's used
		velocity.y = jumpMaxHeight
		isJumping = true
		jumps = 0
		timeHeld = 0  # Reset timeHeld when the jump starts

	
	if isJumping:
		# While jumping, control jump height
		if Input.is_action_pressed("jump"):
			timeHeld += delta
			velocity.y -= lerp(100, 0, timeHeld / timeForFullJump)
		elif Input.is_action_just_released("jump"):
			# After releasing the jump button, let gravity take over
			isJumping = false
	
	# Clamp Fall Speed
	if velocity.y > maxFallSpeed:
		velocity.y = maxFallSpeed

	# Allow downward acceleration if "down" is pressed
	if Input.is_action_pressed("down") and is_on_floor() == false:
		velocity.y += downAcc

func applyGravity(delta):
	if is_on_wall():
		velocity.y+=gravityWall
	else:
		velocity.y += gravity
	
func handleRope(delta):
	var to_origin = ropeOrigin - position
	var dist = to_origin.length()
	var dir_to_origin = to_origin.normalized()
	var angle:float = wrapf(to_origin.angle(),-PI,PI)
	if dist+ropeDistError > ropeDist:
		var dir = (position - ropeOrigin).normalized()
		var correction = dir * (dist - ropeDist)
		position -= correction  # Pull player back just enough to stay within the rope

		var vel_dot = velocity.dot(dir)
		if vel_dot > 0:
			velocity -= dir * vel_dot * 0.8  # soften, not cancel
		
		var tangent = Vector2(-dir_to_origin.y, dir_to_origin.x)  # perpendicular to rope
		velocity += tangent * inDir * swingTanMult
		
		#Rope Jump
		if (angle <= (-PI/2)-ropeJumpAngle) or (angle >= (-PI/2)+ropeJumpAngle):
			canRopeJump=true
		else:
			canRopeJump=false
			ropeJumps=1
		#Handle Breath
		breath+=breathLoss
		if breath<=0:
			$/root/Game.game_over()
	else:
		breath = move_toward(breath,breathMax,-breathLoss)
		pass
		
	var pullDir=Input.get_axis("pullUp","pullDown")
	if pullDir!=0:
		ropeDist=clamp(ropeDist+(pullDir*ropePullDelta),minRopeDist,maxRopeDist)
		
func calculateBreathRatio()->float: #Sends data to game manager
	var breath_ratio = clamp(breath / breathMax, 0.0, 1.0)
	var darkness_alpha = 1.0 - breath_ratio  # darker as breath gets lower
	return darkness_alpha

# Detecting Platform to Add Its Velocity
func _on_ray_cast_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("ground"):
		currentPlatform=body

func _on_ray_cast_box_body_exited(body: Node2D) -> void:
	if currentPlatform == body:
		currentPlatform=null
