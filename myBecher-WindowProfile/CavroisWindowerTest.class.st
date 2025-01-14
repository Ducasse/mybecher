Class {
	#name : 'CavroisWindowerTest',
	#superclass : 'TestCase',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'tests' }
CavroisWindowerTest >> testConfigurationFromSpWindow [

	| prof configuration play |
	prof := CavroisWindower new.
	play := StPlaygroundPresenter new open.
	configuration := prof placeHolderFromSpWindow: play window.
	self assert:  configuration  extent equals: (700.0@500.0).
	self assert:  configuration  kind equals: #Playground.
	play delete
	
]

{ #category : 'tests' }
CavroisWindowerTest >> testConfigurationFromSystemWindow [

	| prof configuration transcript |
	prof := CavroisWindower new.
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
CavroisWindowerTest >> testMappingClassToKind [

	| prof |
	prof := CavroisWindower new.
	self assert: (prof mapFor: 'ThreadSafeTranscript') equals: #Transcript
]
