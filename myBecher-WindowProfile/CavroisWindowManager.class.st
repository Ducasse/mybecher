"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations also called place holders
A place holder is a description of the window on the screen (extent, position, kind, strategy)


### Record 

```
CavroisWindowManager reset. 
CavroisWindowManager current resetProfiles; profileFromWindows.
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
((CavroisWindowManager current profileNamed: 'current') 
	placeHoldersFor: IceTipRepositoriesBrowser name) first
	strategy: CavStackingStrategy new

```

```
((CavroisWindowManager current profileNamed: 'current')  
	placeHoldersFor: IceTipRepositoriesBrowser name) first
	strategy: CavReplaceStrategy new

```

### Display

```
(CavroisWindowManager current profileNamed: 'current') placeHolders do: [:each | each display]
```	

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

{ #category : 'menu' }
CavroisWindowManager class >> profileList: aBuilder [ 

	<worldMenu> 
	self current profiles keysDo: [ : k | (aBuilder item: k)
		parent: #'User Profiles'; 
		order: 4;
		help: 'Profile']
	
]

{ #category : 'menu' }
CavroisWindowManager class >> profileMenu: aBuilder [

    <worldMenu>
    (aBuilder item: #Profiles)
        order: 95;
        with: [
            (aBuilder group: #UserProfiles)
                order: 1;
                withSeparatorAfter.
            (aBuilder group: #SavingDeleting)
                order: 2;
                withSeparatorAfter.
            (aBuilder group: #ImportExport)
                order: 3. ]
]

{ #category : 'menu items' }
CavroisWindowManager class >> profileMenuItems: aBuilder [

	<worldMenu>
	(aBuilder item: #'User Profiles')
		parent: #UserProfiles;
		order: 1;
		help: 'boubou';
		iconName: #userProfile.

	(aBuilder item: #'Save Profile')
		parent: #SavingDeleting;
		order: 3;
		help: 'boubou';
		iconName: #save.

	(aBuilder item: #'Delete Profile')
		parent: #SavingDeleting;
		order: 4;
		help: 'Takes a screenshot of the world´s current layout';
		iconName: #trash.

	(aBuilder item: #'Import Profile')
		parent: #ImportExport;
		order: 5;
		help: 'boubou';
		iconName: #smallUndo.

	(aBuilder item: #'Export Profile')
		parent: #ImportExport;
		order: 6;
		help: 'Takes a screenshot of the current layout';
		iconName: #smallRedo
]

{ #category : 'accessing' }
CavroisWindowManager class >> reset [  

	Current := nil
]

{ #category : 'accessing' }
CavroisWindowManager >> currentProfile [

	^ self profiles at: 'current'
]

{ #category : 'initialization' }
CavroisWindowManager >> initialize [ 

	super initialize.
	classToolMapping := Dictionary new.
	
	profiles := self resetProfiles.
	
	
]

{ #category : 'internals' }
CavroisWindowManager >> kindFor: aString [ 
	"return the key associated to the configuration"
	
	
	^ classToolMapping at: aString ifAbsent: [ #Unknown ]
]

{ #category : 'recording' }
CavroisWindowManager >> placeHolderFromWindow: aWindowPresenter [ 
	
	| placeHolder |
	placeHolder := CavWindowPlaceHolder new
			extent: aWindowPresenter extent ;
			position: aWindowPresenter bounds origin ;
			yourself.
	placeHolder configureStrategy.
	aWindowPresenter configurePlaceHolder: placeHolder.
	^ placeHolder 
			
]

{ #category : 'operations' }
CavroisWindowManager >> placePresenter: aPresenter [
	
	| placeHolder |

	placeHolder := (self profiles at: 'current') placeHoldersFor: aPresenter class name.
	placeHolder first strategy placeWindow: aPresenter.
	aPresenter open. 

]

{ #category : 'recording' }
CavroisWindowManager >> profileFromWindows [
	"self new profileFromWindows"

	| profile allWindows |
	5 timesRepeat: [ Smalltalk garbageCollect ].

	profile := CavWindowProfile new named: 'current'.
	allWindows := World windowsSatisfying: [ :w | w isCollapsed not ].

	allWindows do: [ :each |
		profile add: (self placeHolderFromWindow: each) ].
	profiles at: profile name  put: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindowManager >> profileNamed: aString [ 
	"may be a dict should be better"	

	^ profiles at: aString
]

{ #category : 'accessing' }
CavroisWindowManager >> profiles [
	^ profiles ifNil: [ self resetProfiles ]
]

{ #category : 'internals' }
CavroisWindowManager >> resetProfiles [

	profiles := Dictionary new.
	
	"not sure that I want this."
	profiles at: 'current' put: CavWindowProfile 
]
