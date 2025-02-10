"
SUnit tests for AbstractTutorial
"
Class {
	#name : 'PSAbstractTutorialTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'tests' }
PSAbstractTutorialTest >> testLessonsReturnsAllLessonInstances [
	| lessons |
	lessons := PSMockTutorial new lessons.
	self assert: 3 equals:lessons size.
	self assert: 'first' equals: lessons first title.
	self assert: 'second' equals: (lessons at:2 ) title.
	self assert: 'third' equals: lessons last title
]

{ #category : 'tests' }
PSAbstractTutorialTest >> testTitleHumanizeClassName [
	self assert: 'How To Make Your Own Tutorial' equals: HowToMakeYourOwnTutorial title.
	self assert: 'Pharo Syntax Tutorial' equals: PharoSyntaxTutorial title
]

{ #category : 'tests' }
PSAbstractTutorialTest >> testTutorialRaisesShouldBeImplemented [
	| tutorial |
	tutorial := AbstractTutorial new.
	self
		should: [tutorial tutorial]
		raise: Error
		withExceptionDo: [:anException |
			self
				assert:  ShouldBeImplemented
				equals: anException class
		]
]

{ #category : 'tests' }
PSAbstractTutorialTest >> testTutorialsReturnsAllButMockTutorial [
	| tutorials |
	tutorials := AbstractTutorial tutorials.
	self assert: (tutorials includes: PharoSyntaxTutorial).
	self assert: (tutorials includes: HowToMakeYourOwnTutorial).
	self deny: (tutorials includes: PSMockTutorial)
]
