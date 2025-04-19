extends Control

@export var skins_scene : PackedScene

func _ready() -> void:
	# Iterate through the leaderboard and display it
	for entry in ScoreManager.leaderboard:
		var label = Label.new()
		label.text = "%s - %d" % [entry["name"], entry["score"]]
		$MarginContainer/VBoxContainer/LeaderboardContainer.add_child(label)

# Back button press
func _on_back_pressed() -> void:
	# Go back to the main menu scene
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _refresh_leaderboard_display():
	# Clear existing labels
	for child in $MarginContainer/VBoxContainer/LeaderboardContainer.get_children():
		child.queue_free()  # Remove each child node safely
	# Display a message or show empty leaderboard
	var empty_label = Label.new()
	empty_label.text = "Leaderboard is empty"
	$MarginContainer/VBoxContainer/LeaderboardContainer.add_child(empty_label)

func _on_clear_pressed() -> void:
	ScoreManager.clear_leaderboard()  # Clears the leaderboard
	# Optionally, refresh the UI to show the cleared leaderboard
	_refresh_leaderboard_display()
	pass # Replace with function body.
