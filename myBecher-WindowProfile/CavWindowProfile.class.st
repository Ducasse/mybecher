"
I'm a collection of window configuration (extent, position, kind)
"
Class {
	#name : 'CavWindowProfile',
	#superclass : 'Object',
	#instVars : [
		'profileName',
		'placeHolders',
		'placeholderDictionary'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'adding' }
CavWindowProfile >> add: aCavroisWindowPlaceHolder [ 
	placeHolders add: aCavroisWindowPlaceHolder 
]

{ #category : 'accessing' }
CavWindowProfile >> configurationFor: aKey [


]

{ #category : 'initialization' }
CavWindowProfile >> initialize [ 
	
	super initialize.
	placeholderDictionary := Dictionary new.
	"should decide probably the dict is better with kind as key eg transcript, playground...."
	placeHolders := OrderedCollection new.
]

{ #category : 'instance creation' }
CavWindowProfile >> named: aString [ 
	profileName := aString
]

{ #category : 'as yet unclassified' }
CavWindowProfile >> placeHolderFor: aString [ 
	
	"we use use a dictionary"
	
	^ placeHolders detect: [ :each | each kind = aString ]
]
