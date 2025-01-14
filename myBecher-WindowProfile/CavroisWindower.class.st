"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations with a name.
A WindowConfiguration is a description of the window on the screen (extent, position, kind, strategy)

"
Class {
	#name : 'CavroisWindower',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'as yet unclassified' }
CavroisWindower >> collectSystemWindows: aCollection [ 
	
	aCollection do: [ :e | self profileFromSystemWindow: e ]
]

{ #category : 'as yet unclassified' }
CavroisWindower >> configurationFromSystemWindow: aSystemWindow [ 
	
	^ WindowConfiguration new 
		extent: aSystemWindow extent;
		position: aSystemWindow bounds origin;
		kind: aSystemWindow model class name; 
		yourself 
]

{ #category : 'initialization' }
CavroisWindower >> initialize [ 

	super initialize.
	classToolMapping := Dictionary new.
	self initializeMapping.
]

{ #category : 'initialization' }
CavroisWindower >> initializeMapping [

	classToolMapping at: #ThreadSafeTranscript put: #Transcript.
	
	
]

{ #category : 'as yet unclassified' }
CavroisWindower >> mapFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'as yet unclassified' }
CavroisWindower >> profileFromSystemWindow: aSystemWindow [ 
	
	^ WindowConfiguration new 
		extent: aSystemWindow extent;
		position: aSystemWindow position;
		kind: aSystemWindow model class; 
		yourself 
]

{ #category : 'accessing' }
CavroisWindower >> profiles [
	^ profiles ifNil: [ profiles := OrderedCollection new  ]
]
