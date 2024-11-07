Class {
	#name : 'ToNumberInputElement',
	#superclass : 'ToElement',
	#instVars : [
		'plus',
		'minus',
		'inputValue',
		'value',
		'inputLabel',
		'validateValueBlock'
	],
	#category : 'myBecherBloc-Input skin',
	#package : 'myBecherBloc',
	#tag : 'Input skin'
}

{ #category : 'example' }
ToNumberInputElement class >> openInputWithSkin [

	<script>
	| space anInput |
	space := BlSpace new.
	space toTheme: MfMooflodTheme new.
	anInput := self new position: 200 @ 200.
	space root addChild: anInput.
	space show.
	^ anInput
]

{ #category : 'buttons' }
ToNumberInputElement >> changeValueTo: aValue [

	inputValue text: (self configuredString: aValue asString).
	inputValue text fontSize: 30.
	value := aValue
]

{ #category : 'buttons' }
ToNumberInputElement >> configuredString: aString [

	^ aString asRopedText attributes: { (BlTextForegroundAttribute paint: Color white) }.
	
]

{ #category : 'buttons' }
ToNumberInputElement >> createCircle [

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	^ circle
]

{ #category : 'buttons' }
ToNumberInputElement >> decreaseInput [
	
	(validateValueBlock value: value - 1) ifTrue: [
		value := value - 1.
		self changeValueTo: value ]
]

{ #category : 'buttons' }
ToNumberInputElement >> increaseInput [

	(validateValueBlock value: value + 1) ifTrue: [
		value := value + 1.
		self changeValueTo: value ]
]

{ #category : 'initialization' }
ToNumberInputElement >> initialize [

	super initialize.
	self constraintsDo: [ :c |
		c vertical fitContent.
		c horizontal fitContent ].
	self padding: (BlInsets all: 30).
	self layout: BlLinearLayout horizontal.
	self border: (BlBorder paint: Color pink).
	self validateValueBlock: [ :v | v between: 1 and: 25 ].
	self label: 'Input'.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self initializePlusButton
]

{ #category : 'initialization' }
ToNumberInputElement >> initializeInputValue: aValue [

	inputValue := BlTextElement new.
	inputValue size: 30 @ 30.
	inputValue constraintsDo: [ :c | c linear vertical alignCenter ].
	self changeValueTo: aValue.
	inputValue padding: (BlInsets all: 50).
	self addChild: inputValue
]

{ #category : 'buttons' }
ToNumberInputElement >> initializeMinusButton [

	| text |
	minus := self createCircle.
	minus constraintsDo: [ :c | c linear vertical alignCenter ].

	text := BlTextElement new text: (self configuredString: '-').
	text text fontSize: 80.
	text constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	minus
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self decreaseInput ].
	minus padding: (BlInsets all: 50).
	minus addChild: text.
	self addChild: minus
]

{ #category : 'buttons' }
ToNumberInputElement >> initializePlusButton [

	| text |
	plus := self createCircle.
	plus constraintsDo: [ :c | c linear vertical alignCenter ].

	text := BlTextElement new text: (self configuredString: '+').
	text text fontSize: 55.
	text constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	plus
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self increaseInput ].
	plus padding: (BlInsets all: 50).
	plus addChild: text.
	
	self addChild: plus
]

{ #category : 'accessing' }
ToNumberInputElement >> inputExtent [ 

	^ 300@120
]

{ #category : 'accessing' }
ToNumberInputElement >> label [

	^ inputLabel 
]

{ #category : 'initialization' }
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

{ #category : 'accessing' }
ToNumberInputElement >> minus [
	^ minus
]

{ #category : 'instance creation' }
ToNumberInputElement >> newMooflodSkin [

	^ ToInputElementSkin new
]

{ #category : 'instance creation' }
ToNumberInputElement >> newRawSkin [
	self halt.
	^ ToInputElementSkin new
]

{ #category : 'accessing' }
ToNumberInputElement >> plus [
	^ plus
]

{ #category : 'accessing' }
ToNumberInputElement >> validateValueBlock [

	^ validateValueBlock
]

{ #category : 'evaluating' }
ToNumberInputElement >> validateValueBlock: aBlock [

	validateValueBlock := aBlock
]

{ #category : 'evaluating' }
ToNumberInputElement >> value [

	^ value
]

{ #category : 'initialization' }
ToNumberInputElement >> value: anInteger [

	value := anInteger 
]
