"
`ProfStef` is interacting with a tutorial player (which encapsulates the logic of navigating within lessons) and lessonView (a dead simple little UI).
`ProfStef` is the Pharo teacher. 

To start the tutorial, evaluate:

```
ProfStef go.
```

To go to the next lesson evaluate:

```
ProfStef next.
```

To execute your own tutorial:

```
ProfStef goOn: MyOwnTutorial
```

`MyOwnTutorial` should be a subclass of `AbstractTutorial`.

To see a table of contents with all defined tutorials:


```
ProfStef contents
```

returns 

```
'How To Make Your Own Tutorial
	ProfStef goOn: HowToMakeYourOwnTutorial

Pharo Syntax Tutorial
	ProfStef goOn: PharoSyntaxTutorial
'
```




"
Class {
	#name : 'PSProfStef',
	#superclass : 'Model',
	#instVars : [
		'lessonView',
		'player'
	],
	#classVars : [
		'Instance'
	],
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'zen' }
PSProfStef class >> aboutPharoZen [
	^ 'These are the Pharo Zen values.\\See:\\  ProfStef class>>#pharoZenValues\\Inspect:\\  PharoTutorial pharoZenValues' withCRs
]

{ #category : 'cleanup' }
PSProfStef class >> cleanUp [

	self reset
]

{ #category : 'accessing' }
PSProfStef class >> contents [
	"Build table of contents with all defined tutorials."

	^ PSAbstractTutorial contentsOfTutorials
]

{ #category : 'class initialization' }
PSProfStef class >> default [

	^ Instance ifNil: [ Instance := self new ]
]

{ #category : 'navigating' }
PSProfStef class >> first [

	^ self default first
]

{ #category : 'navigating' }
PSProfStef class >> go [

	^ self default go
]

{ #category : 'navigating' }
PSProfStef class >> goOn: aTutorialClass [

	^ self default goOn: aTutorialClass
]

{ #category : 'navigating' }
PSProfStef class >> last [

	^ self default last
]

{ #category : 'world menu' }
PSProfStef class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'Pharo Zen')
		parent: #PharoHelp;
		order: 3;
		action: [ self openPharoZenWorkspace ];
		iconName: #smallPharo;
		help: 'Pharo values.'
]

{ #category : 'navigating' }
PSProfStef class >> next [

	^ self default next
]

{ #category : 'zen' }
PSProfStef class >> openPharoZenWorkspace [
    "Open a Workspace showing the Pharo Zen values in random order"

    <script>
    | presenter |
    presenter := SpTextPresenter new
        text: self pharoZenValuesContents;
        open.

    presenter
        withWindowDo: [ :w |
            w
                title: 'Pharo Zen' translated;
                aboutText: self aboutPharoZen ]
]

{ #category : 'zen' }
PSProfStef class >> pharoZenValues [
	"Our values and convictions are condensed in this simple list."

	^ #(
		'Easy to understand, easy to learn from, easy to change.'
		'Objects all the way down.'
		'Examples to learn from.'
		'Fully dynamic and malleable.'
		'Beauty in the code, beauty in the comments.'
		'Simplicity is the ultimate elegance.'
		'Better a set of small polymorphic classes than a large ugly one.'
		'Classes structure our vocabulary.'
		'Messages are our vocabulary.'
		'Polymorphism is our esperanto.'
		'Abstraction and composition are our friends.'
		'Tests are important but can be changed.'
		'Explicit is better than implicit.'
		'Magic only at the right place.'
		'One step at a time.'
		'There is no unimportant fix.'
		'Learning from mistakes.'
		'Perfection can kill movement.'
		'Quality is an emerging property.'
		'Simple processes to support progress.'
		'Communication is key.'
		'A system with robust abstractions that a single person can understand.' )
]

{ #category : 'zen' }
PSProfStef class >> pharoZenValuesContents [
	"Return a string with CRs listing the Pharo Zen values in random order"

	^ String streamContents: [ :stream |
			stream << (self class >> #pharoZenValues) comment withoutQuoting; cr; cr.
			self pharoZenValues shuffled
				do: [ :each | stream << each ]
				separatedBy: [ stream cr ]]
]

{ #category : 'navigating' }
PSProfStef class >> previous [

	^ self default previous
]

{ #category : 'class initialization' }
PSProfStef class >> reset [
	<script>

	Instance := nil
]

{ #category : 'starting' }
PSProfStef class >> tutorial: aTutorialClass lesson: aSelector [

	self default tutorial: aTutorialClass lesson: aSelector
]

{ #category : 'starting' }
PSProfStef class >> tutorial: aTutorialClass lessonAt: lessonIndex [

	self default tutorial: aTutorialClass lessonAt: lessonIndex
]

{ #category : 'gui' }
PSProfStef >> close [

	self lessonView close
]

{ #category : 'navigating' }
PSProfStef >> first [

	self player first.
	^ self showCurrentLesson
]

{ #category : 'navigating' }
PSProfStef >> go [

	^ self goOn: PSPharoSyntaxTutorial
]

{ #category : 'navigating' }
PSProfStef >> goOn: aTutorialClass [

	self player tutorial: aTutorialClass new.
	^ self open
]

{ #category : 'navigating' }
PSProfStef >> last [

	self player last.
	^ self showCurrentLesson
]

{ #category : 'accessing' }
PSProfStef >> lessonView [

	^ lessonView
			ifNil: [ lessonView := PSLessonView new ]
]

{ #category : 'accessing' }
PSProfStef >> lessonView: aLessonView [

	lessonView := aLessonView
]

{ #category : 'navigating' }
PSProfStef >> next [

	self lessonView isOpenInWindow
		ifTrue: [
			self player next.
			self showCurrentLesson ]
]

{ #category : 'instance creation' }
PSProfStef >> open [

	self player first.
	^ self showCurrentLesson
]

{ #category : 'accessing' }
PSProfStef >> player [

	^ player ifNil: [ player := PSTutorialPlayer new ]
]

{ #category : 'accessing' }
PSProfStef >> player: aTutorialPlayer [

	player := aTutorialPlayer
]

{ #category : 'navigating' }
PSProfStef >> previous [

	self lessonView isOpenInWindow
		ifTrue: [
			self player previous.
			self showCurrentLesson ]
]

{ #category : 'gui' }
PSProfStef >> showCurrentLesson [

	| progressInfo lesson |
	lesson := self player currentLesson.
	progressInfo := '(', self tutorialPositionString, '/', self tutorialSizeString, ')'.
	^ self lessonView
		showLesson: lesson
		withTitle: lesson title, ' ', progressInfo
]

{ #category : 'navigating' }
PSProfStef >> tutorial: aTutorialClass lesson: aSelector [

	| tutorial |
	tutorial := aTutorialClass new.
	self player tutorial: tutorial.
	self tutorial: aTutorialClass lessonAt: (tutorial indexOfLesson: aSelector)
]

{ #category : 'accessing' }
PSProfStef >> tutorial: aTutorialClass lessonAt: lessonIndex [

	self player tutorial: aTutorialClass new.
	self player tutorialPosition: lessonIndex.
	self showCurrentLesson
]

{ #category : 'accessing' }
PSProfStef >> tutorialPositionString [

	^ player tutorialPosition asString
]

{ #category : 'accessing' }
PSProfStef >> tutorialSizeString [

	^ self player size asString
]
