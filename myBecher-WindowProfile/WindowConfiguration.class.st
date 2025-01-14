"
A WindowConfiguration is a description of the window on the screen (extent, position, kind, strategy)
"
Class {
	#name : 'WindowConfiguration',
	#superclass : 'Object',
	#instVars : [
		'extent',
		'kind',
		'position',
		'strategy'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'as yet unclassified' }
WindowConfiguration class >> exampleTranscript [

	^ self new 
		extent: 400@666;
		position: 180.0@106.0;
		kind: #Transcript;
		yourself


	
]

{ #category : 'accessing' }
WindowConfiguration >> extent [
	^ extent
]

{ #category : 'accessing' }
WindowConfiguration >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'accessing' }
WindowConfiguration >> kind [
	^ kind
]

{ #category : 'accessing' }
WindowConfiguration >> kind: aClass [ 
	kind := aClass
]

{ #category : 'accessing' }
WindowConfiguration >> position [
	^ position
]

{ #category : 'accessing' }
WindowConfiguration >> position: aPoint [ 
	position := aPoint
]
