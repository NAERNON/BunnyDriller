class_name InstrumentsStream

var streams
var nbStreams
var canSwing
var isPlaying
var toPlay
var nSixteenth
var nextPlaying
var randomNumberGenerator

func _init(s, nbS, cS, iP, tP):
	streams = s
	nbStreams = nbS
	canSwing = cS
	isPlaying = iP
	toPlay = tP
	nSixteenth = 0
	nextPlaying = false
	randomNumberGenerator = RandomNumberGenerator.new()

func GetRandomStream():
	var idx = randomNumberGenerator.randi_range(0, nbStreams-1)
	return streams[idx]

func HasToPlay(timeElapsedSinceStart, timeInSixteenth, swingDuration, sixteenthDuration):
	if canSwing and ((nSixteenth % 2) == 0) :
		var time = (timeElapsedSinceStart-swingDuration) / sixteenthDuration
		var sixteenthElapsed = int(floor(time))
		if sixteenthElapsed > nSixteenth:
			nSixteenth = sixteenthElapsed
			return toPlay[nSixteenth % 16]

	else :
		var sixteenthElapsed = int(floor(timeInSixteenth))
		if sixteenthElapsed > nSixteenth :
			nSixteenth = sixteenthElapsed
			return toPlay[nSixteenth % 16]

	if nSixteenth % 16 == 0 :
		nSixteenth = 0

	return false

func Maj():
	if nextPlaying :
		isPlaying = true
		nextPlaying = false

