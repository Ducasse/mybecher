"
I'm a Pharo tutorial which teach to create a Pharo tutorial. Open me with

ProfStef goOn: HowToMakeYourOwnTutorial.
"
Class {
	#name : 'PSHowToMakeYourOwnTutorial',
	#superclass : 'PSAbstractTutorial',
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'lessons' }
PSHowToMakeYourOwnTutorial >> createLessonFactoryMethods [
	^ PSLesson
title: 'Lesson factory methods'
lesson:
'"Next, create category ''lessons'' and add a method per lesson.

Each method must return a Lesson object.

Your can use Lesson class>>title:lesson: to create Lesson object."

HowToDebug compile:
''useSelfHalt
	^ Lesson
title: ''''self halt''''
lesson:
''''"Put self halt. in the method you want to debug."

ProfStef next.''''''
classified: ''lessons''.

HowToDebug compile:
''examineStackTrace
	^ Lesson
title: ''''self halt''''
lesson:
''''"Look at PharoDebug.log."

ProfStef next.''''''
classified: ''lessons''.

HowToDebug compile:
''changeReturnValue
	^ Lesson
title: ''''Change return value''''
lesson:
''''"Easy in the debugger !"''''''
classified: ''lessons''.

ProfStef next.'
]

{ #category : 'lessons' }
PSHowToMakeYourOwnTutorial >> implementTutorial [
	^ PSLesson
title: 'Implement tutorial method'
lesson:
'"Finally implement the tutorial method to return an Array of your lesson factory methods:"

HowToDebug compile:
''tutorial
	^ #(
#useSelfHalt
#examineStackTrace
#changeReturnValue
)''
classified: ''tutorial''.


ProfStef next.'
]

{ #category : 'lessons' }
PSHowToMakeYourOwnTutorial >> runYourTutorial [
	^ PSLesson
title: 'Run your tutorial'
lesson:
'"You can run your fresh new tutorial like this:"

ProfStef goOn: HowToDebug.'
]

{ #category : 'lessons' }
PSHowToMakeYourOwnTutorial >> subclassAbstractTutorial [
	^ PSLesson
title: 'AbstractTutorial'
lesson:
'"Here are the steps to create your own Pharo tutorial.

First, create a subclass of AbstractTutorial. For example:"

AbstractTutorial subclass: #HowToDebug
	instanceVariableNames: ''''
	classVariableNames: ''''
	poolDictionaries: ''''
	category: ''YourTutorial''.

ProfStef next.'
]

{ #category : 'tutorial' }
PSHowToMakeYourOwnTutorial >> tutorial [
	^ #(
		subclassAbstractTutorial
		createLessonFactoryMethods
		implementTutorial
		runYourTutorial
		)
]
