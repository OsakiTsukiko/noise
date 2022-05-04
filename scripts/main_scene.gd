extends Node

var point = preload("res://scenes/point.tscn")
onready var cont = $Main/Container
onready var label = $Main/CanvasLayer/Label

const SPACE = .1
const MULT = 1
var idx_x = 0
var idx_y = 0

var noise = OpenSimplexNoise.new()

var mat_water = SpatialMaterial.new()
var mat_sand = SpatialMaterial.new()
var mat_grass = SpatialMaterial.new()
var mat_stone = SpatialMaterial.new()
var mat_snow = SpatialMaterial.new()

func _ready():
	
	randomize()
	
	# Configure
	noise.seed = floor(rand_range(-2147483648, 2147483648))
	noise.octaves = 4
	noise.period = 150.0
	noise.persistence = 20
	
	var dodgerblue = Color.dodgerblue
	var khaki = Color.khaki
	var mediumseagreen = Color.mediumseagreen
	var slategray = Color.slategray
	var snow = Color.snow
	mat_water.albedo_color = dodgerblue
	mat_sand.albedo_color = khaki
	mat_grass.albedo_color = mediumseagreen
	mat_stone.albedo_color = slategray
	mat_snow.albedo_color = snow
	
	for x in range (0, 100):
		for y in range (0, 100):
			var cube = point.instance();
			var noise_lvl = noise.get_noise_2d(x, y) * MULT
			cube.set_translation(Vector3(x * SPACE, noise_lvl, y * SPACE))		
			cont.add_child(cube)
	pass
	
func _process(delta):
	label.text = String(delta)
	
	if ( Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down") ):
		var idx:int = 0
#		noise.seed = floor(rand_range(-2147483648, 2147483648))
		for x in range (idx_x, idx_x + 100):
			for y in range (idx_y, idx_y + 100):
				var cube = cont.get_child(idx)
				idx += 1
				var noise_lvl = noise.get_noise_2d(x, y) * MULT
				if ( noise_lvl >= .6 ): cube.material_override = mat_snow
				if ( noise_lvl >= .2 && noise_lvl < .6 ): cube.material_override = mat_stone
				if ( noise_lvl >= -.5 && noise_lvl < .2 ): cube.material_override = mat_grass
				if ( noise_lvl > -.6 && noise_lvl < -.5 ): cube.material_override = mat_sand
				if ( noise_lvl <= -.6 ): 
					noise_lvl = -.6
					cube.material_override = mat_water
					
				cube.set_translation(Vector3((x - idx_x) * SPACE, noise_lvl, (y - idx_y) * SPACE))
		
		if (Input.is_action_pressed("ui_right")): idx_x += 1;
		if (Input.is_action_pressed("ui_left")): idx_x -= 1;
		if (Input.is_action_pressed("ui_up")): idx_y -= 1;
		if (Input.is_action_pressed("ui_down")): idx_y += 1;
