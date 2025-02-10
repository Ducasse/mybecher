"
SUnit tests for lessons
"
Class {
	#name : 'PSLessonInstanciationTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'tests' }
PSLessonInstanciationTest >> testNewLessonHaveEmptyStringForTitleLesson [
	| newLesson  |
	newLesson := Lesson new.
	self assert: newLesson title equals: ''.
	self assert: newLesson lesson equals: ''
]

{ #category : 'tests' }
PSLessonInstanciationTest >> testTitleLessonCreation [
	| firstLesson secondLesson |
	firstLesson := Lesson title: 'First lesson' lesson: 'Pharo rules!'.
	secondLesson := Lesson title: 'Second lesson' lesson: 'PharoTutorial is cool'.

	self assert: firstLesson title equals: 'First lesson'.
	self assert: firstLesson lesson equals: 'Pharo rules!'.

	self assert: secondLesson title equals: 'Second lesson'.
	self assert: secondLesson lesson equals: 'PharoTutorial is cool'
]
