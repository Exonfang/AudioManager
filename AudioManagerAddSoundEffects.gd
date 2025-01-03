@tool
extends EditorScript
## Once customized, automatically adds all SoundEffect resources in the [member audio_manager_path]'s sound_effects Array, so they can be called via the AudioManager.

var audio_manager_path: String = "res://path/to/audio_manager/scene.tscn" ## The path to the audio manager scene.
var audio_manage_scene = load(audio_manager_path) ## Loads the audio manage scene so the tool can modify it.
var folder_path = "res://path/to/sound_effects/resources" ## The path to your folder containing your SoundEffect resources.
var files = DirAccess.get_files_at(folder_path) ## Get a list of all files in the [member folder_path].
var modified: bool ## Stores if the audio manager scene is updated, we only need to resave if updated.


func _run() -> void:
	# unpack the audio manager scene
	var audio_manage_scene_instance: Node2D = audio_manage_scene.instantiate()

	# Loop through each file in the folder, load the resource, check if it's in the array or not, and if not, add it.
	for file in files:
		var file_path = folder_path + "/" + file ## the full path to the resource
		var resource = load(file_path) ## set to the resource to load
		# Check if the resource is valid and not already in the array
		if resource != null and not resource in audio_manage_scene_instance.sound_effects and resource is SoundEffect:
			modified = true
			# Add the resource to the AudioManager sound_effects array.
			audio_manage_scene_instance.sound_effects.append(resource)
	# Save the modified scene only if we've modified it.
	if modified == true:
		audio_manage_scene = PackedScene.new()
		audio_manage_scene.pack(audio_manage_scene_instance)
		ResourceSaver.save(audio_manage_scene, audio_manager_path)
		print("AudioManager updated. If you have the scene open in the editor, you may need to reload it to see the updates.")
	else:
		print("AudioManager was not updated, no new SoundEffect resources found.")
