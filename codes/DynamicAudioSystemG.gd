extends Node

@export var minimalBPM : int
@export var maximalBPM : int

@export var minimalSwing : float
@export var maximalSwing : float

# Current BPM of the music (in quarter per minute).
var currentBPM

# Current swing factor
var currentSwing

# Next BPM to apply in the next bar
var nextBPM

# Next Swing factor to apply in the next bar
var nextSwing

# Time elapsed since beginning of the game (in seconds).
var time

# Number of sixteen notes passed.
var nSixteenth

var instruments

@export var clavesHigh : AudioStreamPlayer
@export var clavesLow : AudioStreamPlayer

@export var cowbell : AudioStreamPlayer

@export var maracasLong : AudioStreamPlayer
@export var maracasShort : AudioStreamPlayer

@export var tambourine : AudioStreamPlayer

@export var timbales : AudioStreamPlayer

@export var congaOpenSlap : AudioStreamPlayer
@export var congaCloseSlap : AudioStreamPlayer
@export var congaLowTipTone : AudioStreamPlayer
@export var congaHighFloating : AudioStreamPlayer

@export var bongoHigh : AudioStreamPlayer
@export var bongoLow : AudioStreamPlayer
@export var woodBlockHigh : AudioStreamPlayer
@export var woodBlockLow : AudioStreamPlayer

@export var hitHatOpen : AudioStreamPlayer
@export var hitHatFootClose : AudioStreamPlayer
@export var kick : AudioStreamPlayer
@export var snareCenter : AudioStreamPlayer

@export var snareRimshot : AudioStreamPlayer
@export var hiTom : AudioStreamPlayer
@export var midTom : AudioStreamPlayer
@export var lowTom : AudioStreamPlayer

@export var claps1 : AudioStreamPlayer
@export var claps2 : AudioStreamPlayer


var isPlaying
var startTime
var playNext

var randomNumberGenerator



