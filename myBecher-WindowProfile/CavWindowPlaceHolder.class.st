"
A WindowConfiguration is a description of the window on the screen (extent, position, kind, strategy)
"
Class {
	#name : 'CavWindowPlaceHolder',
	#superclass : 'Object',
	#instVars : [
		'extent',
		'kind',
		'position',
		'strategy',
		'count'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'as yet unclassified' }
CavWindowPlaceHolder class >> exampleTranscript [

	^ self new 
		extent: 400@666;
		position: 180.0@106.0;
		kind: #Transcript;
		yourself


	
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> count [
	^ count
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> extent [
	^ extent
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'initialization' }
CavWindowPlaceHolder >> increment [ 
	
	count := count + 1
]

{ #category : 'initialization' }
CavWindowPlaceHolder >> initialize [

	super initialize. 
	strategy := CavStackingStrategy new.
	"count is counting the number of opened window.
	not really nice but let us get started."
	count := 0.	

]

{ #category : 'accessing' }
CavWindowPlaceHolder >> kind [

	^ kind
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> kind: anObject [

	kind := anObject
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> position [
	^ position
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> position: aPoint [ 
	position := aPoint
]

{ #category : 'printing' }
CavWindowPlaceHolder >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '(', kind, ' ', self strategy class name, ')'
]

{ #category : 'printing' }
CavWindowPlaceHolder >> resetCount [ 
	 
	count := 0.
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> strategy [ 

	^ strategy
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> strategy: aStrategy [

	strategy := aStrategy
]
