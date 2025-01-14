"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations with a name.
A WindowConfiguration is a description of the window on the screen (extent, position, kind, strategy)

"
Class {
	#name : 'WindowProfilor',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'as yet unclassified' }
WindowProfilor >> collectSystemWindows: aCollection [ 
	
	aCollection do: [ :e | self profileFromSystemWindow: e ]
]

{ #category : 'as yet unclassified' }
WindowProfilor >> configurationFromSystemWindow: aSystemWindow [ 
	
	^ WindowConfiguration new 
		extent: aSystemWindow extent;
		position: aSystemWindow bounds origin;
		kind: aSystemWindow model class name; 
		yourself 
]

{ #category : 'as yet unclassified' }
WindowProfilor >> profileFromSystemWindow: aSystemWindow [ 
	
	^ WindowConfiguration new 
		extent: aSystemWindow extent;
		position: aSystemWindow position;
		kind: aSystemWindow model class; 
		yourself 
]

{ #category : 'accessing' }
WindowProfilor >> profiles [
	^ profiles ifNil: [ profiles := OrderedCollection new  ]
]
