Class {
	#name : 'BlNumberInputElement',
	#superclass : 'BlElement',
	#instVars : [
		'plus',
		'minus',
		'inputValue',
		'value',
		'inputLabel'
	],
	#category : 'myBecherBloc-Input',
	#package : 'myBecherBloc',
	#tag : 'Input'
}

{ #category : 'example' }
BlNumberInputElement class >> openInput [
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

{ #category : 'initialization' }
BlNumberInputElement >> backgroundPaint [

	^ Color black
]

{ #category : 'buttons' }
BlNumberInputElement >> changeValueTo: aValue [

	inputValue text: (self configuredString: aValue asString).
	inputValue text fontSize: 30.
	value := aValue
]

{ #category : 'buttons' }
BlNumberInputElement >> configuredString: aString [

	^ aString asRopedText attributes: { (BlTextForegroundAttribute paint: Color white) }.
	
]

{ #category : 'buttons' }
BlNumberInputElement >> createCircle [

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	^ circle
]

{ #category : 'buttons' }
BlNumberInputElement >> decreaseInput [

	value > 0 ifTrue: [ self changeValueTo: value - 1 ]
]

{ #category : 'buttons' }
BlNumberInputElement >> increaseInput [

	self changeValueTo: value + 1
]

{ #category : 'initialization' }
BlNumberInputElement >> initialize [

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	self label: 'Input'.
	self initializeMinusButton.
	self initializeInputValue: 20.
	self initializePlusButton.
	
	
	
	self defaultSkin: self newRawSkin
]

{ #category : 'initialization' }
BlNumberInputElement >> initializeInputValue: aValue [

	inputValue := BlTextElement new.
	inputValue constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	self changeValueTo: aValue.
	self addChild: inputValue
	


]

{ #category : 'buttons' }
BlNumberInputElement >> initializeMinusButton [

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

{ #category : 'buttons' }
BlNumberInputElement >> initializePlusButton [

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

{ #category : 'accessing' }
BlNumberInputElement >> inputExtent [ 

	^ 300@120
]

{ #category : 'accessing' }
BlNumberInputElement >> label [

	^ inputLabel 
]

{ #category : 'initialization' }
BlNumberInputElement >> label: aString [

	inputLabel := BlTextElement new.
	inputLabel text: (self configuredString: aString).
	inputLabel text fontSize: 25.
	inputLabel constraintsDo: [ :c | c frame horizontal alignCenter ].
	inputLabel transformDo: [ :t | t translateBy: 0 @ 10 ].
	self addChild: inputLabel
]

{ #category : 'accessing' }
BlNumberInputElement >> minus [
	^ minus
]

{ #category : 'accessing' }
BlNumberInputElement >> plus [
	^ plus
]

{ #category : 'evaluating' }
BlNumberInputElement >> value [

	^ value
]

{ #category : 'initialization' }
BlNumberInputElement >> value: anInteger [

	value := anInteger 
]
