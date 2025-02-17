Class {
	#name : 'CavVisualPlaceHolder',
	#superclass : 'BorderedMorph',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'initialization' }
CavVisualPlaceHolder >> initialize [

	super initialize. 
	self borderWidth: 3.
	self borderColor:  (UITheme current selectionColor).
	self color: (UITheme current lightSelectionColor alpha: 0.2)
]
