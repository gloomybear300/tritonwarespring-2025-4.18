extends CanvasItem
"""
	This script doesn't apply any physics to the player it just draws the simulated rope.
"""

var RopePiece = preload("res://scenes/rope_segment.tscn")
var pieceLength = 12
var rope_parts = []
var rope_close_tolerance = 10
var rope_points: PackedVector2Array = []
var rope_colors: PackedColorArray = []
var color1=Color.SADDLE_BROWN
var color2=Color.BLACK

var current_skin = "red_white"  # Can be set dynamically from a menu, etc.
var rope_static = false
@onready var start_piece: StaticBody2D = $"start piece"
@onready var end_piece: StaticBody2D = $"end piece"
@onready var  startJoint = $"start piece/C/J"
@onready var  endJoint = $"end piece/C/J"

@onready var player = $/root/Game/player
func _ready() -> void:
	current_skin = GameState.skin
	
func _process(delta: float) -> void:
	#print("Rope is processing...")
	if(player):
		end_piece.global_position=player.global_position
		var ropeDelta:float=player.maxRopeDist-player.ropeDist
		start_piece.global_position.y=-ropeDelta
		get_rope_points()
		if !rope_points.is_empty():
			queue_redraw()
	else:
		get_rope_points()
		if !rope_points.is_empty():
			queue_redraw()
		

func spawnRope(startPos:Vector2,endPos:Vector2):
	start_piece.global_position=startPos
	end_piece.global_position=endPos
	startPos = start_piece.get_node("C/J").global_position
	endPos = end_piece.get_node("C/J").global_position
	
	var distance = 500
	var segment_amount = round(distance/pieceLength)
	var spawn_angle = (endPos-startPos).angle() - PI/2
	
	create_rope(segment_amount,start_piece,endPos,spawn_angle)
	
		
func create_rope(pieces_amount: int, parent: Object, end_pos: Vector2, spawn_angle: float) -> void:
	rope_colors.clear()

	var skin_colors = GameState.rope_skins.get(current_skin, [Color.SADDLE_BROWN, Color.BLACK])
	var color_count = skin_colors.size()

	for i in pieces_amount + 2:  # +2 to cover start and end
		var color = skin_colors[i % color_count]
		rope_colors.append(color)

		if i < pieces_amount:
			parent = addPiece(parent, i, spawn_angle)
			parent.set_name("rope_piece_" + str(i))
			rope_parts.append(parent)

			var joint_pos = parent.get_node("C/J").global_position
			if joint_pos.distance_to(end_pos) < rope_close_tolerance:
				break

	end_piece.get_node("C/J").node_a = end_piece.get_path()
	end_piece.get_node("C/J").node_b = rope_parts[-1].get_path()

func addPiece(parent:Object, id:int, spawn_angle:float) -> Object:
	var joint: PinJoint2D = parent.get_node("C/J") as PinJoint2D
	var piece: Object = RopePiece.instantiate() as Object
	piece.global_position = joint.global_position
	piece.rotation=spawn_angle
	piece.parent = self
	piece.id = id
	add_child(piece)
	joint.node_a = parent.get_path()
	joint.node_b = piece.get_path()
	
	return piece

func get_rope_points()->void:
	rope_points=[]
	rope_points.append(startJoint.global_position)
	for r in rope_parts:
		rope_points.append(r.global_position)
	rope_points.append(endJoint.global_position)

func _draw() -> void:
	draw_polyline_colors(rope_points,rope_colors,3,false)
