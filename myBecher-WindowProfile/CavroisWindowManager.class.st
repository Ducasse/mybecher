"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations also called place holders
A place holder is a description of the window on the screen (extent, position, kind, strategy)


open iceberg then 

```
CavroisWindowManager new profileFromWindows; placePresenter: IceTipRepositoriesBrowser new
```

should place the iceberg to the same place. 
"
Class {
	#name : 'CavroisWindowManager',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'initialization' }
CavroisWindowManager >> initialize [ 

	super initialize.
	classToolMapping := Dictionary new.
	self initializeMapping.
	profiles := OrderedCollection new. 
	"should probably be another dictionary with profile names as key"
]

{ #category : 'initialization' }
CavroisWindowManager >> initializeMapping [

	classToolMapping at: #ThreadSafeTranscript put: #Transcript.
	classToolMapping at: #StPlaygroundPresenter put: #Playground.
	classToolMapping at: #StPlayground put: #Playground.
	classToolMapping at: #ClyFullBrowserMorph put: #Calypso.
	classToolMapping at: #IceTipRepositoriesBrowser put: #IcebergBrowser.
	
	
]

{ #category : 'internals' }
CavroisWindowManager >> mapFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'as yet unclassified' }
CavroisWindowManager >> placeHolderFromSpWindow: aSpWindowPresenter [ 
	
	^ CavWindowPlaceHolder new
			extent: aSpWindowPresenter extent ;
			position: aSpWindowPresenter bounds origin;
			kind: (self mapFor: aSpWindowPresenter model presenter class name); 
			yourself
			
]

{ #category : 'as yet unclassified' }
CavroisWindowManager >> placeHolderFromSystemWindow: aSystemWindow [ 

	^ CavWindowPlaceHolder new 
		extent: aSystemWindow extent;
		position: aSystemWindow bounds origin;
		kind: (self mapFor: aSystemWindow model class name); 
		yourself 
]

{ #category : 'as yet unclassified' }
CavroisWindowManager >> placePresenter: aStPlayground [ 
	
	| placeHolder window |
	placeHolder := self profiles first placeHolderFor: (self mapFor: (aStPlayground class name)).
	window := aStPlayground open. 
	window hide.
	window extent: placeHolder extent. 
	window initialPosition: placeHolder position.
	window show.
	
]

{ #category : 'as yet unclassified' }
CavroisWindowManager >> profileFor: aString [ 
	"may be a dict should be better"	

	^ self profiles detect: [ :each | each kind = aString ]
]

{ #category : 'as yet unclassified' }
CavroisWindowManager >> profileFromWindows [
	"self new profileFromWindows"
	
	| profile allWindows |
	
	5 timesRepeat: [ 
		Smalltalk garbageCollect ].
	
	profile := CavWindowProfile new named: 'current'.
	
	allWindows := World windowsSatisfying: [:w | w isCollapsed not].
	
	"for old tools such trranscript"
	(allWindows select: [ :each | each class = SystemWindow ])
		 do: [ :each | profile add: (self placeHolderFromSystemWindow: each) ].
	(allWindows select: [ :each | each isKindOf: SpWindow ])
		 do: [ :each | profile add: (self placeHolderFromSpWindow: each) ].
	profiles add: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindowManager >> profiles [
	^ profiles ifNil: [ profiles := OrderedCollection new  ]
]
