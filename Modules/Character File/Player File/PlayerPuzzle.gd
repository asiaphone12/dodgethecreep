extends KinematicBody2D

var step: int = 64;

func get_input() -> Vector2:
	if(Input.is_action_just_pressed("up")):
		return Vector2.UP;
	if(Input.is_action_just_pressed("down")):
		return Vector2.DOWN;
	if(Input.is_action_just_pressed("left")):
		return Vector2.LEFT;
	if(Input.is_action_just_pressed("right")):
		return Vector2.RIGHT;
	return Vector2.ZERO;

func _process(delta: float) -> void:
	var desired_step: Vector2 = get_input() * step;
	var temp: KinematicCollision2D = self.move_and_collide(desired_step);
	if(temp != null):
		temp.collider.move_direction(desired_step);
		self.position += desired_step;
		print(temp.collider.position);
