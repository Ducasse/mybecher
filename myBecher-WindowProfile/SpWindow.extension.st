Extension { #name : 'SpWindow' }

{ #category : '*myBecher-WindowProfile' }
SpWindow >> configurePlaceHolder: aPlaceHolder [
	
	aPlaceHolder kind: self model presenter class 
]

{ #category : '*myBecher-WindowProfile' }
SpWindow >> position: aNewPosition [

	super position: aNewPosition.
	model ifNotNil: [ model position: aNewPosition ]
]
