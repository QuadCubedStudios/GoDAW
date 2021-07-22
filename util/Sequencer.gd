class_name Sequencer extends Node

# Data
var data: SongSequence
var playing: bool setget set_playing, is_playing
var paused: bool setget set_paused, is_paused


# Signals
signal finished


# Functions
func play():
	set_playing(true)
	# Code to play

func stop():
	set_playing(false)
	# Code to stop

func seek():
	# Change with code to seek
	pass


# Setgets
func set_playing(val: bool):
	playing = val

func is_playing():
	return playing

func set_paused(val: bool):
	paused = val

func is_paused():
	return paused
