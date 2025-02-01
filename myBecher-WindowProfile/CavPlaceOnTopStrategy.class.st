Class {
	#name : 'CavPlaceOnTopStrategy',
	#superclass : 'CavWindowStrategy',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'positioning' }
CavPlaceOnTopStrategy >> placeWindow: aWindow [

	aWindow position: placeHolder position


]
