Class {
	#name : 'ToNumberInputElementTest',
	#superclass : 'ToParameterizedHostTest',
	#category : 'myBecherBloc-Input skin',
	#package : 'myBecherBloc',
	#tag : 'Input skin'
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
	"create instance of input"
	inputElem := ToNumberInputElement new changeValueTo: 12.
	"input skin is nil"
	self assert: inputElem background paint equals: nil.
	inputElem defaultRawSkin: ToInputElementSkin new.
	"Now the input widget has background defined"
	self waitTestingSpaces.
	self applyAllEnqueuedStates.
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
