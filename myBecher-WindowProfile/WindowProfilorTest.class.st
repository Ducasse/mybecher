Class {
	#name : 'WindowProfilorTest',
	#superclass : 'TestCase',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'tests' }
WindowProfilorTest >> testProfileFromSystemWindow [

	| prof configuration transcript |
	prof := WindowProfilor new.
	transcript := Transcript open extent: 400@666; yourself.
	configuration := prof configurationFromSystemWindow: transcript.
	self assert:  configuration  extent equals: 400@666.
	self assert:  configuration  position equals: 180.0@106.0.
	self assert:  configuration  kind equals: #ThreadSafeTranscript.
	transcript delete
	
]
