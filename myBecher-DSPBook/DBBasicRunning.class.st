"
a one pass computation of mean and standard deviation
"
Class {
	#name : 'DBBasicRunning',
	#superclass : 'Object',
	#instVars : [
		'data',
		'n',
		'sum',
		'sumsquares',
		'mean',
		'standardDeviation'
	],
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'accessing' }
DBBasicRunning >> compute [

	data do: [ :each | 
		n := n + 1. 
		sum := sum + each.
		sumsquares := sumsquares + ( each * each ) 
		].
	mean := sum / n.
	n = 1 
		ifTrue: [ standardDeviation := 0 ]
		ifFalse: [ standardDeviation := ((sumsquares - ((sum * sum) / n)) / (n -1)) sqrt]

]

{ #category : 'accessing' }
DBBasicRunning >> data: aCollection [

	data := aCollection.
	self compute.
]

{ #category : 'initialization' }
DBBasicRunning >> initialize [ 
	
	n := 0.
	sum := 0.
	sumsquares := 0
]

{ #category : 'initialization' }
DBBasicRunning >> mean [

	^ mean
]

{ #category : 'initialization' }
DBBasicRunning >> standardDeviation [

	^ standardDeviation
]
