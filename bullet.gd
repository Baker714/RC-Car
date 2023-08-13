extends Area2D

@export var direction: Vector2
@export var current_speed: float
@export var damage = 1

const SPEED = 1200.0

func _physics_process(delta):
	var velocity
	
	velocity = direction * (SPEED + (current_speed * 10))
	position += velocity * delta

func _on_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
		
	queue_free()
