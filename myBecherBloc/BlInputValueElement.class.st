Class {
	#name : #BlInputValueElement,
	#superclass : #BlTextElement,
	#category : #'myBecherBloc-Input'
}

{ #category : #initialization }
BlInputValueElement >> initialize [

	super initialize.
	self constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ]
]
