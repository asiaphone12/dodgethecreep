extends CanvasLayer

signal start_game
signal mode_hud_toggle;

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_made_by(text):
	$MadeBy.text = text
	$MadeBy.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$MadeBy.show()
	emit_signal("mode_hud_toggle");

func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()
	
func _on_StartButton_pressed():
	$StartButton.hide()
	$MadeBy.hide()
	emit_signal("start_game")
	emit_signal("mode_hud_toggle");
