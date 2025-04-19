extends StaticBody2D

var ySpeed = 0
signal game_start
func _process(delta: float) -> void:
	position.y+=ySpeed
	if position.y>1000:
		queue_free()

func _on_player_detector_body_exited(body: Node2D) -> void:
	if body==$/root/Game/player:
		ySpeed=20
	game_start.emit()
