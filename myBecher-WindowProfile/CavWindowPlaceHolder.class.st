Class {
	#name : 'CavWindowPlaceHolder',
	#superclass : 'CavAbstractWindowPlaceHolder',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'operations' }
CavWindowPlaceHolder >> placePresenter: aPresenter [

	aPresenter position: self position.
	aPresenter extent: self extent.
	self strategy placeWindow: aPresenter.
]
