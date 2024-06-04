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
ToNumberInputElement class >> openInput [
	<script>
	| space anInput |
	anInput := self new.
	space := BlSpace new.
	space root
		background: Color purple;
		layout: BlFlowLayout horizontal.
	anInput transformDo: [ :c | c translateBy: 200 @ 200 ].
	space root addChild: anInput.
	space show.
	^ anInput
]

{ #category : #example }
ToNumberInputElement class >> openInputWithSkin [

	<script>
	| space anInput |
	anInput := self new.
	anInput defaultSkin: anInput newRawSkin.
	space := BlSpace new.
	space root
		background: Color purple;
		layout: BlFlowLayout horizontal.
	anInput transformDo: [ :c | c translateBy: 200 @ 200 ].
	space root addChild: anInput.
	space toTheme: ToInputElementTheme new.
	space applyAllSkinInstallers.

	space show.
	^ anInput
]

{ #category : #initialization }
ToNumberInputElement >> backgroundPaint [

	^ Color black
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
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self initializePlusButton.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self label: 'Input'
]

{ #category : #initialization }
ToNumberInputElement >> initializeInputValue: aValue [

	inputValue := BlTextElement new.
	inputValue constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	self changeValueTo: aValue.
	self addChild: inputValue
	


]

{ #category : #buttons }
ToNumberInputElement >> initializeMinusButton [

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: 15 @ 0 ].

	minus := BlTextElement new text: (self configuredString: '-').
	minus text fontSize: 80.
	minus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self decreaseInput ].

	circle addChild: minus.
	self addChild: circle.
	
]

{ #category : #buttons }
ToNumberInputElement >> initializePlusButton [

	| circle |
	circle := self createCircle.
	circle constraintsDo: [ :c |
		c frame horizontal alignRight.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: -15 @ 0 ].

	plus := BlTextElement new text: (self configuredString: '+').
	plus text fontSize: 55.
	plus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self increaseInput ].
	circle addChild: plus.
	self addChild: circle.

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
	inputLabel constraintsDo: [ :c | c frame horizontal alignCenter ].
	inputLabel transformDo: [ :t | t translateBy: 0 @ 10 ].
	self addChild: inputLabel
]

{ #category : #accessing }
ToNumberInputElement >> minus [
	^ minus
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
