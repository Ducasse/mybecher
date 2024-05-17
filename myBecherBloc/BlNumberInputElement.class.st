Class {
	#name : #BlNumberInputElement,
	#superclass : #BlElement,
	#instVars : [
		'plus',
		'minus',
		'inputValue',
		'value'
	],
	#category : #'myBecherBloc-Input'
}

{ #category : #'as yet unclassified' }
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

{ #category : #initialization }
BlNumberInputElement >> backgroundPaint [

	^ Color black
]

{ #category : #buttons }
BlNumberInputElement >> decreaseInput [

value > 0 ifTrue: [ 
	value := value - 1 ].
inputValue removeFromParent.
inputValue := self initializeInputValue: value asString.

]

{ #category : #buttons }
BlNumberInputElement >> increaseInput [

value := value + 1.
inputValue removeFromParent .
inputValue:= self initializeInputValue: value asString.
]

{ #category : #initialization }
BlNumberInputElement >> initialize [

	super initialize.
	self size: self inputExtent.
	self background: self backgroundPaint.
	self geometry: (BlRoundedRectangleGeometry cornerRadius: 20).
	self layout: BlFrameLayout new.
	self border: (BlBorder paint: Color pink).
	plus := self initializePlusButton.
	minus := self initializeMinusButton.
	inputValue := self initializeInputValue.
	value := inputValue text asString asNumber.
	self initializeInputText 
]

{ #category : #initialization }
BlNumberInputElement >> initializeInputText [

	| input |
	input := BlTextInputElement new.
	self addChild: input.
	^ input 
]

{ #category : #initialization }
BlNumberInputElement >> initializeInputValue [

	^ self initializeInputValue: '20'
]

{ #category : #initialization }
BlNumberInputElement >> initializeInputValue: aValue [

| ivalue|
ivalue := BlInputValueElement new.
ivalue  text: aValue asRopedText.
ivalue text attributes:  { (BlTextForegroundAttribute paint: Color white)}.
ivalue text fontSize: 30.
self addChild: ivalue.

^ivalue
]

{ #category : #buttons }
BlNumberInputElement >> initializeMinusButton [

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	circle constraintsDo: [ :c |
		c frame horizontal alignLeft.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: 15 @ 0 ].

	minus := BlTextElement new text: ('-' asRopedText attributes:
			          { (BlTextForegroundAttribute paint: Color white) }).
	minus text fontSize: 80.
	minus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self decreaseInput ].

	circle addChild: minus.
	self addChild: circle.

	^ circle
]

{ #category : #buttons }
BlNumberInputElement >> initializePlusButton [

	| circle |
	circle := BlElement new
		          background: Color black;
		          border: (BlBorder paint: Color pink width: 2);
		          layout: BlFrameLayout new;
		          geometry: BlCircleGeometry new.
	circle constraintsDo: [ :c |
		c frame horizontal alignRight.
		c frame vertical alignCenter ].
	circle transformDo: [ :t | t translateBy: -15 @ 0 ].

	plus := BlTextElement new text: ('+' asRopedText attributes:
			         { (BlTextForegroundAttribute paint: Color white) }).
	plus text fontSize: 55.
	plus constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	circle
		addEventHandlerOn: BlMouseDownEvent
		do: [ :e | self increaseInput ].
	circle addChild: plus.
	self addChild: circle.

	^ circle
]

{ #category : #buttons }
BlNumberInputElement >> inputExtent [ 

	^ 300@120
]

{ #category : #accessing }
BlNumberInputElement >> minus [
	^ minus
]

{ #category : #buttons }
BlNumberInputElement >> openInput: anInput [
	| space |
	space := BlSpace new.
	space root
		background: Color purple ;
		layout: BlFlowLayout horizontal.
	anInput transformDo: [ :c |
		c translateBy: 200@200
		 ].
	space root addChild: anInput  .
	space show.
	^ anInput 
]

{ #category : #accessing }
BlNumberInputElement >> plus [
	^ plus
]

{ #category : #evaluating }
BlNumberInputElement >> value [

	^ value
]
