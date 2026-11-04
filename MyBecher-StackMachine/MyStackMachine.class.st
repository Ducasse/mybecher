"
I am an interpreter for a small stack machine language: one operand stack, a program counter, read-only variables, and no memory.

## Responsibility:

- I execute instructions (`PUSH POP DUP SWAP ADD SUB MUL MOD EQ LT LABEL JUMP JUMP_IF_ZERO`) on my operand stack.
- I know the program, the program counter, the label positions and the values of read-only variables.
- I can run a whole program or execute it step by step, and I stop runaway loops with a step limit.

## Collaborators: 

- `MySMParser`: turns source text into instructions.
- `MySMInstruction`: the instructions I execute, dispatching on their opcode.
- `MySMError`: signaled on runtime errors (stack underflow, unknown label or variable, modulo by zero...).

## Public API and Key Messages

- `MyStackMachine new` then `stack: #(10 3)`, `variableAt: #x put: 5`, `source: aString` (or `program: instructions`)
- `run` executes until the end and answers the stack (an `OrderedCollection`, top is last).
- `step` executes one instruction; `isFinished` tells whether the program is done.
- `inspect` me: the **Stack** pane (`inspectionStack:`) lists the stack top first, depth 1 being the top.
- Class side: `MyStackMachine runSource: aString` and `runSource:stack:variables:`.
- Direct manipulation, one message per instruction, cascadable: `push:` (integer or variable name), `pop`, `dup`, `swap`, `add`, `sub`, `mul`, `mod`, `eq`, `lt`, `jump:`, `jumpIfZero:`; `top` answers the top without popping.

```
(MyStackMachine new push: 10; push: 3; sub; top)   ""7""
```

The stack is written with its top on the right, as in the exercises. Binary operations pop `b` (the top) then `a` and push `a op b`, so `[10, 3]` followed by `SUB` gives `[7]`. Booleans are `0` and `1`.

```
MyStackMachine
	runSource: 'PUSH x
DUP
MUL
PUSH x
ADD'
	stack: #()
	variables: { #x -> 3 } asDictionary.
""an OrderedCollection(12)""
```

See `MyStackMachine class >> #exampleSumToN` and `MyStackMachine class >> #scriptFactorial`.

## Internal Representation

- `stack`: an `OrderedCollection` of integers, the top is the last element.
- `program`: an Array of `MySMInstruction`.
- `pc`: the index (1-based) of the next instruction to execute.
- `labels`: a Dictionary mapping label names to their instruction index.
- `variables`: a Dictionary mapping variable names (Symbols) to integers.
- `stepCount`, `stepLimit`: guard against infinite loops.

### Implementation Points

- Each opcode `X` is executed by the method `executeX:` (e.g. `executeJUMP_IF_ZERO:`), found by `perform:with:`.
- Labels are resolved once when the program is loaded; duplicated labels are an error.
"
Class {
	#name : 'MyStackMachine',
	#superclass : 'Object',
	#instVars : [
		'stack',
		'program',
		'pc',
		'labels',
		'variables',
		'stepCount',
		'stepLimit'
	],
	#category : 'MyBecher-StackMachine-Core',
	#package : 'MyBecher-StackMachine',
	#tag : 'Core'
}

