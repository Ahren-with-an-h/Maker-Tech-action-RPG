extends Node2D

@onready var HeartsContainer = $CanvasLayer/HeartsContainer
@onready var player = $TileMap/Player

# Called when the node enters the scene tree for the first time.
func _ready():
	HeartsContainer.set_max_hearts(player.max_health)
	HeartsContainer.update_hearts(player.health)
	player.health_changed.connect(HeartsContainer.update_hearts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
