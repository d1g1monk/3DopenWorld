extends Node3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")

var is_attacking: bool = false

func set_move_state(state_name: String) -> void:
    move_state_machine.travel(state_name)

func attack() -> void:
    if is_attacking: return
    # Access oneshot parameters via code
    $AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func attack_toggle(value: bool):
    is_attacking = value
    
func defend(forward: bool) -> void:
    var tween = create_tween()
    tween.tween_method(_defend_change, 1.0 - float(forward), float(forward), 0.25)
    
func _defend_change(value: float) -> void:
    $AnimationTree.set("parameters/ShieldBlend/blend_amount", value)    
