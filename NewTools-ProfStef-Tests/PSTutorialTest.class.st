Class {
	#name : 'PSTutorialTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'testing' }
PSTutorialTest class >> isAbstract [

	^self = PSTutorialTest
]

{ #category : 'tests' }
PSTutorialTest >> testEachSelectorExists [
	self testedTutorial tutorial do: [:aSelector|
		self assert: (self testedTutorial respondsTo: aSelector)
	]
]

{ #category : 'tests' }
PSTutorialTest >> testEachSelectorReturnsALesson [
	| answer |
	self testedTutorial tutorial do: [:aSelector|
		answer := (self testedTutorial perform: aSelector).
		self assert: (answer isKindOf: Lesson).
	]
]

{ #category : 'tests' }
PSTutorialTest >> testLessonAtReturnsCorrespondingLesson [
	| answer |
	1 to: (self testedTutorial tutorial size) do: [:index|
		answer := self testedTutorial lessonAt: index.
		self assert: (answer isKindOf: Lesson)
	]
]

{ #category : 'tests' }
PSTutorialTest >> testNotEmpty [
	self assert: self testedTutorial tutorial notEmpty
]

{ #category : 'tests' }
PSTutorialTest >> testSizeReturnsNumberOfSelectors [
	self assert: (self testedTutorial tutorial size) equals: self testedTutorial size
]
