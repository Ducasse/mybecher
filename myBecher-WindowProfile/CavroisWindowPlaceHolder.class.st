"
A WindowConfiguration is a description of the window on the screen (extent, position, kind, strategy)
"
Class {
	#name : 'CavroisWindowPlaceHolder',
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
CavroisWindowPlaceHolder class >> exampleTranscript [

	^ self new 
		extent: 400@666;
		position: 180.0@106.0;
		kind: #Transcript;
		yourself


	
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> extent [
	^ extent
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> kind [
	^ kind
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> kind: aClass [ 
	kind := aClass
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> position [
	^ position
]

{ #category : 'accessing' }
CavroisWindowPlaceHolder >> position: aPoint [ 
	position := aPoint
]
