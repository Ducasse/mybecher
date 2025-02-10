"
A LessonView mock for testing purposes
"
Class {
	#name : 'PSMockLessonView',
	#superclass : 'Object',
	#instVars : [
		'lesson',
		'title'
	],
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'testing' }
PSMockLessonView >> isOpenInWindow [
	^ true
]

{ #category : 'accessing' }
PSMockLessonView >> lesson [
	^ lesson
]

{ #category : 'gui' }
PSMockLessonView >> showLesson: aLesson withTitle: aString [
	lesson := aLesson.
	title := aString
]

{ #category : 'gui' }
PSMockLessonView >> showTutorialNode: aTutorialNode [
	lesson:= aTutorialNode lessons first.
	title := aTutorialNode title
]

{ #category : 'accessing' }
PSMockLessonView >> title [
	^ title
]
