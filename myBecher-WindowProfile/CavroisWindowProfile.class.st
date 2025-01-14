"
I'm a collection of window configuration (extent, position, kind)
"
Class {
	#name : 'CavroisWindowProfile',
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
CavroisWindowProfile >> add: aCavroisWindowPlaceHolder [ 
	placeHolders add: aCavroisWindowPlaceHolder 
]

{ #category : 'accessing' }
CavroisWindowProfile >> configurationFor: aKey [


]

{ #category : 'initialization' }
CavroisWindowProfile >> initialize [ 
	
	super initialize.
	placeholderDictionary := Dictionary new.
	"should decide probably the dict is better with kind as key eg transcript, playground...."
	placeHolders := OrderedCollection new.
]

{ #category : 'instance creation' }
CavroisWindowProfile >> named: aString [ 
	profileName := aString
]
