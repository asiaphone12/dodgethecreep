extends KinematicBody2D

var velocity: Vector2 = Vector2();
var speed: int = 1000;
var resistance_percentage: float = 2.5;
var max_speed: int = 400;

func get_input():
	var direction: Vector2 = Vector2.ZERO;
	if(Input.is_action_pressed("down")):
		direction.y = 1;
	if(Input.is_action_pressed("up")):
		direction.y = -1;
	if(Input.is_action_pressed("right")):
		direction.x = 1;
	if(Input.is_action_pressed("left")):
		direction.x = -1;
	direction.normalized();
	return direction;

func player_animation(velocity: Vector2):
	if(velocity.length() >  50):
		$AnimatedSprite.animation = "move";
	else:
		$AnimatedSprite.animation = "idle";

func calculate_resistance(temp_velocity: Vector2) -> Vector2:
	return temp_velocity.normalized() * (temp_velocity.length() * resistance_percentage);

func _process(delta: float) -> void:
#	self.look_at(get_viewport().get_mouse_position());
	var desired_speed: Vector2 = get_input() * speed;
	velocity += desired_speed * delta;
	velocity = self.move_and_slide(velocity, Vector2.UP, false);
	if(desired_speed.length() == 0):
		velocity -= calculate_resistance(velocity) * delta;
	velocity = velocity.limit_length(max_speed);
	player_animation(velocity);
