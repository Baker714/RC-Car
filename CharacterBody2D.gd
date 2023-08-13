extends CharacterBody2D

@export var health = 20

const MAXSPEED = 30
var SPEED = 0;
var drift = null
var fire_rate = .5
var can_fire = true

func _physics_process(delta):
	if health <= 0:
		queue_free()
	
	var newVector = (Vector2($Straight.global_position.x, $Straight.global_position.y) - Vector2(global_position.x, global_position.y)).normalized() * SPEED
	var rotation = 0

	if Input.is_action_pressed("fire_right"):
		fire($DriftRight)
	elif Input.is_action_pressed("fire_left"):
		fire($DriftLeft)
	elif Input.is_action_pressed("fire"):
		fire($Straight)
		
	if Input.is_action_pressed("move_forward"):
		if SPEED < MAXSPEED:
			SPEED += .5
			
		if Input.is_action_pressed("move_left") and drift == null:
			drift = "left"
			fire_rate = .3
			rotation = -0.04			
		elif Input.is_action_pressed("move_right") and drift == null:
			drift = "right"
			fire_rate = .3
			rotation = 0.04
				
		if SPEED > 27 and Input.is_action_pressed("drift") and drift != null:
			fire_rate = .1
			
			if drift == "right":
				SPEED = 27
				rotation = 0.05
				newVector = (Vector2($DriftLeft.global_position.x, $DriftLeft.global_position.y) - Vector2(global_position.x, global_position.y)).normalized() * (SPEED - 2)
				if Input.is_action_pressed("move_left"):
					rotation = 0
			elif drift == "left":
				SPEED = 27
				rotation = -0.05
				newVector = (Vector2($DriftRight.global_position.x, $DriftRight.global_position.y) - Vector2(global_position.x, global_position.y)).normalized() * (SPEED - 2)
				if Input.is_action_pressed("move_right"):
					rotation = 0
		else:
			drift = null
			fire_rate = .3
	else:
		if SPEED > 0:
			SPEED -= .5
#
	velocity = newVector * SPEED
	rotate(rotation)
	move_and_slide()
	
func fire(shootDirection):
	if can_fire:
		can_fire = false
		var bullet = load("res://bullet.tscn").instantiate()
		bullet.global_rotation = atan2((Vector2(shootDirection.global_position.x, shootDirection.global_position.y) - Vector2(global_position.x, global_position.y)).normalized().y, (Vector2(shootDirection.global_position.x, shootDirection.global_position.y) - Vector2(global_position.x, global_position.y)).normalized().x)
		bullet.global_position = $BulletSpawn.global_position
		bullet.direction = (Vector2(shootDirection.global_position.x, shootDirection.global_position.y) - Vector2(global_position.x, global_position.y)).normalized()
		bullet.current_speed = SPEED
		get_parent().add_child(bullet)
		await timer()
		
func timer():
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
	
func hit(damage):
	health -= damage
