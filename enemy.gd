extends StaticBody2D

@export var health = 10
var look = false
var can_fire = true
var fire_rate = .6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0:
		queue_free()

	if look:
		$barrel.global_rotation = get_parent().get_node("car").global_position.direction_to(global_position).angle()
		fire()

func fire():
	if can_fire:		
		can_fire = false
		var bullet = load("res://bullet.tscn").instantiate()
		bullet.global_rotation = atan2((Vector2($barrel/Marker2D.global_position.x, $barrel/Marker2D.global_position.y) - Vector2(global_position.x, global_position.y)).normalized().y, (Vector2($barrel/Marker2D.global_position.x, $barrel/Marker2D.global_position.y) - Vector2(global_position.x, global_position.y)).normalized().x)
		bullet.global_position = $barrel/Marker2D.global_position
		bullet.direction = (Vector2($barrel/Marker2D.global_position.x, $barrel/Marker2D.global_position.y) - Vector2(global_position.x, global_position.y)).normalized()
		bullet.set_collision_mask(1)
		get_parent().add_child(bullet)
		await timer()
		
func timer():
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true

func _on_player_detection_body_entered(body):
	if body.name == "car":
		look = true
	
func _on_player_detection_body_exited(body):
	if body.name == "car":
		look = false

func hit(damage):
	health -= damage
