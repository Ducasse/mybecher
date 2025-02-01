Class {
	#name : 'CavReplaceStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'positioning' }
CavReplaceStrategy >> placeWindow: aWindow [
	"for now just stupid"
	
	aWindow position: placeHolder position.
	"do we keep a reference to the window from the placeholder?
	this way we could avoid to scan all the window."
	
	"this does not work for now"
	(SystemWindow allInstances select: [ :each | each position = placeHolder position ]) 
		do: [ :each | each delete ]

]
