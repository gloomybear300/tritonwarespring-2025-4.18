extends Control

@export var rope: PackedScene
var ropeOrigin: Vector2
var maxRopeDist = 300

var rope_instance
var skin = GameState.skin_keys[GameState.skin_index]
var required_score = GameState.skin_unlock_scores.get(skin, 0)
var player_score = ScoreManager.get_highest_score()
var unlocked = player_score >= required_score	
func _ready() -> void:
	GameState.skin_index = 0
	ropeOrigin = Vector2(575, 50)
	await get_tree().process_frame  # Wait one frame
	update_skin_display()



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_right_pressed():
	GameState.skin_index = (GameState.skin_index + 1) % GameState.skin_keys.size()
	update_skin_display()


func _on_left_pressed():
	GameState.skin_index = (GameState.skin_index - 1 + GameState.skin_keys.size()) % GameState.skin_keys.size()
	update_skin_display()


func update_skin_display():
	
	if GameState.skin_index >= GameState.skin_keys.size():
		GameState.skin_index = 0  # Safety fallback

	skin = GameState.skin_keys[GameState.skin_index]
	skin = GameState.skin_keys[GameState.skin_index]
	required_score = GameState.skin_unlock_scores.get(skin, 0)
	player_score = ScoreManager.get_highest_score()
	unlocked = player_score >= required_score
	print("Current skin from index: ",	 GameState.skin_keys[GameState.skin_index])
	print("Skin variable: ", skin)
	print(player_score,required_score)
	print(unlocked)
	# Update the skin label
	if (unlocked):
		$Text/Label.text = "%s" % skin
	else:
		$Text/Label.text = "%s (locked)" % skin
	$Text/Needed.text = "Need %d score" % required_score

	# Enable or disable the use button

	# Show preview of the selected skin (even if not applied)
	update_rope_preview(skin)


func update_rope_preview(skin: String):
	# Refresh rope
	if rope_instance:
		rope_instance.queue_free()
		rope_instance = null
	if rope:
		rope_instance = rope.instantiate()
		print("Rope instance created")
		add_child(rope_instance)
		rope_instance.current_skin = skin
		rope_instance.spawnRope(ropeOrigin, ropeOrigin + Vector2(0, maxRopeDist))


func _on_use_pressed() -> void:
	var selected_skin = GameState.skin_keys[GameState.skin_index]
	var required_score = GameState.skin_unlock_scores.get(selected_skin, 0)
	var player_score = ScoreManager.get_highest_score()

	if player_score >= required_score:
		GameState.skin = selected_skin
		print("Skin applied: ", GameState.skin)
	else:
		print("Skin is locked!")
