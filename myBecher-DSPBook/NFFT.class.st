Class {
	#name : 'NFFT',
	#superclass : 'Object',
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

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
