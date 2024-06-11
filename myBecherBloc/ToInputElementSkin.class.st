Class {
	#name : #ToInputElementSkin,
	#superclass : #ToBasicMooflooSkin,
	#category : #'myBecherBloc-Input'
}

{ #category : #'event handling' }
ToInputElementSkin >> installLookEvent: anEvent [
	"when installing the skin, changes the properties of widget mentionned down here"

	super installLookEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (BlBorder
				 paint: (e valueOfTokenNamed: #'color-border')
				 width: (e valueOfTokenNamed: #'line-width')).
		e background: Color red.
		e geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
		e plus parent background: Color blue.
		e minus parent background: Color red ]
]
