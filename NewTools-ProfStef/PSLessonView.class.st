"
A LessonView displays a Lesson instance.

LessonView new open
"
Class {
	#name : 'PSLessonView',
	#superclass : 'Object',
	#instVars : [
		'shoutMorph',
		'window',
		'sourceTextModel'
	],
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'gui' }
PSLessonView class >> menuOn: aBuilder [
	<LessonViewContextMenu>

	(aBuilder item: #'Do it' translated)
		keyText: 'd';
		selector: #doIt;
		help: nil;
		iconName: #smallDoIt.
	(aBuilder item: #'Print it' translated)
		keyText: 'p';
		selector: #printIt;
		help: nil;
		iconName: #smallPrintIt.
	(aBuilder item: #'Inspect it' translated)
		keyText: 'i';
		selector: #inspectIt;
		help: nil;
		iconName: #smallInspectIt
]

{ #category : 'accessing' }
PSLessonView >> bindings [

	"dynamic variable binding not needed for Lessons"

	^ Dictionary new
]

{ #category : 'gui' }
PSLessonView >> buildText [
	| scrolledText |
	scrolledText := self sourceTextModel newScrolledText
		beForSmalltalkScripting;
		beWrapped;
		yourself.
	scrolledText textArea font: StandardFonts codeFont.
	^ scrolledText
]

{ #category : 'gui' }
PSLessonView >> buildWindow [
	^ SystemWindow labelled: 'PrStef lesson'
]

{ #category : 'gui' }
PSLessonView >> close [
	window delete
]

{ #category : 'accessing' }
PSLessonView >> doItContext [
	^ nil
]

{ #category : 'accessing' }
PSLessonView >> doItReceiver [
	^ nil
]

{ #category : 'testing' }
PSLessonView >> hasBindingOf: aString [

 	^ self bindings includesKey: aString
]

{ #category : 'initialization' }
PSLessonView >> initialize [

	super initialize.
	window := self buildWindow.
	shoutMorph := self buildText.
	window addMorph: shoutMorph frame: (0 @ 0 corner: 1 @ 1).
	window extent: 600 @ 450
]

{ #category : 'testing' }
PSLessonView >> isOpenInWindow [
	^ self currentWorld systemWindows includes: window
]

{ #category : 'testing' }
PSLessonView >> isScripting [
 ^ true
]

{ #category : 'gui' }
PSLessonView >> menu [
	^ (PragmaMenuBuilder pragmaKeyword: #LessonViewContextMenu model: self) menu
]

{ #category : 'gui' }
PSLessonView >> open [
	"menu: #shoutMorphFillMenu:."
	window openInWorld
]

{ #category : 'accessing' }
PSLessonView >> selectedClassOrMetaClass [
	^ nil
]

{ #category : 'accessing' }
PSLessonView >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	^ true
]

{ #category : 'accessing' }
PSLessonView >> shoutMorph [
	^ shoutMorph
]

{ #category : 'gui' }
PSLessonView >> shoutMorphFillMenu: aMenu [
	^ aMenu addAllFrom: self menu
]

{ #category : 'gui' }
PSLessonView >> showLesson: aLesson withTitle: aString [
	self window setLabel: aString.
	self sourceTextModel setText: aLesson lesson.
	self isOpenInWindow ifFalse: [ self open ]
]

{ #category : 'accessing' }
PSLessonView >> sourceTextModel [
	^ sourceTextModel ifNil: [ sourceTextModel := RubScrolledTextModel new interactionModel: self ]
]

{ #category : 'accessing' }
PSLessonView >> text [
	^ self sourceTextModel getText asString
]

{ #category : 'accessing' }
PSLessonView >> window [
	^ window
]
