extends Area2D

signal hit
signal dragsignal
signal shoot(direction);

export var speed = 400

var screen_size
var dragging = false
var player_mode: int = 0;

func change_player_mode(state: int) -> void:
	player_mode = state;

func _ready():
	screen_size = get_viewport_rect().size
	hide()
	connect("dragsignal", self, "_set_drag_pc")

func _process(delta):
	var velocity = Vector2.ZERO
	var mousepos = get_viewport().get_mouse_position();
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("click") or dragging:
		var mouse_self_range: float = mousepos.length() - self.position.length();
		velocity = (mousepos - self.position).normalized();
		if(mouse_self_range < 5.0 && mouse_self_range > -5.0):
			velocity = Vector2.ZERO;
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = 'walk'
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = 'up'
		$AnimatedSprite.flip_v = velocity.y > 0
	
	if(player_mode == UsedEnum.STATE_SHOOT && Input.is_action_just_pressed("shoot")):
		emit_signal("shoot", (mousepos - self.position).normalized());


func _set_drag_pc():
	dragging = !dragging

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	show()
	$CollisionShape2D.disabled = false

func _on_KinematicBody2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()


func _on_Player_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("dragsignal")
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("dragsignal")
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
