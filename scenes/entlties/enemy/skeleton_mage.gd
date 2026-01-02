extends Enemy

func _physics_process(delta: float) -> void:
    move_to_player(delta)

func range_attack_animation() -> void:
    $Timers/AttackTimer.wait_time = rng.randf_range(1.0, 2.0)
    attack_animation.animation = simple_attacks["fireball"]
    $AnimationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _on_attack_timer_timeout() -> void:
    if position.distance_to(player.position) < attack_radius:
        range_attack_animation()
        
