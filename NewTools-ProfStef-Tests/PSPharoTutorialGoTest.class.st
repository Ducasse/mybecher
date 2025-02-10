"
SUnit tests for tutorial navigation
"
Class {
	#name : 'PSPharoTutorialGoTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'running' }
PSPharoTutorialGoTest >> tearDown [
	ProfStef default close.
	super tearDown
]

{ #category : 'tests' }
PSPharoTutorialGoTest >> testGoOnMockTutorial [
	| displayedText expected |
	ProfStef goOn: PSMockTutorial.

	displayedText := ProfStef default lessonView text.
	expected := PSMockTutorial new firstLesson lesson.
 	self assert: displayedText equals: expected
]

{ #category : 'tests' }
PSPharoTutorialGoTest >> testGoOpenSmalltalkSyntaxTutorial [
	| displayedText expected |
	ProfStef go.

	displayedText := ProfStef default lessonView text.
	expected := PharoSyntaxTutorial new welcome lesson.
 	self assert: displayedText equals: expected
]

{ #category : 'tests' }
PSPharoTutorialGoTest >> testGoTwiceShowLessonViewIfNotVisible [
	| firstLessonView |
	ProfStef go.
	firstLessonView := ProfStef default lessonView.
	firstLessonView close.
	ProfStef goOn: PharoSyntaxTutorial.
	self assert:  (self currentWorld systemWindows includes:  firstLessonView window)
]

{ #category : 'tests' }
PSPharoTutorialGoTest >> testGoTwiceUseSameLessonView [
	| firstLessonView |
	ProfStef go.
	firstLessonView := ProfStef default lessonView.
	ProfStef goOn: PharoSyntaxTutorial.
	self assert: firstLessonView identicalTo: ProfStef default lessonView
]

{ #category : 'tests' }
PSPharoTutorialGoTest >> testLessonViewIsScripting [

	| firstLessonView |
	firstLessonView := ProfStef default lessonView.
	self assert: firstLessonView isScripting
]
