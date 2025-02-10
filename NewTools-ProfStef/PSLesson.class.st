"
A lesson is a simple data object holding a name and an associated text that will be displayed by
the tutorialPlayer. 

"
Class {
	#name : 'PSLesson',
	#superclass : 'Object',
	#instVars : [
		'title',
		'lesson'
	],
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'instance creation' }
PSLesson class >> title: aStringForTitle lesson: aStringForLesson [
	^ self new title: aStringForTitle; lesson: aStringForLesson; yourself
]

{ #category : 'accessing' }
PSLesson >> lesson [
	^ lesson ifNil: [lesson := '']
]

{ #category : 'accessing' }
PSLesson >> lesson: aString [
	lesson := aString
]

{ #category : 'printing' }
PSLesson >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self title;
		nextPutAll: ')'
]

{ #category : 'accessing' }
PSLesson >> title [
	^ title ifNil: [title := '']
]

{ #category : 'accessing' }
PSLesson >> title: aString [
	title := aString
]
