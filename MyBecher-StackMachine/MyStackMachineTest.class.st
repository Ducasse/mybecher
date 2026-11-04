"
I test `MyStackMachine`, `MySMParser` and `MySMInstruction`: each instruction, error cases, and the programs of the exercise sheet (levels 1 to 3).
"
Class {
	#name : 'MyStackMachineTest',
	#superclass : 'TestCase',
	#category : 'MyBecher-StackMachine-Tests',
	#package : 'MyBecher-StackMachine',
	#tag : 'Tests'
}

{ #category : 'helpers' }
MyStackMachineTest >> execute: aSource [

	^ self execute: aSource stack: #(  ) variables: Dictionary new
]

{ #category : 'helpers' }
MyStackMachineTest >> execute: aSource stack: anArray [

	^ self execute: aSource stack: anArray variables: Dictionary new
]

{ #category : 'helpers' }
MyStackMachineTest >> execute: aSource stack: anArray variables: aDictionary [
	"Run aSource from the initial stack anArray and answer the final stack as an Array (top last)."

	^ (MyStackMachine runSource: aSource stack: anArray variables: aDictionary) asArray
]

{ #category : 'helpers' }
MyStackMachineTest >> execute: aSource variables: aDictionary [

	^ self execute: aSource stack: #(  ) variables: aDictionary
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testAddWithOneElementRaisesError [
	self should: [ self execute: 'ADD' stack: #( 1 ) ] raise: MySMError
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testArithmetic [
	"The top of the stack is the right operand: [10, 3] SUB gives [7]."

	self assert: (self execute: 'ADD' stack: #( 5 10 3 )) equals: #( 5 13 ).
	self assert: (self execute: 'SUB' stack: #( 10 3 )) equals: #( 7 ).
	self assert: (self execute: 'SUB' stack: #( 3 10 )) equals: #( -7 ).
	self assert: (self execute: 'MUL' stack: #( 6 7 )) equals: #( 42 ).
	self assert: (self execute: 'MOD' stack: #( 10 3 )) equals: #( 1 ).
	self assert: (self execute: 'MOD' stack: #( 3 10 )) equals: #( 3 )
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testComparisons [

	self assert: (self execute: 'EQ' stack: #( 4 4 )) equals: #( 1 ).
	self assert: (self execute: 'EQ' stack: #( 4 5 )) equals: #( 0 ).
	self assert: (self execute: 'LT' stack: #( 2 5 )) equals: #( 1 ).
	self assert: (self execute: 'LT' stack: #( 5 2 )) equals: #( 0 ).
	self assert: (self execute: 'LT' stack: #( 5 5 )) equals: #( 0 )
]

{ #category : 'tests - direct manipulation errors' }
MyStackMachineTest >> testDirectAddWithOneElementRaisesError [

	self
		should: [
				MyStackMachine new
					push: 1;
					add ]
		raise: MySMError
]

{ #category : 'tests - direct manipulation' }
MyStackMachineTest >> testDirectArithmeticAndComparisons [
	"Same operand order as the instructions: the top is the right operand."

	self
		assert: (MyStackMachine new
				 push: 10;
				 push: 3;
				 sub;
				 top)
		equals: 7.
	self
		assert: (MyStackMachine new
				 push: 10;
				 push: 3;
				 add;
				 top)
		equals: 13.
	self
		assert: (MyStackMachine new
				 push: 6;
				 push: 7;
				 mul;
				 top)
		equals: 42.
	self
		assert: (MyStackMachine new
				 push: 10;
				 push: 3;
				 mod;
				 top)
		equals: 1.
	self
		assert: (MyStackMachine new
				 push: 4;
				 push: 4;
				 eq;
				 top)
		equals: 1.
	self
		assert: (MyStackMachine new
				 push: 5;
				 push: 2;
				 lt;
				 top)
		equals: 0.
	self
		assert: (MyStackMachine new
				 push: 2;
				 push: 5;
				 lt;
				 stack) asArray
		equals: #( 1 )
]

{ #category : 'tests - direct manipulation errors' }
MyStackMachineTest >> testDirectJumpToUnknownLabelRaisesError [

	| machine |
	machine := MyStackMachine new.
	machine source: 'LABEL end'.
	self should: [ machine jump: #nowhere ] raise: MySMError
]

{ #category : 'tests - direct manipulation' }
MyStackMachineTest >> testDirectJumps [
	"jump: and jumpIfZero: move the pc to the LABEL instruction inside the loaded program."

	| machine |
	machine := MyStackMachine new.
	machine source: 'PUSH 1
LABEL middle
PUSH 2
LABEL end'.
	machine jump: #end.
	self assert: machine pc equals: 4.
	machine
		push: 7;
		jumpIfZero: #middle.
	self assert: machine pc equals: 4.
	self assert: machine stack isEmpty.
	machine
		push: 0;
		jumpIfZero: #middle.
	self assert: machine pc equals: 2.
	self assert: machine stack isEmpty.
	machine run.
	self assert: machine stack asArray equals: #( 2 )
]

{ #category : 'tests - direct manipulation errors' }
MyStackMachineTest >> testDirectPopOnEmptyStackRaisesError [

	self should: [ MyStackMachine new pop ] raise: MySMError
]

{ #category : 'tests - direct manipulation errors' }
MyStackMachineTest >> testDirectPushUnknownVariableRaisesError [

	self should: [ MyStackMachine new push: #unknown ] raise: MySMError
]

{ #category : 'tests - direct manipulation' }
MyStackMachineTest >> testDirectPushVariable [

	| machine |
	machine := MyStackMachine new.
	machine variableAt: #x put: 5.
	machine push: #x.
	self assert: machine stack asArray equals: #( 5 )
]

{ #category : 'tests - direct manipulation' }
MyStackMachineTest >> testDirectStackManipulation [

	| machine |
	machine := MyStackMachine new.
	machine
		push: 1;
		push: 2;
		dup.
	self assert: machine stack asArray equals: #( 1 2 2 ).
	machine pop.
	self assert: machine stack asArray equals: #( 1 2 ).
	machine swap.
	self assert: machine stack asArray equals: #( 2 1 ).
	self assert: machine top equals: 1
]

{ #category : 'tests - direct manipulation errors' }
MyStackMachineTest >> testDirectTopOnEmptyStackRaisesError [

	self should: [ MyStackMachine new top ] raise: MySMError
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testDuplicatedLabelRaisesError [
	self should: [ self execute: 'LABEL a
LABEL a' ] raise: MySMError
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testInfiniteLoopRaisesError [

	| machine |
	machine := MyStackMachine new.
	machine stepLimit: 1000.
	machine source: 'LABEL loop
JUMP loop'.
	self should: [ machine run ] raise: MySMError
]

{ #category : 'tests - inspector' }
MyStackMachineTest >> testInspectionStackShowsTopFirst [

	| machine builder table |
	machine := MyStackMachine new.
	machine stack: #( 10 20 30 ).
	builder := SpPresenterBuilder new
		           application: SpApplication new;
		           yourself.
	table := machine inspectionStack: builder.
	self assert: table items asArray equals: #( 30 20 10 ).
	self assert: (table columns collect: [ :each | each title ]) asArray equals: #( 'Depth' 'Value' ).
	self assert: (MyStackMachine >> #inspectionStack: hasPragmaNamed: #inspectorPresentationOrder:title:)
]

{ #category : 'tests - parser' }
MyStackMachineTest >> testInstructionPrintString [

	self assert: (MySMInstruction opcode: #PUSH argument: 42) printString equals: 'PUSH 42'.
	self assert: (MySMInstruction opcode: #ADD) printString equals: 'ADD'
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testJumpIfZero [
	"The tested value is always popped, whether the jump is taken or not."

	| source |
	source := 'JUMP_IF_ZERO end
PUSH 99
LABEL end'.
	self assert: (self execute: source stack: #( 7 0 )) equals: #( 7 ).
	self assert: (self execute: source stack: #( 7 5 )) equals: #( 7 99 )
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testJumpToUnknownLabelRaisesError [
	self should: [ self execute: 'JUMP nowhere' ] raise: MySMError
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testJumps [

	self assert: (self execute: 'LABEL here' stack: #( 1 2 )) equals: #( 1 2 ).
	self
		assert: (self execute: 'JUMP end
PUSH 99
LABEL end
PUSH 1')
		equals: #( 1 ).
	"Backward and forward jumps."
	self
		assert: (self execute: 'JUMP second
LABEL first
PUSH 2
JUMP end
LABEL second
PUSH 1
JUMP first
LABEL end')
		equals: #( 1 2 )
]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel1Expressions [
	"(a+b)*(c-2) and x^2+x"

	| source |
	source := 'PUSH a
PUSH b
ADD
PUSH c
PUSH 2
SUB
MUL'.
	self
		assert: (self execute: source variables: {
					 (#a -> 3).
					 (#b -> 4).
					 (#c -> 7) } asDictionary)
		equals: #( 35 ).
	self
		assert: (self execute: source variables: {
					 (#a -> 1).
					 (#b -> 1).
					 (#c -> 0) } asDictionary)
		equals: #( -4 ).
	self
		assert: (self
				 execute: 'PUSH x
DUP
MUL
PUSH x
ADD'
				 variables: { (#x -> 5) } asDictionary)
		equals: #( 30 )
]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel2AbsoluteValue [

	| source |
	source := 'PUSH x
DUP
PUSH 0
LT
JUMP_IF_ZERO end
PUSH 0
SWAP
SUB
LABEL end'.
	self assert: (self execute: source variables: { (#x -> -5) } asDictionary) equals: 5.
	self assert: (self execute: source variables: { (#x -> 5) } asDictionary) equals: 5.
	self assert: (self execute: source variables: { (#x -> 0) } asDictionary) equals: 0.
	

]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel2Max [

	| source |
	source := 'PUSH a
PUSH b
LT
JUMP_IF_ZERO aIsMax
PUSH b
JUMP end
LABEL aIsMax
PUSH a
LABEL end'.
	self
		assert: (self execute: source variables: {
					 (#a -> 3).
					 (#b -> 8) } asDictionary)
		equals: #( 8 ).
	self
		assert: (self execute: source variables: {
					 (#a -> 9).
					 (#b -> 2) } asDictionary)
		equals: #( 9 )
]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel3CountDown [

	self assert: (self execute: MyStackMachine countDownSource variables: { (#N -> 4) } asDictionary) equals: #( 4 3 2 1 )
]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel3Factorial [

	| source |
	source := MyStackMachine factorialSource.
	self assert: (self execute: source variables: { (#N -> 5) } asDictionary) equals: #( 120 ).
	self assert: (self execute: source variables: { (#N -> 1) } asDictionary) equals: #( 1 )
]

{ #category : 'tests - exercises' }
MyStackMachineTest >> testLevel3SumToN [

	| source |
	source := MyStackMachine sumToNSource.
	self assert: (self execute: source variables: { (#N -> 4) } asDictionary) equals: #( 10 ).
	self assert: (self execute: source variables: { (#N -> 1) } asDictionary) equals: #( 1 ).
	self assert: (self execute: source variables: { (#N -> 100) } asDictionary) equals: #( 5050 )
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testModByZeroRaisesError [
	self should: [ self execute: 'MOD' stack: #( 3 0 ) ] raise: MySMError
]

{ #category : 'tests - parser' }
MyStackMachineTest >> testParseInstructions [

	| instructions |
	instructions := MySMParser parse: 'PUSH 3
  push -4
PUSH x
add

LABEL loop
JUMP_IF_ZERO loop'.
	self assert: instructions size equals: 6.
	self assert: instructions first opcode equals: #PUSH.
	self assert: instructions first argument equals: 3.
	self assert: instructions second argument equals: -4.
	self assert: instructions third argument equals: #x.
	self assert: instructions fourth opcode equals: #ADD.
	self assert: instructions fourth argument isNil.
	self assert: instructions fifth isLabel.
	self assert: instructions fifth argument equals: #loop.
	self assert: instructions last opcode equals: #JUMP_IF_ZERO
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testParseJumpWithoutArgumentRaisesError [
	self should: [ MySMParser parse: 'JUMP' ] raise: MySMError
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testParsePushWithoutArgumentRaisesError [
	self should: [ MySMParser parse: 'PUSH' ] raise: MySMError
]

{ #category : 'tests - parser' }
MyStackMachineTest >> testParseSkipsComments [

	| instructions |
	instructions := MySMParser parse: '; a whole comment line
# another one
PUSH 1 ; push one
POP # drop it'.
	self assert: (instructions collect: [ :each | each opcode ]) asArray equals: #( #PUSH #POP )
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testParseUnexpectedArgumentRaisesError [

	self should: [ MySMParser parse: 'ADD 3' ] raise: MySMError
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testParseUnknownInstructionRaisesError [

	self
		should: [
				MySMParser parse: 'PUSH 1
FOO' ]
		raise: MySMError
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testPopOnEmptyStackRaisesError [
	self should: [ self execute: 'POP' ] raise: MySMError
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testPush [

	self
		assert: (self execute: 'PUSH 1
PUSH 2')
		equals: #( 1 2 ).
	self assert: (self execute: 'PUSH x' variables: { (#x -> 7) } asDictionary) equals: #( 7 )
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testPushUnknownVariableRaisesError [

	self should: [ self execute: 'PUSH y' ] raise: MySMError
]

{ #category : 'tests - stepping' }
MyStackMachineTest >> testRunDoesNotChangeInitialArray [

	| initial |
	initial := #( 10 3 ) copy.
	self execute: 'SUB' stack: initial.
	self assert: initial equals: #( 10 3 )
]

{ #category : 'tests - instructions' }
MyStackMachineTest >> testStackManipulation [

	self assert: (self execute: 'POP' stack: #( 1 2 )) equals: #( 1 ).
	self assert: (self execute: 'DUP' stack: #( 1 2 )) equals: #( 1 2 2 ).
	self assert: (self execute: 'SWAP' stack: #( 1 2 3 )) equals: #( 1 3 2 )
]

{ #category : 'tests - stepping' }
MyStackMachineTest >> testStepByStep [

	| machine |
	machine := MyStackMachine new.
	machine source: 'PUSH 1
PUSH 2
ADD'.
	self deny: machine isFinished.
	machine step.
	self assert: machine stack asArray equals: #( 1 ).
	self assert: machine pc equals: 2.
	machine
		step;
		step.
	self assert: machine stack asArray equals: #( 3 ).
	self assert: machine isFinished
]

{ #category : 'tests - errors' }
MyStackMachineTest >> testSwapWithOneElementRaisesError [
	self should: [ self execute: 'SWAP' stack: #( 1 ) ] raise: MySMError
]
