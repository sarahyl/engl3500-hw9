@tool
extends Node2D

@onready var polygon2D = $Polygon2D
@onready var collision_polygon_2D = $CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_polygon_2D.polygon = polygon2D.polygon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if collision_polygon_2D.polygon != polygon2D.polygon:
		collision_polygon_2D.polygon = polygon2D.polygon
	pass


