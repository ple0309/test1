extends CharacterBody2D
@onready var health_bar: ProgressBar = $HealthBar
var direction : Vector2 = Vector2.ZERO
var swing : bool = false
var speed = 300
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_mode = animation_tree.get("parameters/playback")
var destination : Vector2
var movement : Vector2
var moving = false
var hp = 10
func _ready() -> void:
	health_bar.value = hp
	
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("click"):
		moving = true
		destination = get_global_mouse_position()
		print("this is destination: ", destination)
		movement = position.direction_to(destination)
		print("this is movement: ", movement)

func _physics_process(_delta: float) -> void:
	direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	if direction:
		moving = false
		direction.normalized()
		velocity = direction * speed
		set_walking(true)
		update_blend_position()
		move_and_slide()
	else:
		set_walking(false)
		if moving == true and position.distance_to(destination) > 10:
			direction = movement * speed
			print(direction)
			velocity = direction
			set_walking(true)
			update_blend_position()
			move_and_slide()
		else:
			set_walking(false)
			moving = false

func _process(_delta: float) -> void:
	health_bar.value = hp
func set_walking(value):
	animation_tree["parameters/conditions/Walk"] = value
	animation_tree["parameters/conditions/Idle"] = not value

func update_blend_position():
	animation_tree["parameters/Idle/blend_position"] = direction.normalized()
	animation_tree["parameters/Walk/blend_position"] = direction.normalized() 
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "enermy":
		hp -= 1
		moving = false
		direction = Vector2.ZERO
		set_walking(false)
		update_blend_position()
		velocity = direction
		move_and_slide()
