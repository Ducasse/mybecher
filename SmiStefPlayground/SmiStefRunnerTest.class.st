Class {
	#name : 'SmiStefRunnerTest',
	#superclass : 'TestCase',
	#category : 'SmiStefPlayground',
	#package : 'SmiStefPlayground'
}

{ #category : 'tests' }
SmiStefRunnerTest >> testProgram1 [

	| program |
	program := SmiCodeGenerator aarch64
    assemble: [ :asm |
        asm MoveCq: 42 R: R0.
        asm MoveR: R0 R: R1.
        asm MoveR: R1 R: R2.
        asm RetN: 0
    ].


	
]
