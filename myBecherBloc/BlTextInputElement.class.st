Class {
	#name : #BlTextInputElement,
	#superclass : #BlTextElement,
	#category : #'myBecherBloc-Input'
}

{ #category : #initialization }
BlTextInputElement >> initialize [

	super initialize.
	self
		text: ('Input' asRopedText
		attributes: { (BlTextForegroundAttribute paint: Color white) }).
	self text fontSize: 25.
	self constraintsDo: [ :c | c frame horizontal alignCenter ].
	self transformDo: [ :t | t translateBy: 0 @ 10 ]
]
