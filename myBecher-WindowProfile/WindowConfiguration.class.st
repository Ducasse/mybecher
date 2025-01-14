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

{ #category : 'accessing' }
WindowConfiguration >> extent [
	^ extent
]

{ #category : 'accessing' }
WindowConfiguration >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'accessing' }
WindowConfiguration >> kind: aClass [ 
	kind := aClass
]

{ #category : 'accessing' }
WindowConfiguration >> position: aPoint [ 
	position := aPoint
]
