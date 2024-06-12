Class {
	#name : 'ToNumberInputElementTest',
	#superclass : 'TestCase',
	#category : 'myBecherBloc-Input',
	#package : 'myBecherBloc',
	#tag : 'Input'
}

{ #category : 'tests' }
ToNumberInputElementTest >> testCanChangeLabel [

	| inputElem |
	inputElem := ToNumberInputElement new.
	self assert: inputElem label text asString equals: 'Input'.
	inputElem label: 'Volume'.
	self assert: inputElem label text asString equals: 'Volume'
]

{ #category : 'tests' }
ToNumberInputElementTest >> testEverythingIsInitializedCorrectly [

	| inputElem |
	inputElem := ToNumberInputElement new.
	self assert: inputElem children size equals: 4
]

{ #category : 'tests' }
ToNumberInputElementTest >> testSkinisInstalledCorrectly [

	| inputElem |
	self skip.
	"create instance of input"
	inputElem := ToNumberInputElement new changeValueTo: 12.
	"input skin is nil"
	self assert: inputElem background paint equals: nil.
	inputElem openInput: inputElem. "Assign skin to input"
	"Now the input widget has background defined"
	self assert: inputElem background paint color equals: Color black
]

{ #category : 'tests' }
ToNumberInputElementTest >> testValueCantBeNegative [

	| inputElem value |
	inputElem := ToNumberInputElement new.
	inputElem changeValueTo: 0.
	BlSpace simulateClickOn: inputElem minus.
	value := inputElem value.
	self assert: value equals: 0
]

{ #category : 'tests' }
ToNumberInputElementTest >> testValueUpdatedOnClick [

	| inputElem |
	inputElem := ToNumberInputElement new.
	BlSpace simulateClickOn: inputElem minus.
	self assert: inputElem value equals: 19.
	6 timesRepeat: [ BlSpace simulateClickOn: inputElem plus ].
	self assert: inputElem value equals: 25
]
