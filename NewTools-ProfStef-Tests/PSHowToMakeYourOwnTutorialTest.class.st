"
Tests for HowToMakeYourOwnTutorial
"
Class {
	#name : 'PSHowToMakeYourOwnTutorialTest',
	#superclass : 'PSTutorialTest',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'tests' }
PSHowToMakeYourOwnTutorialTest >> testedTutorial [
	"Returns an instance of an AbstractTutorial subclass"
	^ HowToMakeYourOwnTutorial new
]
