extends StaticBody2D

var speed = 0.0 
const bounceSpeed=1300
var prevPos=0
var xvel=0

func _process(delta: float) -> void:
	prevPos=position.x
	position.x += speed
	xvel=(position.x-prevPos)/delta
	
func get_speed():
	return xvel

func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Bingo")
		var direction = (position-body.position).normalized()
		body.velocity-=bounceSpeed*direction