# Called when the node enters the scene tree for the first time.
func _ready():
	randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()

	time = 0.0
	currentBPM = minimalBPM
	nextBPM = minimalBPM
	nSixteenth = 0
	currentSwing = minimalSwing
	nextSwing = minimalSwing

	# CLAVES
	var clavesStream      	      = InstrumentsStream.new([clavesHigh], 1, true, true, [false, false, false, false, true, false, false, false, true, false, false, true, false, false, false, true])

	# COWBELL
	var cowbellStream    	      = InstrumentsStream.new([cowbell], 1, true, true, [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false])

	# MARACAS
	var maracasStream              = InstrumentsStream.new([maracasLong, maracasShort], 2, true, true, [false, false, true, false, false, false, true, false, false, false, true, false, false, false, true, false])

	# TAMBOURINE
	var tambourineStream   	      = InstrumentsStream.new([tambourine], 1, true, true, [false, false, true, false, false, false, false, false, false, false, true, false, false, false, false, false])

	var timbalesStream             = InstrumentsStream.new([timbales], 1, true, true, [true, false, true, true, true, false, true, true, false, true, true, false, true, false, true, true])

	var congaOpenSlapStream        = InstrumentsStream.new([congaOpenSlap], 1, true, false, [true, false, false, false, false, false, false, true, false, true, false, false, false, false, true, false])
	var congaCloseSlapStream       = InstrumentsStream.new([congaCloseSlap], 1, true, false, [false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, false])
	var congaLowTipToneStream      = InstrumentsStream.new([congaLowTipTone], 1, true, false, [false, false, false, false, false, false, true, false, false, false, false, false, false, false, false, true])
	var congaHighFloatingStream    = InstrumentsStream.new([congaHighFloating], 1, true, false, [false, false, true, true, false, false, false, false, true, false, true, true, false, false, false, false])

	var bongoHighStream            = InstrumentsStream.new([bongoHigh], 1, true, false, [false, false, false, true, false, false, false, false, false, false, false, true, false, false, false, false])
	var bongoLowStream             = InstrumentsStream.new([bongoLow], 1, true, false, [false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, false])
	var woodBlockHighStream        = InstrumentsStream.new([woodBlockHigh], 1, true, false, [true, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false])
	var woodBlockLowStream         = InstrumentsStream.new([woodBlockLow], 1, true, false, [false, true, true, false, false, true, false, true, false, true, true, false, false, true, false, true])


	
	var hitHatOpenStream           = InstrumentsStream.new([hitHatOpen], 1, true, false, [true, false, false, false, true, false, true, false, false, false, false, false, true, false, false, false])
	var hitHatFootCloseStream      = InstrumentsStream.new([hitHatFootClose], 1, true, false, [false, false, true, false, false, false, false, false,  true, false, true, false, false, false, true, false])
	var kickStream                 = InstrumentsStream.new([kick], 1, true, false, [true, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false])
	var snareCenterStream          = InstrumentsStream.new([snareCenter], 1, true, false, [false, false, false, false, true, false, true, false, false, false, false, false, true, false, false, false])
	var snareRimshotStream         = InstrumentsStream.new([snareRimshot], 1, true, false, [false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false])

	var hiTomStream                = InstrumentsStream.new([hiTom], 1, true, false, [true, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false])

	var midTomStream               = InstrumentsStream.new([midTom], 1, true, false, [true, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false])
	var lowTomStream               = InstrumentsStream.new([lowTom], 1, true, false, [false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false])

	var clapsStream                = InstrumentsStream.new([claps1, claps2], 2, true, false, [true, false, false, false, true, false, true, true, false, false, true, false, false, false, false, false])




	instruments = [clavesStream, cowbellStream, maracasStream, tambourineStream, timbalesStream, congaOpenSlapStream, congaCloseSlapStream, congaLowTipToneStream, congaHighFloatingStream, bongoHighStream, bongoLowStream, woodBlockHighStream, woodBlockLowStream, hitHatOpenStream, hitHatFootCloseStream, kickStream, snareCenterStream, snareRimshotStream, hiTomStream, midTomStream, lowTomStream, clapsStream]

	isPlaying = false
	startTime = 0.0
	playNext = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UpdateBPM()
	if isPlaying:
		if playNext:
			playNext = false
			for i in range(22):
				if instruments[i].isPlaying and instruments[i].toPlay[0]:
					var streamToPlay = instruments[i].GetRandomStream()
					streamToPlay.play()

		time = Time.get_unix_time_from_system()

		var timeElapsedSinceStart = time - startTime

		var sixteenthDuration = 1.0 / ((currentBPM * 4.0) / 60.0)
		var swingDuraton = sixteenthDuration * currentSwing
		#GD.Print("Sixteenth duraction : " + sixteenthDuration.ToString())
		var timeInSixteenth = timeElapsedSinceStart / sixteenthDuration
		#GD.Print("timeInSixteenth : " + timeInSixteenth.ToString())

		var sixteenthElapsed   = int(floor(timeInSixteenth))

		for i in range(22):
			if instruments[i].isPlaying and instruments[i].HasToPlay(timeElapsedSinceStart, timeInSixteenth, swingDuraton, sixteenthDuration):
				var streamToPlay = instruments[i].GetRandomStream()
				streamToPlay.play()

		if sixteenthElapsed > nSixteenth:
			nSixteenth = sixteenthElapsed

			if nSixteenth % 16 == 0:
				currentBPM = nextBPM
				currentSwing = nextSwing
				startTime = Time.get_unix_time_from_system()
				nSixteenth = 0

				for i in range(22):
					instruments[i].Maj()


func Play() :
	isPlaying = true
	startTime = Time.get_unix_time_from_system()
	playNext = true


func Stop() :
	isPlaying = false
	startTime = 0.0


func ActivateBattery() :
	for i in range(13,17):
		instruments[i].nextPlaying = true

func ActivateTom():
	for i in range(17,21):
		instruments[i].nextPlaying = true


func ActivateConga():
	for i in range(9,13):
		instruments[i].nextPlaying = true

func ActivateBongo() :
	for i in range(5,9):
		instruments[i].nextPlaying = true

func ActivateClaps():
	instruments[21].nextPlaying = true

func _on_timer_swing_timeout():
	nextSwing = currentSwing
	if currentSwing < maximalSwing:
		nextSwing = currentSwing+0.15

func UpdateBPM():
	nextBPM = currentBPM
	nextBPM = min(maximalBPM, minimalBPM+(Global.mindureePousses - Global.dureePousses) * 100.0)

	if currentBPM > 83 :
		ActivateConga()

	if currentBPM > 92 :
		ActivateBongo()

	if currentBPM > 98 :
		ActivateBattery()

	if currentBPM > 104  :
		ActivateTom()

	if currentBPM > 87 :
		ActivateClaps()


func _on_joueur_first_move_player():
	Play();



func _on_joueur_fin_du_tour_joueur():
	Play();
