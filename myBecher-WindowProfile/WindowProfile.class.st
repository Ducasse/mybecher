"
I'm a collection of window configuration (extent, position, kind)
"
Class {
	#name : 'WindowProfile',
	#superclass : 'Object',
	#instVars : [
		'configurationDictionary'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'accessing' }
WindowProfile >> configurationFor: aKey [


]

{ #category : 'initialization' }
WindowProfile >> initialize [ 
	
	super initialize.
	configurationDictionary := Dictionary new
]
