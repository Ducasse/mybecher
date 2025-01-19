"
I'm a collection of window configuration (extent, position, kind)
"
Class {
	#name : 'CavWindowProfile',
	#superclass : 'Object',
	#instVars : [
		'profileName',
		'placeHolders',
		'placeHolderDictionary'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'adding' }
CavWindowProfile >> add: aCavroisWindowPlaceHolder [

	(placeHolderDictionary 
		at: aCavroisWindowPlaceHolder kind 
		ifPresent: [ placeHolderDictionary at: aCavroisWindowPlaceHolder kind ] 
		ifAbsent: [ 
			| col |
			col := OrderedCollection new.
			placeHolderDictionary at: aCavroisWindowPlaceHolder kind put: col.
			col ]) add: aCavroisWindowPlaceHolder.
	placeHolders add: aCavroisWindowPlaceHolder
]

{ #category : 'adding' }
CavWindowProfile >> hasPlaceHolderFor: aString [

	^ placeHolderDictionary keys includes: aString
]

{ #category : 'initialization' }
CavWindowProfile >> initialize [ 
	
	super initialize.
	placeHolderDictionary := Dictionary new.
	placeHolders := OrderedCollection new.
]

{ #category : 'accessing' }
CavWindowProfile >> named: aString [ 
	profileName := aString
]

{ #category : 'accessing' }
CavWindowProfile >> placeHolderFor: aString [ 
	
	^ placeHolderDictionary at: aString ifAbsent: [ CavWindowPlaceHolder new kind: 'Unrecorded'; yourself  ]
]

{ #category : 'accessing' }
CavWindowProfile >> placeHoldersFor: aString [ 
	
	^ placeHolderDictionary at: aString
]
