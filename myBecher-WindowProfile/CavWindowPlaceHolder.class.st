Class {
	#name : 'CavWindowPlaceHolder',
	#superclass : 'CavAbstractWindowPlaceHolder',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'operations' }
CavWindowPlaceHolder >> placePresenter: aPresenter [

	self strategy placeWindow: aPresenter
]
