"
A binned histogram for floats with values between 0.0 and 10.0
page 25 table 2-4
"
Class {
	#name : 'DBBasicBinnedHistogram',
	#superclass : 'DBBasicRunning',
	#instVars : [
		'histogram'
	],
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'initialization' }
DBBasicBinnedHistogram >> compute [ 

	data do: [ :each |
		| binNumber |
		binNumber := (each * 100).
		histogram at: binNumber put: (histogram at: binNumber + 1)
		 ]
]

{ #category : 'initialization' }
DBBasicBinnedHistogram >> initialize [ 

	super initialize.
	histogram := Array new: 1000 withAll: 0.
]
