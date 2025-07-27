Class {
	#name : 'NFFT',
	#superclass : 'Object',
	#instVars : [
		'permTable',
		'sampleNumber'
	],
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'as yet unclassified' }
NFFT >> computePermTableOfSize [
	
	permTable := Array new: sampleNumber * 2.
	permTable at: 1 put: 1.
	permTable at: 2 put: 1.
	permTable at: sampleNumber * 2 -1 put: sampleNumber. 
	permTable at: sampleNumber * 2 put: sampleNumber. 
	
	2 to: sampleNumber - 1 do: [ :i | 
		permTable at: (i * 2) -1 put: i.
		permTable at: i * 2  put: (self reverseBit: i  ofSize: (sampleNumber log:2) asInteger).
		]
]

{ #category : 'as yet unclassified' }
NFFT >> computePermTableOfSize: size [
	
	permTable := Array new: size * 2. 
	1 to: size do: [ :i | 
		permTable at: i put: i.
		permTable at: i + 1 put: (self reverseBit: i ofSize: sampleNumber) ]
]

{ #category : 'as yet unclassified' }
NFFT >> permutationTable [

	^ permTable
]

{ #category : 'reverse bit' }
NFFT >> reverseBit: n ofSize: s [
	
	| nn copy lsb |
	nn := n.
	copy := n.
	
	s - 1 timesRepeat: [ 
		nn := nn >> 1.
		lsb := nn bitAnd: 1. 	
	
		copy := copy << 1. 
		copy := copy bitOr: lsb.
	].
	
	^ copy bitAnd: (1 << s -1).

]

{ #category : 'accessing' }
NFFT >> sampleNumber: anInteger [ 
	sampleNumber := anInteger
]
