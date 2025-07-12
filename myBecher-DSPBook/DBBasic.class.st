"
A stupid mean and standard deviation computation.
"
Class {
	#name : 'DBBasic',
	#superclass : 'Object',
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'as yet unclassified' }
DBBasic >> meanOf: aCollection [ 
	
	| sum n |
	sum := 0.
	n := 0.
	aCollection do: [ :each | sum := sum + each. n := n + 1 ].
	^ sum / n
	
]

{ #category : 'as yet unclassified' }
DBBasic >> standardDeviationOf: aCollection [ 
	"a naive version performing two passes while one is enough."
	
	| variance mean n |
	variance := 0.
	n := 0.
	mean := self meanOf: aCollection.
	aCollection do: [ :each | 
		variance := variance + ((each - mean) squared). 
		n :=n + 1 ].
	^ (variance / (n - 1)) sqrt
	
]
