extends Control

signal textbox_closed

export(Resource) var enemy = null

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false

func _ready() -> void:
	set_health($ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$TextBox.hide()
	$ActionPanel.hide()
	
	display_text("A magic enemy appears!!")
	yield(self, "textbox_closed")
	$ActionPanel.show()
	
func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP:%d/%d" % [health, max_health]
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(BUTTON_LEFT) and $TextBox.visible:
		$TextBox.hide()
		emit_signal("textbox_closed")
			
func display_text(text):
	$ActionPanel.hide()
	$TextBox.show()
	$TextBox/Label.text = text

func enemy_turn():
	display_text("Enemy attack you!!")
	yield(self, "textbox_closed")
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play_backwards("shake")
		yield($AnimationPlayer, "animation_finished")
		
		display_text("You defend successfully!")
		yield(self, "textbox_closed")
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
	
		$AnimationPlayer.play("shake")
		yield($AnimationPlayer, "animation_finished")
	
		display_text("Enemy dealt %d damage!" % enemy.damage)
		yield(self, "textbox_closed")
	$ActionPanel.show()

func _on_Run_pressed() -> void:
	display_text("You run away!")
	yield(self, "textbox_closed")
	yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()


func _on_Attack_pressed() -> void:
	display_text("You punch the enemy!")
	yield(self, "textbox_closed")
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($ProgressBar, current_enemy_health, enemy.health)
	
	$AnimationPlayer.play("enemydamage")
	yield($AnimationPlayer, "animation_finished")
	
	display_text("You dealt %d damage!" % State.damage)
	yield(self, "textbox_closed")
	
	if current_enemy_health == 0:
		display_text("Enemy was defeated")
		yield(self, "textbox_closed")
		
		$AnimationPlayer.play("enemyDied")
		yield($AnimationPlayer, "animation_finished")
		
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().quit()
	
	enemy_turn()

func _on_Defend_pressed() -> void:
	is_defending = true
	
	display_text("You defend the attack!")
	yield(self, "textbox_closed")
	
	yield(get_tree().create_timer(0.25), "timeout")
