Class {
	#name : 'CavStackingStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'positioning' }
CavStackingStrategy >> placeWindow: aWindow [
	"for now just stupid"

	aWindow position: placeHolder position + ((20@20) * placeHolder count).
	placeHolder increment.  


]
