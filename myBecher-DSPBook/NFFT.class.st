Class {
	#name : 'NFFT',
	#superclass : 'Object',
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'as yet unclassified' }
NFFT >> reverseBit: n [
	
	| nn copy lsb |
	nn := n.
	copy := n.
	
	2 timesRepeat: [ 
		nn := nn >> 1.
		lsb := nn bitAnd: 1. 	
	
		copy := copy << 1. 
		copy := copy bitOr: lsb.
	].
	
	^ copy bitAnd: 2r111.

]
