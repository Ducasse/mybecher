Extension { #name : 'SpWindow' }

{ #category : '*myBecher-WindowProfile' }
SpWindow >> configurePlaceHolder: aPlaceHolder [
	
	aPlaceHolder kind: self model presenter class 
]

{ #category : '*myBecher-WindowProfile' }
SpWindow >> extent: aPoint [ 
	| announcement oldExtent |

	oldExtent := self extent. 
	super extent: aPoint.
	announcement := SpWindowResizing new
		window: self;
		oldSize: oldExtent;
		newSize: aPoint;
		yourself.
	self announce: announcement.
	self currentWorld announcer announce: announcement.
	
	model ifNotNil: [
		model extent: aPoint ].
]

{ #category : '*myBecher-WindowProfile' }
SpWindow >> position: aNewPosition [

	super position: aNewPosition.
	model ifNotNil: [ model position: aNewPosition ]
]
