"
I can navigate through an AbstractTutorial subclass (which defines lessons). With #next and #previous, you can go forward and backward through the tutorial. 
"
Class {
	#name : 'PSTutorialPlayer',
	#superclass : 'Object',
	#instVars : [
		'tutorialPosition',
		'tutorial'
	],
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'accessing' }
PSTutorialPlayer >> currentLesson [
	^ self tutorial lessonAt: self tutorialPosition
]

{ #category : 'navigating' }
PSTutorialPlayer >> first [
	"Go to the first lesson of the current tutorial and return it."
	self rewind.
	^ self currentLesson
]

{ #category : 'navigating' }
PSTutorialPlayer >> last [
	"Go to the last lesson of the current tutorial and return it."

	tutorialPosition := self size.
	^ self currentLesson
]

{ #category : 'navigating' }
PSTutorialPlayer >> next [
	self tutorialPosition < self size
		ifTrue: [ tutorialPosition := tutorialPosition + 1 ].
	^ self currentLesson
]

{ #category : 'navigating' }
PSTutorialPlayer >> previous [
	tutorialPosition >  1 ifTrue: [ tutorialPosition := tutorialPosition  - 1 ].
	^ self currentLesson
]

{ #category : 'navigating' }
PSTutorialPlayer >> rewind [
	tutorialPosition := 1
]

{ #category : 'accessing' }
PSTutorialPlayer >> size [
	^ self tutorial size
]

{ #category : 'accessing' }
PSTutorialPlayer >> tutorial [
	^ tutorial  ifNil: [ tutorial := PSPharoSyntaxTutorial new ]
]

{ #category : 'accessing' }
PSTutorialPlayer >> tutorial: aTutorialInstance [
	"Set on which tutorial instance the receiver is working."
	tutorial := aTutorialInstance
]

{ #category : 'accessing' }
PSTutorialPlayer >> tutorialPosition [
	^ tutorialPosition
		ifNil: [
			self rewind.
			tutorialPosition ]
]

{ #category : 'accessing' }
PSTutorialPlayer >> tutorialPosition: aTutorialPosition [

	tutorialPosition := aTutorialPosition
]
