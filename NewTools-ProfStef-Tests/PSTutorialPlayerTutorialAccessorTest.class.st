"
SUnit tests for tutorial player
"
Class {
	#name : 'PSTutorialPlayerTutorialAccessorTest',
	#superclass : 'TestCase',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'tests' }
PSTutorialPlayerTutorialAccessorTest >> testDefaultsToSmalltalkSyntaxTutorial [
	| player |
	player := TutorialPlayer new.
	self assert: (player tutorial isKindOf: PharoSyntaxTutorial)
]

{ #category : 'tests' }
PSTutorialPlayerTutorialAccessorTest >> testWithMockTutorial [
	| mockTutorial player |
	mockTutorial := PSMockTutorial new.
	player := TutorialPlayer new tutorial: mockTutorial; yourself.
	self assert: player tutorial equals: mockTutorial
]
