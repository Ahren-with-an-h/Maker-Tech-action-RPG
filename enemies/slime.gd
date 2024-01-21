extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var end_point: Marker2D

@onready var animations = $AnimationPlayer

var startPosition
var endPosition


func _ready():
	startPosition = position
	endPosition = end_point.global_position
	

func change_direction():
	var tempEnd = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func update_velocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limit:
		change_direction()
		
	velocity = moveDirection.normalized() * speed
	

func update_animation():
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction = "down"
		
		if   velocity.x < -(speed / 2): direction = "left"
		elif velocity.x > speed / 2: direction = "right"
		elif velocity.y < 0: direction = "up"
		
		animations.play("walk_" + direction)

func _physics_process(delta):
	update_velocity()
	move_and_slide()
	update_animation()
