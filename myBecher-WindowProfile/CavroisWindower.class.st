"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations also called place holders
A place holder is a description of the window on the screen (extent, position, kind, strategy)

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

{ #category : 'initialization' }
CavroisWindower >> initialize [ 

	super initialize.
	classToolMapping := Dictionary new.
	self initializeMapping.
	profiles := OrderedCollection new. 
	"should probably be another dictionary with profile names as key"
]

{ #category : 'initialization' }
CavroisWindower >> initializeMapping [

	classToolMapping at: #ThreadSafeTranscript put: #Transcript.
	classToolMapping at: #StPlaygroundPresenter put: #Playground.
	
	
]

{ #category : 'internals' }
CavroisWindower >> mapFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'as yet unclassified' }
CavroisWindower >> placeHolderFromSpWindow: aSpWindowPresenter [ 
	
	^ CavroisWindowPlaceHolder new
			extent: aSpWindowPresenter extent ;
			position: aSpWindowPresenter bounds origin;
			kind: (self mapFor: aSpWindowPresenter model presenter class name); 
			yourself
			
]

{ #category : 'as yet unclassified' }
CavroisWindower >> placeHolderFromSystemWindow: aSystemWindow [ 
	
	^ CavroisWindowPlaceHolder new 
		extent: aSystemWindow extent;
		position: aSystemWindow bounds origin;
		kind: (self mapFor: aSystemWindow model class name); 
		yourself 
]

{ #category : 'as yet unclassified' }
CavroisWindower >> profileFromWindows [
	
	| profile allWindows |
	profile := CavroisWindowProfile new named: 'current'.
	
	allWindows := World windowsSatisfying: [:w | w isCollapsed not].
	
	"for old tools such trranscript"
	(allWindows select: [ :each | each class = SystemWindow ])
		 do: [ :each | profile add: (self placeHolderFromSystemWindow: each) ].
		
	(allWindows select: [ :each | each class isKindOf: SpWindow ])
		 do: [ :each | profile add: (self placeHolderFromSpWindow: each) ].
	profiles add: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindower >> profiles [
	^ profiles ifNil: [ profiles := OrderedCollection new  ]
]
