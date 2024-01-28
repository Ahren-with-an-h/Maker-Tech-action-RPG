extends CharacterBody2D

@export var speed: float = 20
@export var limit = 0.5
@export var end_point: Marker2D
@export var knockback_power: int = 3000

@onready var animations = $AnimationPlayer

var startPosition
var endPosition

var is_dead = false



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
	if is_dead: return
	update_velocity()
	move_and_slide()
	update_animation()


func _on_hit_box_area_entered(area):
	if area == $HitBox: return
	$HitBox.set_deferred("monitorable", false)
	is_dead = true
	knockback(area.get_parent().get_parent().velocity)
	animations.play("death")
	await animations.animation_finished
	queue_free()


func knockback(player_location):
	var knockback_dir = (player_location - velocity).normalized() * knockback_power
	velocity = knockback_dir
	print_debug(velocity)
	print_debug(position)
	move_and_slide()
	print_debug(position)
	print_debug(" ")
