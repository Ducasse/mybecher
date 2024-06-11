Class {
	#name : #ToNumberInputElement,
	#superclass : #ToElement,
	#instVars : [
		'plus',
		'minus',
		'inputValue',
		'value',
		'inputLabel'
	],
	#category : #'myBecherBloc-Input'
}

{ #category : #example }
ToNumberInputElement class >> openInputWithSkin [

	<script>
	| space anInput |
	space := BlSpace new.
	space toTheme: ToMooflooTheme new.
	anInput := self new position: 200 @ 200.

	space root addChild: anInput.
	space show.
	^ anInput
]

{ #category : #buttons }
ToNumberInputElement >> changeValueTo: aValue [

	inputValue text: (self configuredString: aValue asString).
	inputValue text fontSize: 30.
	value := aValue
]

{ #category : #buttons }
ToNumberInputElement >> configuredString: aString [

	^ aString asRopedText attributes: { (BlTextForegroundAttribute paint: Color white) }.
	
]

{ #category : #buttons }
ToNumberInputElement >> createCircle [

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	^ circle
]

{ #category : #buttons }
ToNumberInputElement >> decreaseInput [

	value > 0 ifTrue: [ self changeValueTo: value - 1 ]
]

{ #category : #buttons }
ToNumberInputElement >> increaseInput [

	self changeValueTo: value + 1
]

{ #category : #initialization }
ToNumberInputElement >> initialize [

	super initialize.
	self constraintsDo: [ :c |
		c vertical fitContent.
		c horizontal fitContent ].
	self padding: (BlInsets all: 30).
	self layout: BlLinearLayout horizontal.
	self border: (BlBorder paint: Color pink).
	self label: 'Input'.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self initializePlusButton
]

{ #category : #initialization }
ToNumberInputElement >> initializeInputValue: aValue [

	inputValue := BlTextElement new.
	inputValue constraintsDo: [ :c | c linear vertical alignCenter ].
	self changeValueTo: aValue.
	inputValue padding: (BlInsets all: 50).
	self addChild: inputValue
]

{ #category : #buttons }
ToNumberInputElement >> initializeMinusButton [

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c | c linear vertical alignCenter ].

	minus := BlTextElement new text: (self configuredString: '-').
	minus text fontSize: 80.
	minus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self decreaseInput ].
	circle padding: (BlInsets all: 50).
	circle addChild: minus.
	self addChild: circle
]

{ #category : #buttons }
ToNumberInputElement >> initializePlusButton [

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c | c linear vertical alignCenter ].

	plus := BlTextElement new text: (self configuredString: '+').
	plus text fontSize: 55.
	plus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self increaseInput ].
	circle padding: (BlInsets all: 50).
	circle addChild: plus.
	self addChild: circle
]

{ #category : #accessing }
ToNumberInputElement >> inputExtent [ 

	^ 300@120
]

{ #category : #accessing }
ToNumberInputElement >> label [

	^ inputLabel 
]

{ #category : #initialization }
ToNumberInputElement >> label: aString [

	inputLabel := BlTextElement new.
	inputLabel text: (self configuredString: aString).
	inputLabel text fontSize: 25.
	inputLabel constraintsDo: [ :c |
		c ignoreByLayout.
		c ignored horizontal alignCenter ].
	inputLabel padding: (BlInsets all: 10).
	self addChild: inputLabel
]

{ #category : #accessing }
ToNumberInputElement >> minus [
	^ minus
]

{ #category : #'instance creation' }
ToNumberInputElement >> newMooflooSkin [

	^ ToInputElementSkin new
]

{ #category : #'instance creation' }
ToNumberInputElement >> newRawSkin [

	^ ToInputElementSkin new
]

{ #category : #accessing }
ToNumberInputElement >> plus [
	^ plus
]

{ #category : #evaluating }
ToNumberInputElement >> value [

	^ value
]

{ #category : #initialization }
ToNumberInputElement >> value: anInteger [

	value := anInteger 
]
