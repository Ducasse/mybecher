"
A naive histogram based mean and standard deviation for integers between 1 and 255.
page 21 table 2-3
"
Class {
	#name : 'DBBasicHistogram',
	#superclass : 'DBBasicRunning',
	#instVars : [
		'histogram',
		'variance'
	],
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'accessing' }
DBBasicHistogram >> compute [

	data do: [ :each |
		histogram at: each put: (histogram at: each) + 1 ].
	
	histogram withIndexDo: [ :each :index |
		sum := sum + (each * index)  ].	
	mean := sum / data size.
	histogram  withIndexDo: [ :each :index |
		variance := variance + (each * ((index - mean) squared))].
	variance := variance / (data size -1).
	standardDeviation := variance sqrt 
	
	
]

{ #category : 'accessing' }
DBBasicHistogram >> initialize [ 

	super initialize.
	"in this example we only have values between 0 and 255"
	histogram := Array new: 256 withAll: 0.
	variance := 0.
	
]
