extends CharacterStateMachine
class_name ChargeEnemy

@export var hp: int = 3

func hit(damage_number: int):
	hp -= damage_number
	if (hp <= 0):
		queue_free()
#		get_tree().get_root().get_node("/Main/Hud").add_score[1]
