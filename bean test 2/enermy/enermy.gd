extends CharacterBody2D




func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		print(1)


func _on_detection_body_exited(body: Node2D) -> void:
		print(2)
