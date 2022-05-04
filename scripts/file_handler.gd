extends Node

func save (content):
	var file = File.new()
	file.open("user://save_game.dat", File.WRITE)
#	~/.local/share/godot/app_userdata/
	file.store_string(content)
	file.close()

func load_data ():
	var file = File.new()
	file.open("res://save_game.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	return content

func _ready():
	var noise = OpenSimplexNoise.new()
	
	# Configure
	noise.seed = floor(rand_range(-2147483648, 2147483648))
	
	noise.octaves = 4
	noise.period = 100.0
	noise.persistence = 20

	var coord_array = []
	for x in range(10):
		for y in range(10):
			for z in range(10):
				var noise_lvl = (noise.get_noise_2d(x, y) + 1)*10/2;
				print(floor(noise_lvl))
				var check = false;
				if ( noise_lvl <= z ): check = true;
				coord_array.push_back({ "x": x, "y": y, "z": z, "check": check })
#				imma see if i can use Vector3
	
	save(JSON.print(coord_array))		
#	print(coord_array)
	pass
