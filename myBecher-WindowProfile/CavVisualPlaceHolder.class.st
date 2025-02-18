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

	| presenter |
	presenter := SpSelectDialog new
		             title: 'Change Strategy';
		             label: 'Select the strategy you want to use';
		             items: CavWindowStrategy subclasses;
		             onAccept: [ :dialog |
			             placeHolder strategy: dialog presenter selectedItem new ].
	presenter openDialog
]

{ #category : 'initialization' }
CavVisualPlaceHolder >> initialize [

	super initialize.
	self borderWidth: 3.
	self borderColor: UITheme current selectionColor.
	self color: (UITheme current lightSelectionColor alpha: 0.2).
	self eventHandler: MorphicEventHandler new.
	self eventHandler on: #click send: #changeStrategy to: self
]

{ #category : 'accessing' }
CavVisualPlaceHolder >> placeHolder: aPlaceHolder [

	placeHolder := aPlaceHolder
]
