"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations also called place holders
A place holder is a description of the window on the screen (extent, position, kind, strategy)


### Record 

```
CavroisWindowManager reset. 
CavroisWindowManager current reset; profileFromWindows.
```

### Place

```
CavroisWindowManager current
	placePresenter: IceTipRepositoriesBrowser new.
		
CavroisWindowManager current
	placePresenter: StPlaygroundPresenter new.	
```

### Trying with strategy

```
(CavroisWindowManager current profiles first placeHolderFor: IceTipRepositoriesBrowser name)
	strategy: CavStackingStrategy new

```
"
Class {
	#name : 'CavroisWindowManager',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping',
		'strategy'
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
	
	profiles := OrderedCollection new. 
	"should probably be another dictionary with profile names as key"
	strategy := CavStackingStrategy new.
]

{ #category : 'internals' }
CavroisWindowManager >> kindFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'operations' }
CavroisWindowManager >> placeHolderFromWindow: aWindowPresenter [ 
	
	| placeHolder |
	placeHolder := CavWindowPlaceHolder new
			extent: aWindowPresenter extent ;
			position: aWindowPresenter bounds origin;
			yourself.
	self setDefaultStrategyTo: placeHolder.
	aWindowPresenter configurePlaceHolder: placeHolder.
	^ placeHolder 
			
]

{ #category : 'operations' }
CavroisWindowManager >> placePresenter: aStPlayground [ 
	
	| placeHolder |
	placeHolder := self profiles first placeHolderFor: aStPlayground class name.
	"we should move the following logic to the placeHolder so that we can have a neutral one
	what do we do when we do not find one, we return freePlacing...."
	
	aStPlayground position: placeHolder position.
	aStPlayground extent: placeHolder extent.
	placeHolder strategy placeWindow: aStPlayground.
	aStPlayground open. 

]

{ #category : 'accessing' }
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
	"(allWindows select: [ :each | each class = SystemWindow ])
		 do: [ :each | profile add: (self placeHolderFromSystemWindow: each) ].
	(allWindows select: [ :each | each isKindOf: SpWindow ])
		 do: [ :each | profile add: (self placeHolderFromSpWindow: each) ]."
	allWindows do: [ :each | profile add: (self placeHolderFromWindow: each) ].
	profiles add: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindowManager >> profiles [
	^ profiles ifNil: [ self reset  ]
]

{ #category : 'internals' }
CavroisWindowManager >> reset [

	profiles := OrderedCollection new
]

{ #category : 'operations' }
CavroisWindowManager >> setDefaultStrategyTo: placeHolder [

	placeHolder strategy: (strategy placeHolder: placeHolder)
			
]
