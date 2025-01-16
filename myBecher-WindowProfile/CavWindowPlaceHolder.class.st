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
		'strategy'
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
CavWindowPlaceHolder >> extent [
	^ extent
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> kind [
	^ kind
]

{ #category : 'accessing' }
CavWindowPlaceHolder >> kind: aClass [ 
	kind := aClass
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
	aStream nextPutAll: '(', self kind, ')'
]
