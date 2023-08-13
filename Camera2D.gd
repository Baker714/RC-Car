extends Camera2D

var move: Vector2
var can_move = true

func _on_area_2d_body_entered(body):
	$Area2D.monitoring = false
	if body.name == "car" and can_move:
		can_move = false
		var vector = (body.global_position - global_position).normalized().round()
		var point: Vector2
		var x = get_viewport_rect().size.x + (get_viewport_rect().size.x * (1 - zoom.x))
		var y = get_viewport_rect().size.y + (get_viewport_rect().size.y * (1 - zoom.y))

		if vector.x == -1:
			point.x -= x
		elif vector.x == 1:
			point.x += x
		elif vector.y == -1:
			point.y -= y
		elif vector.y == 1:
			point.y += y
			
		translate(point)
		
		await timer()
		
func timer():
	await get_tree().create_timer(.1).timeout
	print("done waiting")
	$Area2D.monitoring = true
	can_move = true
