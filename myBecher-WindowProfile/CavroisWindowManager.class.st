"
I scan the current windows and build a profile from the presenters or tools inside them. 

A profile is set of window configurations also called place holders
A place holder is a description of the window on the screen (extent, position, kind, strategy)


### Record 

```
CavroisWindowManager reset. 
CavroisWindowManager current resetProfiles.
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
((CavroisWindowManager current currentProfile) 
	placeHoldersFor: IceTipRepositoriesBrowser name) first
	strategy: CavStackingStrategy new

```

```
((CavroisWindowManager current currentProfile)  
	placeHoldersFor: IceTipRepositoriesBrowser name) first
	strategy: CavReplaceStrategy new

```

### Display

```
(CavroisWindowManager current currentProfile) placeHolders do: [:each | each display]
```	

"
Class {
	#name : 'CavroisWindowManager',
	#superclass : 'Object',
	#instVars : [
		'profiles',
		'classToolMapping',
		'currentProfile'
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
CavroisWindowManager class >> profileMenu: aBuilder [

    <worldMenu>
    (aBuilder item: #Profiles)
        order: 95;
        with: [
            (aBuilder group: #UserProfiles)
                order: 1;
                withSeparatorAfter.
            (aBuilder group: #ProfileAction)
                order: 2;
                withSeparatorAfter.
            (aBuilder group: #ImportExport)
                order: 3. ]
]

{ #category : 'menu items' }
CavroisWindowManager class >> profileMenuItems: aBuilder [

	<worldMenu>
	| presenter oldProfile newProfile oldKey newKey baseName collection |
	self current profiles keysDo: [ :k |
		(aBuilder item: k)
			parent: #UserProfiles;
			action: [
				oldProfile := self current currentProfile.
				newProfile := self current profiles at: k.
				oldProfile = newProfile ifFalse: [
						oldKey := self current profiles keyAtValue: oldProfile.
						baseName := oldKey copyReplaceAll: '(Current)' with: ''.
						self current profiles at: baseName put: oldProfile.
						self current profiles removeKey: oldKey.
						newKey := k , '(Current)'.
						self current profiles at: newKey put: newProfile.
						self current profiles removeKey: k.
						self current currentProfile: newProfile.
						MenubarMorph reset ] ];
			order: 4;
			help: 'Profile';
			iconName: #userProfile ].

	(aBuilder item: #'Snapshot Profile')
		parent: #ProfileAction;
		order: 3;
		action: [
			presenter := SpRequestDialog new.
			presenter
				title: 'Snapshot Profile';
				label: 'What is the name of your profile?';
				text: '';
				acceptLabel: 'Confirm';
				cancelLabel: 'Cancel';
				onAccept: [ :dialog |
					self current currentProfile ifNotNil: [
							oldProfile := self current currentProfile.
							oldKey := self current profiles keyAtValue: oldProfile.
							newKey := oldKey copyReplaceAll: '(Current)' with: ''.
							self current profiles at: newKey put: oldProfile.
							self current profiles removeKey: oldKey ].
					self current addProfileFromWindows: dialog presenter text.
					MenubarMorph reset ];
				openDialog ];
		help: 'Creates a local profile based on your image';
		iconName: #save.

	(aBuilder item: #'Delete Profile')
		parent: #ProfileAction;
		order: 5;
		action: [
			self current profiles isNotEmpty ifTrue: [
					collection := OrderedCollection new.
					self current profiles keysDo: [ :k | collection add: k ].
					presenter := SpSelectDialog new.
					presenter
						title: 'Delete profile';
						label: 'Select the profile you want to remove';
						items: collection;
						onAccept: [ :dialog |
							self current profiles removeKey: dialog presenter selectedItem.
							self current profiles isEmpty ifTrue: [
									self current currentProfile: nil ].
							MenubarMorph reset ];
						openDialog ] ];
		help: 'Remove a profile';
		iconName: #trash.

	(aBuilder item: #'Show/Unshow current profile')
		parent: #ProfileAction;
		order: 4;
		action: [
			(World submorphs anySatisfy: [ :morph |
					 morph isKindOf: CavVisualPlaceHolder ])
				ifTrue: [ self current removeVisualPlaceholders ]
				ifFalse: [
					self current currentProfile ifNotNil: [
							self current currentProfile placeHolders do: [ :each |
									each display ] ] ] ];
		help: 'Show the placeholders of the current profile in the World';
		iconName: #haloView .

	(aBuilder item: #'Import Profile')
		parent: #ImportExport;
		order: 6;
		help: 'boubou';
		iconName: #smallUndo.


	(aBuilder item: #'Export Profile')
		parent: #ImportExport;
		order: 7;
		help: 'bibi';
		iconName: #smallRedo
]

{ #category : 'accessing' }
CavroisWindowManager class >> reset [

	<script>
	Current := nil.
	MenubarMorph reset
]

{ #category : 'recording' }
CavroisWindowManager >> addProfileFromWindows: aProfileName [
	"self new profileFromWindows"

	| profile allWindows |
	5 timesRepeat: [ Smalltalk garbageCollect ].

	profile := CavWindowProfile new named: aProfileName.
	allWindows := self currentWorld windowsSatisfying: [ :w |
		              w isCollapsed not ].

	allWindows do: [ :each |
		profile add: (self placeHolderFromWindow: each) ].
	profiles at: profile name , '(Current)' put: profile.
	self currentProfile: profile.
	^ profile
]

{ #category : 'accessing' }
CavroisWindowManager >> currentProfile [

	^ currentProfile 
]

{ #category : 'accessing' }
CavroisWindowManager >> currentProfile: aProfile [

	currentProfile := aProfile
]

{ #category : 'initialization' }
CavroisWindowManager >> initialize [

	super initialize.
	classToolMapping := Dictionary new.

	self resetProfiles
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
	self currentProfile ifNotNil: [
		placeHolder := self currentProfile placeHoldersFor:
			               aPresenter class name.
		placeHolder first placePresenter: aPresenter ]
]

{ #category : 'accessing' }
CavroisWindowManager >> profileNamed: aString [ 
	"may be a dict should be better"	

	^ profiles at: aString
]

{ #category : 'accessing' }
CavroisWindowManager >> profiles [
	^ profiles ifNil: [ self resetProfiles. profiles ]
]

{ #category : 'removing' }
CavroisWindowManager >> removeVisualPlaceholders [

	World submorphs
		select: [ :morph | morph isKindOf: CavVisualPlaceHolder ]
		thenDo: [ :morph | morph delete ].
			World submorphs
		select: [ :morph | morph visible = false ]
		thenDo: [ :morph | morph visible: true ]
]

{ #category : 'internals' }
CavroisWindowManager >> resetProfiles [

	profiles := Dictionary new
]
