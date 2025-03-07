"
I'm a strategy that never creates a new window.

I just checks if the window associated with the placeholder is present, and put it on top of all the windows in the world.
"
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
