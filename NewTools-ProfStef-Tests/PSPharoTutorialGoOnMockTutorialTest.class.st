"
SUnit tests for tutorial navigation
"
Class {
	#name : 'PSPharoTutorialGoOnMockTutorialTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'running' }
PSPharoTutorialGoOnMockTutorialTest >> setUp [
	super setUp.
	ProfStef tutorial: PSMockTutorial lesson: #firstLesson
]

{ #category : 'running' }
PSPharoTutorialGoOnMockTutorialTest >> tearDown [
	ProfStef default close.
	super tearDown
]

{ #category : 'tests' }
PSPharoTutorialGoOnMockTutorialTest >> testFirstLessonShouldBeDisplayed [
 	self assert:  'First lesson' equals: ProfStef default lessonView text
]

{ #category : 'tests' }
PSPharoTutorialGoOnMockTutorialTest >> testLastShouldGoToThirdLesson [
	ProfStef last.
 	self assert:  'Third lesson' equals: ProfStef default lessonView text
]

{ #category : 'tests' }
PSPharoTutorialGoOnMockTutorialTest >> testLastThenFirstShouldGoToFirstLesson [
	ProfStef last; first.
 	self assert:  'First lesson' equals: ProfStef default lessonView text
]

{ #category : 'tests' }
PSPharoTutorialGoOnMockTutorialTest >> testLastThenPreviousShouldGoToSecondLesson [
	ProfStef last; previous.
 	self assert:  'Second lesson' equals: ProfStef default lessonView text
]

{ #category : 'tests' }
PSPharoTutorialGoOnMockTutorialTest >> testNextShouldGoToSecondLesson [
	ProfStef next.
 	self assert:  'Second lesson' equals: ProfStef default lessonView text
]
