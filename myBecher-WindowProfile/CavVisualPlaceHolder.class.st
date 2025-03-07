Class {
	#name : 'CavVisualPlaceHolder',
	#superclass : 'BorderedMorph',
	#instVars : [
		'placeHolder'
	],
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'actions' }
CavVisualPlaceHolder >> changeStrategy [

	| presenter desc |
	presenter := SpSelectDialog new
		             title: 'Change Strategy';
		             label: 'Select the strategy you want to use';
		             items: CavWindowStrategy subclasses;
		             onAccept: [ :dialog |
			             placeHolder strategy:
					             dialog presenter selectedItem new.
			             CavroisWindowManager current removeVisualPlaceholders ].
	desc := presenter newText.
	presenter defaultLayout add: desc.
	presenter list whenSelectionChangedDo: [
		desc text: presenter list selectedItem comment asString.
		self halt ].

	presenter openDialog
]

{ #category : 'api' }
CavVisualPlaceHolder >> contextMenu [

	self inform: 'ssss'
]

{ #category : 'initialization' }
CavVisualPlaceHolder >> initialize [

	super initialize.
	self borderWidth: 3.
	self borderColor: UITheme current selectionColor.
	self color: (UITheme current lightSelectionColor alpha: 0.2).
	self eventHandler: MorphicEventHandler new.
	self eventHandler on: #click send: #changeStrategy to: self.
	self eventHandler on: #yellowButtonPressed send: #contextMenu to: self
]

{ #category : 'accessing' }
CavVisualPlaceHolder >> placeHolder: aPlaceHolder [

	placeHolder := aPlaceHolder
]
