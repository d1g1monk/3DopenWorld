extends Node3D

 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    $StaticBody3D3/CSGSphere3D.rotation.y += 2 * delta 
    $StaticBody3D2/Sphere.rotation.x += 2 * delta 
     
