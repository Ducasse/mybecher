"
SUnit tests for PharoSyntaxTutorial
"
Class {
	#name : 'PSPharoSyntaxTutorialTest',
	#superclass : 'PSTutorialTest',
	#category : 'NewTools-ProfStef-Tests',
	#package : 'NewTools-ProfStef-Tests'
}

{ #category : 'requirements' }
PSPharoSyntaxTutorialTest >> testedTutorial [
	"Returns an instance of an AbstractTutorial subclass"
	^ PharoSyntaxTutorial new
]
