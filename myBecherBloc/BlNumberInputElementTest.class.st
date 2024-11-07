Class {
	#name : 'BlNumberInputElementTest',
	#superclass : 'TestCase',
	#category : 'myBecherBloc-Input',
	#package : 'myBecherBloc',
	#tag : 'Input'
}

{ #category : 'tests' }
BlNumberInputElementTest >> testCanChangeLabel [

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem label text asString equals: 'Input'.
	inputElem label: 'Volume'.
	self assert: inputElem label text asString equals: 'Volume'.
]

{ #category : 'tests' }
BlNumberInputElementTest >> testEverythingIsInitializedCorrectly [

	| inputElem |
	inputElem := BlNumberInputElement new.
	self assert: inputElem children size equals: 4 
]

{ #category : 'tests' }
BlNumberInputElementTest >> testValueCantBeNegative [

	| inputElem value |
	inputElem := BlNumberInputElement new.
	inputElem changeValueTo: 0.
	BlSpace simulateClickOn: inputElem minus.
	value := inputElem value. 
	self assert: value equals: 0
]

{ #category : 'tests' }
BlNumberInputElementTest >> testValueUpdatedOnClick [

	| inputElem |
	inputElem := BlNumberInputElement new.
	BlSpace simulateClickOn: inputElem minus.
	self assert: inputElem value equals: 19.
	6 timesRepeat: [ BlSpace simulateClickOn: inputElem plus ].
	self assert: inputElem value equals: 25
]
