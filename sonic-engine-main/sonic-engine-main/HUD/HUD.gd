extends CanvasLayer

var rings: int = 0
var time: float = 0.0

@onready var counter = $stats/rings/counter

@onready var minutes = $stats/time/m
@onready var seconds = $stats/time/s
#@onready var mSeconds = $time/ms

func _process(delta):
	time += delta
	
	counter.text = str(rings)
	
	#print(int(time)%60)
	
	if floor(int(time)/60) <= 9:
		minutes.text = "0"+str(floor(int(time)/60))
	else:
		minutes.text = str(floor(int(time)/60))
	if int(time)%60 <= 9:
		seconds.text = "0"+str(int(time)%60)
	else:
		seconds.text = str(int(time)%60)
