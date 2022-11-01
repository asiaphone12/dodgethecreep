extends KinematicBody2D

export (float, 0.0, 30.0) var gravity: float = 9.807;
export (float, 0.0, 1.0) var percentage: float = 0.045
export (float, 0.0, 30.0) var move_speed: float = 12.0;
export (float, 0.0, 5.0) var jump_strength: float = 3.0;

var velocity: Vector2 = Vector2()
var direction: Vector2 = Vector2();

onready var gravity_pixel: float = gravity * percentage * 3779.5275590551;
onready var move_speed_pixel: float = gravity_pixel * move_speed;

func _process(delta):
	get_input();
	velocity.y += (gravity_pixel * delta) + (direction.y * move_speed_pixel * jump_strength * delta);
	velocity.x = direction.x * move_speed_pixel * delta;
	var snap: Vector2 = Vector2.DOWN * 200;
	if(direction.y == -1):
		snap = Vector2.ZERO;
	velocity = self.move_and_slide_with_snap(velocity, snap, Vector2.UP, true);
	play_animation();

func get_input():
	direction = Vector2();
	if(Input.is_action_pressed("left")):
		direction.x = -1;
	if(Input.is_action_pressed("right")):
		direction.x = 1;
	if(Input.is_action_just_pressed("jump") && self.is_on_floor()):
		direction.y = -1;

func play_animation():
	if(direction == Vector2.ZERO):
		$PlatformerSprite.play("idle");
	if(direction.x != 0):
		$PlatformerSprite.play("walk")
	if(direction.x > 0):
		$PlatformerSprite.flip_h = false;

#	else:
#		$PlatformerSprite.flip_h = true;
	elif(direction.x < 0):
		$PlatformerSprite.flip_h = true;

		
	if(not self.is_on_floor()):
		$PlatformerSprite.play("jump");
