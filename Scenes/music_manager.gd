extends Node2D

@onready var menu = $MenuMusic
@onready var level1 = $Level1Music
@onready var level2 = $Level2Music
@onready var level3 = $Level3Music
@onready var level4 = $Level4Music

func playMenu():
	stopMusic()
	menu.play()

func playLevel1():
	stopMusic()
	level1.play()

func playLevel2():
	stopMusic()
	level2.play()

func playLevel3():
	stopMusic()
	level3.play()

func playLevel4():
	stopMusic()
	level4.play()

func stopMusic():
	menu.stop()
	level1.stop()
	level2.stop()
	level3.stop()
	level4.stop()
