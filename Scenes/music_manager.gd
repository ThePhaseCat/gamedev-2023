extends Node2D

@onready var menu = $MenuMusic
@onready var level1 = $Level1Music
@onready var level2 = $Level2Music
@onready var level3 = $Level3Music
@onready var level4 = $Level4Music

@onready var cutscene1 = $Cutscene1Music
@onready var cutscene2 = $Cutscene2Music
@onready var cutscene3 = $Cutscene3Music
@onready var cutscene4 = $Cutscene4Music

@onready var win = $WinMusic

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

func playCutscene1():
	stopMusic()
	cutscene1.play()

func playCutscene2():
	stopMusic()
	cutscene2.play()

func playCutscene3():
	stopMusic()
	cutscene3.play()

func playCutscene4():
	stopMusic()
	cutscene4.play()

func playWin():
	stopMusic()
	win.play()

func stopMusic():
	menu.stop()
	level1.stop()
	level2.stop()
	level3.stop()
	level4.stop()
	cutscene1.stop()
	cutscene2.stop()
	cutscene3.stop()
	cutscene4.stop()
	win.stop()
