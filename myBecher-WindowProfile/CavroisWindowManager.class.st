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
	#classVars : [
		'Current'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'accessing' }
CavroisWindowManager class >> current [ 

	^ Current ifNil: [ Current := self new ]
]

{ #category : 'accessing' }
CavroisWindowManager class >> reset [  

	Current := nil
]

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
CavroisWindowManager >> kindFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'operations' }
CavroisWindowManager >> placeHolderFromSpWindow: aSpWindowPresenter [ 
	
	^ CavWindowPlaceHolder new
			extent: aSpWindowPresenter extent ;
			position: aSpWindowPresenter bounds origin;
			kind: (self kindFor: aSpWindowPresenter model presenter class name); 
			yourself
			
]

{ #category : 'operations' }
CavroisWindowManager >> placeHolderFromSystemWindow: aSystemWindow [ 

	^ CavWindowPlaceHolder new 
		extent: aSystemWindow extent;
		position: aSystemWindow bounds origin;
		kind: (self kindFor: aSystemWindow model class name); 
		yourself 
]

{ #category : 'operations' }
CavroisWindowManager >> placePresenter: aStPlayground [ 
	
	| placeHolder |
	placeHolder := self profiles first placeHolderFor: (self kindFor: (aStPlayground class name)).
	aStPlayground position: placeHolder position.
	aStPlayground extent: placeHolder extent.
	aStPlayground open. 

]

{ #category : 'operations' }
CavroisWindowManager >> profileFor: aString [ 
	"may be a dict should be better"	

	^ self profiles detect: [ :each | each kind = aString ]
]

{ #category : 'operations' }
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
