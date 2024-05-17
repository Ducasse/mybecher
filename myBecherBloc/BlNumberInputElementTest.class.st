Class {
	#name : #BlNumberInputElementTest,
	#superclass : #TestCase,
	#category : #'myBecherBloc-Input'
}

{ #category : #tests }
BlNumberInputElementTest >> testEverythingIsInitializedCorrectly [

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem children size equals: 4 
]

{ #category : #tests }
BlNumberInputElementTest >> testValueCantBeNegative [

	| inputElem value |
	inputElem := BlNumberInputElement new.
	value := (inputElem initializeInputValue: '0') text asString asNumber.
	BlSpace simulateClickOn: inputElem minus.
	self assert: value equals: 0
]

{ #category : #tests }
BlNumberInputElementTest >> testValueUpdatedOnClick [

	| inputElem |
	inputElem := BlNumberInputElement new.
	BlSpace simulateClickOn: inputElem minus.
	self assert: inputElem value equals: 19.
	6 timesRepeat: [ BlSpace simulateClickOn: inputElem plus ].
	self assert: inputElem value equals: 25
]
