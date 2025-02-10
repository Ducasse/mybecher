"
SUnit tests for tutorial navigation
"
Class {
	#name : 'PSPharoTutorialNavigationTest',
	#superclass : 'TestCase',
	#instVars : [
		'prof',
		'mockView'
	],
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'running' }
PSPharoTutorialNavigationTest >> setUp [
	super setUp.
	prof := ProfStef new.
	prof player: (
		TutorialPlayer new
			tutorial: PSMockTutorial new;
			yourself).
	mockView := PSMockLessonView new.
	prof lessonView: mockView.
	prof open
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testNextOpenSecondLesson [
	prof next.
	self assert: mockView title equals: 'second (2/3)'.
	self assert: mockView lesson lesson equals: 'Second lesson'
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testSequenceNextNextOpenThirdLesson [
	prof next; next.
	self assert: mockView title equals: 'third (3/3)'.
	self assert: mockView lesson lesson equals: 'Third lesson'
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testSequenceNextNextPreviousOpenSecondLesson [
	prof next; next; previous.
	self assert: mockView title equals: 'second (2/3)'.
	self assert: mockView lesson lesson equals: 'Second lesson'
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testShowFirstLessonOnGo [
	| lesson |
	lesson := mockView lesson.
	self assert: lesson title equals: 'first'.
	self assert: lesson lesson equals: 'First lesson'
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testShowingLessonByIndex [
	prof tutorial: PSMockTutorial lessonAt: 2.
	self assert: mockView title equals: 'second (2/3)'.
	self assert: mockView lesson lesson equals: 'Second lesson'
]

{ #category : 'tests' }
PSPharoTutorialNavigationTest >> testShowingLessonBySelector [
	prof tutorial: PSMockTutorial lesson: #firstLesson.
	self assert: mockView title equals: 'first (1/3)'.
	self assert: mockView lesson lesson equals: 'First lesson'
]
