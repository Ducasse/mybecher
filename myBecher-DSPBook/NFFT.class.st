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

	| bitSize |	
	permTable := Array new: sampleNumber * 2.
	bitSize := (sampleNumber log: 2) asInteger.
	1 to: sampleNumber do: [ :i | 
		permTable at: (i * 2) -1  put: i.
		permTable at: (i * 2) put: (self reverseBit: i - 1 ofSize: bitSize) + 1.
		]
]

{ #category : 'as yet unclassified' }
NFFT >> permutationTable [

	^ permTable
]

{ #category : 'reverse bit' }
NFFT >> reverseBit: n ofSize: s [
	"Return the bit reversed of the argument masked to s bits
	e.g. 2r1000 -> 2r0001
	
	
	"
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
