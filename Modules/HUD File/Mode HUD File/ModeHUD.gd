extends CanvasLayer

signal playable_state(mode)

func toggle_visibility():
	self.visible = !self.visible;

func _on_DodgeState_pressed() -> void:
	emit_signal("playable_state", UsedEnum.STATE_DODGE);
	$VBoxContainer/DodgeState.disabled = true;
	$VBoxContainer/ShootState.disabled = false;

func _on_ShootState_pressed() -> void:
	emit_signal("playable_state", UsedEnum.STATE_SHOOT);
	$VBoxContainer/DodgeState.disabled = false;
	$VBoxContainer/ShootState.disabled = true;
