extends Node

@export var body: CharacterBody3D
@export var controller: PlayerController
@export var walk: AudioStreamPlayer3D
@export var idle: AudioStreamPlayer3D

func _process(delta):
	var w = body.velocity.length() > 0.01
	var r = controller.is_rotationg
	if w or r:
		play(walk)
		stop(idle)
	else:
		play(idle)
		stop(walk)

func play(stream: AudioStreamPlayer3D):
	if stream && !stream.playing:
		stream.play()

func stop(stream: AudioStreamPlayer3D):
	if stream && stream.playing:
		stream.stop()
