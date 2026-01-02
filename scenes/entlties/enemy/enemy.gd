class_name Enemy
extends CharacterBody3D

@onready var move_state_machine = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var skin = get_node("Skin")
@onready var attack_animation = $AnimationTree.get_tree_root().get_node("AttackAnimation")

@export var walk_speed:float = 2.0
@export var notice_radius: float = 15.0
@export var attack_radius: float = 3.0

@export var speed = walk_speed
var speed_modifier: float = 1.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

const simple_attacks: Dictionary = {
    "slice": "2H_Melee_Attack_Slice",
    "spin": "2H_Melee_Attack_Spin",
    "range": "1H_Melee_Attack_Stab",
    "jump_chop": "1H_Melee_Attack_Jump_Chop",
    "fireball": "1H_Ranged_Shoot"
}

func move_to_player(delta):
    if position.distance_to(player.position) < notice_radius:
        var target_dir = (player.position - position).normalized()
        var target_vec2 = Vector2(target_dir.x, target_dir.z)
        var target_angle = target_vec2.angle()
        rotation.y = rotate_toward(rotation.y, -(target_angle), delta)
        if position.distance_to(player.position) > attack_radius: 
            velocity = Vector3(target_vec2.x, 0, target_vec2.y) * speed * speed_modifier
            move_state_machine.travel("Walk")
        else:
            velocity = Vector3.ZERO
            move_state_machine.travel("Idle")
        move_and_slide()


func stop_movement(start_duration: float, end_duration: float):
    var tween = create_tween()
    tween.tween_property(self, "speed_modifier", 0.0, start_duration)
    tween.tween_property(self, "speed_modifier", 1.0, end_duration)
