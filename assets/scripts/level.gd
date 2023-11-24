extends Node

@export var idx: int

signal enter(idx: int)
signal exit(idx: int)

func on_enter():
	enter.emit(idx)

func on_exit():
	exit.emit(idx)
