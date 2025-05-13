Class {
	#name : 'CRLFTest',
	#superclass : 'TestCase',
	#category : 'myBecher-CRLFInLiterals',
	#package : 'myBecher-CRLFInLiterals'
}

{ #category : 'tests' }
CRLFTest >> testLiteralStringWithCRLF [
	"the test passes."
	
	 self assert: '
<strong>Bold</strong>' second equals: Character lf.

]

{ #category : 'tests' }
CRLFTest >> testLiteralStringWithCRLF2 [
	"the test passes."
	
	 self assert: '
<strong>Bold</strong>' second equals: Character lf.

]
