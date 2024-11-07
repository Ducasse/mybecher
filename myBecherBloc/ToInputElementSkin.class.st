Class {
	#name : 'ToInputElementSkin',
	#superclass : 'ToBasicMooflodSkin',
	#category : 'myBecherBloc-Input skin',
	#package : 'myBecherBloc',
	#tag : 'Input skin'
}

{ #category : 'event handling' }
ToInputElementSkin >> installSkinEvent: anEvent [
	"when installing the skin, changes the properties of widget mentionned down here"

	self halt.
	super installSkinEvent: anEvent.
	anEvent elementDo: [ :e |
		e border: (BlBorder
				 paint: (e valueOfTokenNamed: #'color-border')
				 width: (e valueOfTokenNamed: #'line-width')).
		e background: Color red.
		e geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
		e plus background: Color blue.
		e minus background: Color red ]
]
