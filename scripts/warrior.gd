extends CharacterBody2D
class_name Warrior


@onready var _animation_player = %AnimationPlayer
@onready var _sprite = $Sprite2D
@export var SPEED = 500.0


func _ready() -> void:
	_animation_player.play("idle")


func _physics_process(delta: float) -> void:
	var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity += input_direction * SPEED
	move_and_slide()

	if input_direction.is_zero_approx():
		_animation_player.play("idle")
	else:
		_animation_player.play("run")

	if input_direction.x < 0:
		_sprite.scale.x = -1
	elif input_direction.x > 0:
		_sprite.scale.x = 1
