Class {
	#name : 'CavroisWindowManagerTest',
	#superclass : 'TestCase',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'tests' }
CavroisWindowManagerTest >> testConfigurationFromSpWindow [

	| prof configuration play |
	prof := CavroisWindowManager new.
	play := StPlaygroundPresenter new open.
	configuration := prof placeHolderFromSpWindow: play window.
	self assert:  configuration  extent equals: (700.0@500.0).
	self assert:  configuration  kind equals: #Playground.
	play delete
	
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testConfigurationFromSystemWindow [

	| prof configuration transcript |
	prof := CavroisWindowManager new.
	transcript := Transcript open
							extent: (447.0@300.0) ; 
							bounds: ((699.0@460.0) corner: (1146.0@760.0)); 
					 		yourself.
	configuration := prof placeHolderFromSystemWindow: transcript.
	self assert:  configuration  extent  equals:(447.0@300.0).
	self assert:  configuration  position equals: (699.0@460.0).
	self assert:  configuration  kind equals: #Transcript.
	transcript delete
	
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testMappingClassToKind [

	| prof |
	prof := CavroisWindowManager new.
	self assert: (prof kindFor: 'ThreadSafeTranscript') equals: #Transcript
]

{ #category : 'tests' }
CavroisWindowManagerTest >> testPresenterHasCorrectAPI [

	| pres win |
	pres := SpPresenter new.
	pres layout: SpBoxLayout new. 
	pres position:  100@100.
	pres extent: 200@333.
	
	self assert: pres initialPosition equals: 100@100.
	self assert: pres extent equals: 200@333.
	"this test is key because else we cannot pass to the window 
	the size and position we want. "
	
	win := pres open.
	self assert: win extent equals: 200@333.
	self assert: win bounds origin equals: 100@100.
	"here we see that the size and position are not honored"
]
