Class {
	#name : 'WindowProfilorTest',
	#superclass : 'TestCase',
	#category : 'myBecher-WindowProfile',
	#package : 'myBecher-WindowProfile'
}

{ #category : 'tests' }
WindowProfilorTest >> testProfileFromSystemWindow [

	| prof configuration |
	prof := WindowProfilor new.
	configuration := prof configurationFromSystemWindow: ( Transcript open extent: 400@666; yourself ).
	self assert:  configuration  extent equals: 400@666.
]
