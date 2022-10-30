extends Area2D

var velocity: Vector2 = Vector2();
var speed: int = 1000;

func shoot_trajectory(direction: Vector2):
	self.rotate(direction.angle());
	velocity = direction * speed;

func _process(delta):
	self.position += velocity * delta;

func _on_LaserBeam_body_entered(body: RigidBody2D):
	body.queue_free();
	self.queue_free();
