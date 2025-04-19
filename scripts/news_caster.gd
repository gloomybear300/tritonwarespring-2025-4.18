extends Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

var talking=false
var talkWait=1
var talkTimer=0

var blinkWait=0.5
var blinkTime=0
var blinkDur=0.1
func _ready() -> void:
	sprite.z_index=10
	sprite_2d.z_index=10
	sprite_2d_2.z_index=10
func _process(delta: float) -> void:
	if talking:
		pass
	else:
		blinkTime-=delta
		if blinkTime<-blinkDur:
			blinkTime=blinkWait*randf_range(1,4)
			sprite.frame=1 #Eyes Open
		elif blinkTime<0:
			sprite.frame=0 #Blinking
