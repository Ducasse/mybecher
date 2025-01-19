Class {
	#name : 'CavStackingStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'as yet unclassified' }
CavStackingStrategy >> placeWindow: aWindow [
	"for now just stupid"
	placeHolder increment. 
	aWindow position: placeHolder position + ((20@20) * placeHolder count) 


]
