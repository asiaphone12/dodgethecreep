extends Node

export (PackedScene) var mob_scene
export (PackedScene) var laser_beam_scene: PackedScene;
var score


func _ready():
	$ModeHUD.connect("playable_state", $Player, "change_player_mode");
	$HUD.connect("mode_hud_toggle", $ModeHUD, "toggle_visibility");
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	var mob: RigidBody2D = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI / 4, PI / 4)
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	mob.rotation = direction;
	add_child(mob)


func _on_Player_shoot(direction: Vector2) -> void:
	if($Player.visible == false):
		return;
	var laser_beam: Area2D = laser_beam_scene.instance();
	laser_beam.position = $Player.position + direction * 64;
	self.add_child(laser_beam);
	laser_beam.shoot_trajectory(direction);
	
