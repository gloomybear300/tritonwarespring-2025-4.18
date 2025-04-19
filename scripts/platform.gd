extends StaticBody2D

var speed = 0.0
var xvel = 0
var prevPos=0

@onready var sprite: AnimatedSprite2D = $sprite

func _ready() -> void:
	if sprite:
		sprite.animation = "default"
		var total_frames = sprite.sprite_frames.get_frame_count("default")
		var random_frame = randi() % total_frames
		sprite.frame = random_frame
	else:
		print("sprite not loaded")
	
func _process(delta: float) -> void:
	prevPos=position.x
	position.x += speed
	xvel=(position.x-prevPos)/delta
	
func get_speed():
	return xvel
