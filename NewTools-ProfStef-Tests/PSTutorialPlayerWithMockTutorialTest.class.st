"
SUnit tests for tutorial player
"
Class {
	#name : 'PSTutorialPlayerWithMockTutorialTest',
	#superclass : 'TestCase',
	#instVars : [
		'player'
	],
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'running' }
PSTutorialPlayerWithMockTutorialTest >> setUp [
	| tutorial |
	super setUp.
	tutorial := PSMockTutorial new.
	player := TutorialPlayer new tutorial: tutorial
]

{ #category : 'tests' }
PSTutorialPlayerWithMockTutorialTest >> testCurrentLessonIsFirstOneAtCreation [
	self assert: player currentLesson title equals: 'first'
]

{ #category : 'tests' }
PSTutorialPlayerWithMockTutorialTest >> testNavigation [
	self assert: player next title equals: 'second'.
	self assert: player currentLesson title equals: 'second'.

	self assert: player next title equals: 'third'.
	self assert: player currentLesson title equals: 'third'.

	self assert: player next title equals: 'third'.
	self assert: player currentLesson title equals: 'third'.

	self assert: player previous title equals: 'second'.
	self assert: player currentLesson title equals: 'second'.

	self assert: player previous title equals: 'first'.
	self assert: player currentLesson title equals: 'first'.

	self assert: player previous title equals: 'first'.
	self assert: player currentLesson title equals: 'first'
]

{ #category : 'tests' }
PSTutorialPlayerWithMockTutorialTest >> testResetTutorialGoBackToFirstLesson [
	player next; next.
	self assert: player currentLesson title equals: 'third'.

	player rewind.
	self assert: player currentLesson title equals: 'first'
]

{ #category : 'tests' }
PSTutorialPlayerWithMockTutorialTest >> testSizeReturnsThree [
	self assert: player size equals: 3
]
