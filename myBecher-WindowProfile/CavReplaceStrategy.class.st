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
	self halt.
	(SystemWindow allInstances select: [ :each | self halt. each position = placeHolder position ]) 
		do: [ :each | each delete ]

]
