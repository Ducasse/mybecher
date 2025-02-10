"
Mocking a tutorial for test purposes
"
Class {
	#name : 'PSMockTutorial',
	#superclass : 'AbstractTutorial',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'lesson' }
PSMockTutorial >> firstLesson [
	^ Lesson title: 'first' lesson: 'First lesson'
]

{ #category : 'lesson' }
PSMockTutorial >> secondLesson [
	^ Lesson title: 'second' lesson: 'Second lesson'
]

{ #category : 'lesson' }
PSMockTutorial >> thirdLesson [
	^ Lesson title: 'third' lesson: 'Third lesson'
]

{ #category : 'tutorial' }
PSMockTutorial >> tutorial [
	^ #(
firstLesson
secondLesson
thirdLesson
)
]