{ #category : 'sample programs' }
MyStackMachine class >> countDownSource [
	"Push N, N-1, ..., 1 (N >= 1)."

	^ 'PUSH N
LABEL loop
DUP
PUSH 1
SUB
DUP
JUMP_IF_ZERO end
JUMP loop
LABEL end
POP'
]

{ #category : 'examples' }
MyStackMachine class >> exampleSumToN [
	"A machine loaded with the sum 1..N program, N = 10, ready to run or step."

	<sampleInstance>
	^ self new
		  source: self sumToNSource;
		  variableAt: #N put: 10;
		  yourself
]

{ #category : 'sample programs' }
MyStackMachine class >> factorialSource [
	"Leave N! on the stack (N >= 1)."

	^ self foldCountDownWith: 'MUL'
]

{ #category : 'sample programs' }
MyStackMachine class >> foldCountDownWith: anOperation [
	"Answer a program that pushes a 0 marker, then N, ..., 1, then combines them with anOperation until it meets the marker."

	^ 'PUSH 0 ; marker
' , self countDownSource , '
LABEL fold     ; stack: [0, ..., k, acc]
SWAP
DUP
JUMP_IF_ZERO done
' , anOperation , '
JUMP fold
LABEL done     ; stack: [acc, 0]
POP'
]

{ #category : 'running' }
MyStackMachine class >> runSource: aString [

	^ self runSource: aString stack: #(  ) variables: Dictionary new
]

{ #category : 'running' }
MyStackMachine class >> runSource: aString stack: aCollection variables: aDictionary [
	"Run the program aString from the initial stack aCollection (top last) with the read-only variables aDictionary, and answer the final stack."

	^ self new
		  source: aString;
		  stack: aCollection;
		  variables: aDictionary;
		  run
]

{ #category : 'script' }
MyStackMachine class >> scriptFactorial [
	"Trace in the Transcript the execution of 4! step by step: pc, instruction and stack after it."

	<script>
	| machine |
	machine := self new
		           source: self factorialSource;
		           variableAt: #N put: 4;
		           yourself.
	Transcript
		show: 'Computing 4!';
		cr.
	[ machine isFinished ] whileFalse: [
			| instruction |
			instruction := machine program at: machine pc.
			machine step.
			Transcript
				show: instruction printString;
				tab;
				show: machine stack asArray printString;
				cr ].
	Transcript
		show: 'Result: ' , machine stack last printString;
		cr
]

{ #category : 'sample programs' }
MyStackMachine class >> sumToNSource [
	"Leave 1 + 2 + ... + N on the stack (N >= 1)."

	^ self foldCountDownWith: 'ADD'
]

{ #category : 'direct manipulation' }
MyStackMachine >> add [
	"Replace a and b (b on top) by a + b (ADD)."

	self execute: #ADD with: nil
]

{ #category : 'private' }
MyStackMachine >> binary: anInstruction do: aBlock [
	"Pop b (the top) then a, and push the value of aBlock applied to a and b."

	| a b |
	self ensureDepth: 2 for: anInstruction.
	b := stack removeLast.
	a := stack removeLast.
	stack addLast: (aBlock value: a value: b)
]

{ #category : 'direct manipulation' }
MyStackMachine >> dup [
	"Duplicate the top of the stack (DUP)."

	self execute: #DUP with: nil
]

{ #category : 'private' }
MyStackMachine >> ensureDepth: anInteger for: anInstruction [
	"Signal a stack underflow when anInstruction needs more elements than the stack holds."

	stack size < anInteger ifTrue: [
			MySMError signal:
				anInstruction printString , ' needs ' , anInteger printString , ' element(s) but the stack holds ' , stack size printString ]
]

{ #category : 'direct manipulation' }
MyStackMachine >> eq [
	"Replace a and b by 1 if they are equal, 0 otherwise (EQ)."

	self execute: #EQ with: nil
]

{ #category : 'private' }
MyStackMachine >> execute: anOpcode with: anArgument [
	"Execute a single instruction outside of the program, exactly as the program would, and answer the receiver so that sends can be cascaded."

	| instruction |
	instruction := MySMInstruction opcode: anOpcode argument: anArgument.
	self perform: instruction executionSelector with: instruction
]

{ #category : 'executing' }
MyStackMachine >> executeADD: anInstruction [

	self binary: anInstruction do: [ :a :b | a + b ]
]

{ #category : 'executing' }
MyStackMachine >> executeDUP: anInstruction [

	self ensureDepth: 1 for: anInstruction.
	stack addLast: stack last
]

{ #category : 'executing' }
MyStackMachine >> executeEQ: anInstruction [

	self binary: anInstruction do: [ :a :b | (a = b) asBit ]
]

{ #category : 'executing' }
MyStackMachine >> executeJUMP: anInstruction [

	self jumpTo: anInstruction argument
]

{ #category : 'executing' }
MyStackMachine >> executeJUMP_IF_ZERO: anInstruction [

	self ensureDepth: 1 for: anInstruction.
	stack removeLast = 0 ifTrue: [ self jumpTo: anInstruction argument ]
]

{ #category : 'executing' }
MyStackMachine >> executeLABEL: anInstruction [
	"A label only marks a position, resolved when the program is loaded."

	
]

{ #category : 'executing' }
MyStackMachine >> executeLT: anInstruction [

	self binary: anInstruction do: [ :a :b | (a < b) asBit ]
]

{ #category : 'executing' }
MyStackMachine >> executeMOD: anInstruction [

	self binary: anInstruction do: [ :a :b |
			b = 0 ifTrue: [ MySMError signal: 'MOD by zero' ].
			a \\ b ]
]

{ #category : 'executing' }
MyStackMachine >> executeMUL: anInstruction [

	self binary: anInstruction do: [ :a :b | a * b ]
]

{ #category : 'executing' }
MyStackMachine >> executePOP: anInstruction [

	self ensureDepth: 1 for: anInstruction.
	stack removeLast
]

{ #category : 'executing' }
MyStackMachine >> executePUSH: anInstruction [

	| value |
	value := anInstruction argument.
	value isSymbol ifTrue: [
		value := variables at: value ifAbsent: [ MySMError signal: 'Unknown variable ' , anInstruction argument ] ].
	stack addLast: value
]

{ #category : 'executing' }
MyStackMachine >> executeSUB: anInstruction [

	self binary: anInstruction do: [ :a :b | a - b ]
]

{ #category : 'executing' }
MyStackMachine >> executeSWAP: anInstruction [

	self ensureDepth: 2 for: anInstruction.
	stack swap: stack size with: stack size - 1
]

{ #category : 'initialization' }
MyStackMachine >> initialize [

	super initialize.
	program := #(  ).
	labels := Dictionary new.
	variables := Dictionary new.
	stepLimit := 1000000.
	self reset
]

{ #category : 'inspector' }
MyStackMachine >> inspectionStack: aBuilder [
	"Inspector pane listing the operand stack, top first: depth 1 is the top of the stack."

	<inspectorPresentationOrder: 0 title: 'Stack'>
	^ aBuilder newTable
		  addStyle: 'stList';
		  addColumn: (SpIndexTableColumn new
				   title: 'Depth';
				   width: 60;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Value';
				   evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
				   yourself);
		  items: stack reversed;
		  yourself
]

{ #category : 'testing' }
MyStackMachine >> isFinished [

	^ pc > program size
]

{ #category : 'direct manipulation' }
MyStackMachine >> jump: aLabel [
	"Move the pc to aLabel of the loaded program (JUMP)."

	self execute: #JUMP with: aLabel asSymbol
]

{ #category : 'direct manipulation' }
MyStackMachine >> jumpIfZero: aLabel [
	"Pop the top and move the pc to aLabel of the loaded program when it is 0 (JUMP_IF_ZERO)."

	self execute: #JUMP_IF_ZERO with: aLabel asSymbol
]

{ #category : 'private' }
MyStackMachine >> jumpTo: aLabel [

	pc := labels at: aLabel ifAbsent: [ MySMError signal: 'Unknown label ' , aLabel ]
]

{ #category : 'direct manipulation' }
MyStackMachine >> lt [
	"Replace a and b (b on top) by 1 if a < b, 0 otherwise (LT)."

	self execute: #LT with: nil
]

{ #category : 'direct manipulation' }
MyStackMachine >> mod [
	"Replace a and b (b on top) by a mod b (MOD)."

	self execute: #MOD with: nil
]

{ #category : 'direct manipulation' }
MyStackMachine >> mul [
	"Replace a and b (b on top) by a * b (MUL)."

	self execute: #MUL with: nil
]

{ #category : 'accessing' }
MyStackMachine >> pc [

	^ pc
]

{ #category : 'direct manipulation' }
MyStackMachine >> pop [
	"Discard the top of the stack (POP)."

	self execute: #POP with: nil
]

{ #category : 'accessing' }
MyStackMachine >> program [

	^ program
]

{ #category : 'accessing' }
MyStackMachine >> program: aCollectionOfInstructions [
	"Load a program, resolve its labels and reset the machine."

	program := aCollectionOfInstructions asArray.
	labels := Dictionary new.
	program withIndexDo: [ :instruction :index |
			instruction isLabel ifTrue: [
					(labels includesKey: instruction argument) ifTrue: [ MySMError signal: 'Duplicated label ' , instruction argument ].
					labels at: instruction argument put: index ] ].
	program select: [ :instruction | #( #JUMP #JUMP_IF_ZERO ) includes: instruction opcode ] thenDo: [ :instruction |
		(labels includesKey: instruction argument) ifFalse: [ MySMError signal: 'Unknown label ' , instruction argument ] ].
	self reset
]

{ #category : 'direct manipulation' }
MyStackMachine >> push: anIntegerOrVariableName [
	"Push an integer, or the value of the variable named by a Symbol (PUSH)."

	self execute: #PUSH with: anIntegerOrVariableName
]

{ #category : 'running' }
MyStackMachine >> reset [
	"Put the machine back at the start of its program with an empty stack."

	stack := OrderedCollection new.
	pc := 1.
	stepCount := 0
]

{ #category : 'running' }
MyStackMachine >> run [
	"Execute the program until its end and answer the resulting stack."

	[ self isFinished ] whileFalse: [ self step ].
	^ stack
]

{ #category : 'accessing' }
MyStackMachine >> source: aString [
	"Load the program written in aString."

	self program: (MySMParser parse: aString)
]

{ #category : 'accessing' }
MyStackMachine >> stack [

	^ stack
]

{ #category : 'accessing' }
MyStackMachine >> stack: aCollection [
	"Set the initial stack; the last element of aCollection is the top."

	stack := aCollection asOrderedCollection
]

{ #category : 'running' }
MyStackMachine >> step [
	"Execute the instruction at pc. Jumps may then overwrite the already advanced pc."

	| instruction |
	self isFinished ifTrue: [ ^ self ].
	stepCount := stepCount + 1.
	stepCount > stepLimit ifTrue: [ MySMError signal: 'Step limit of ' , stepLimit printString , ' exceeded (infinite loop?)' ].
	instruction := program at: pc.
	pc := pc + 1.
	self perform: instruction executionSelector with: instruction
]

{ #category : 'accessing' }
MyStackMachine >> stepLimit: anInteger [

	stepLimit := anInteger
]

{ #category : 'direct manipulation' }
MyStackMachine >> sub [
	"Replace a and b (b on top) by a - b (SUB)."

	self execute: #SUB with: nil
]

{ #category : 'direct manipulation' }
MyStackMachine >> swap [
	"Exchange the two top elements (SWAP)."

	self execute: #SWAP with: nil
]

{ #category : 'direct manipulation' }
MyStackMachine >> top [
	"Answer the top of the stack without removing it."

	stack ifEmpty: [ MySMError signal: 'The stack is empty' ].
	^ stack last
]

{ #category : 'accessing' }
MyStackMachine >> variableAt: aSymbol put: anInteger [

	variables at: aSymbol asSymbol put: anInteger
]

{ #category : 'accessing' }
MyStackMachine >> variables: aDictionary [

	variables := aDictionary copy
]
