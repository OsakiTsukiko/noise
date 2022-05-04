extends Node

var point = preload("res://scenes/point.tscn")
onready var cont = $Main/Container

const SPACE = .1
const MULT = 1

var noise = OpenSimplexNoise.new()

func _ready():
	randomize()
	
	# Configure
	noise.seed = floor(rand_range(-2147483648, 2147483648))
	noise.octaves = 4
	noise.period = 150.0
	noise.persistence = 20
	
	for x in range (0, 100):
		for y in range (0, 100):
			var cube = point.instance();
			var noise_lvl = noise.get_noise_2d(x, y) * MULT
			cube.set_translation(Vector3(x * SPACE, noise_lvl, y * SPACE))
			
#			var mat = SpatialMaterial.new()
#			var color = Color(randf(),randf(),randf(),1)
#			mat.albedo_color = color
#			cube.material_override = mat
			
			cont.add_child(cube)
	pass
	
func _process(delta):
	if ( Input.is_action_just_pressed("ui_accept") ):
		var idx:int = 0
		noise.seed = floor(rand_range(-2147483648, 2147483648))
		for x in range (0, 100):
			for y in range (0, 100):
				var cube = cont.get_child(idx)
				idx += 1
				var noise_lvl = noise.get_noise_2d(x, y) * MULT
				cube.set_translation(Vector3(x * SPACE, noise_lvl, y * SPACE))
