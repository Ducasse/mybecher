"
I represent one instruction of the stack machine language, such as `PUSH 3`, `ADD` or `JUMP_IF_ZERO loop`.

## Responsibility:

- I know my opcode (a Symbol such as `#PUSH`) and my optional argument.
- I know the set of valid opcodes and which of them need an argument.
- I print myself back in the textual syntax of the language.

## Collaborators: 

- `MySMParser` creates me from source text.
- `MyStackMachine` executes me by dispatching on my opcode.

## Public API and Key Messages

- `MySMInstruction opcode: #PUSH argument: 3`
- `MySMInstruction opcode: #ADD`
- `opcode`, `argument`, `isLabel`

```
(MySMInstruction opcode: #PUSH argument: 42) printString  ""'PUSH 42'""
```

See `MySMInstruction class >> #examplePush`.

## Internal Representation

- `opcode`: a Symbol among `MySMInstruction validOpcodes`.
- `argument`: nil, an Integer (constant for `PUSH`), or a Symbol (variable name for `PUSH`, label name for `LABEL`, `JUMP`, `JUMP_IF_ZERO`).
"
Class {
	#name : 'MySMInstruction',
	#superclass : 'Object',
	#instVars : [
		'opcode',
		'argument'
	],
	#category : 'MyBecher-StackMachine-Core',
	#package : 'MyBecher-StackMachine',
	#tag : 'Core'
}

{ #category : 'examples' }
MySMInstruction class >> examplePush [

	<sampleInstance>
	^ self opcode: #PUSH argument: 42
]

{ #category : 'instance creation' }
MySMInstruction class >> opcode: aSymbol [

	^ self opcode: aSymbol argument: nil
]

{ #category : 'instance creation' }
MySMInstruction class >> opcode: aSymbol argument: anObject [

	^ self new
		  opcode: aSymbol;
		  argument: anObject;
		  yourself
]

{ #category : 'accessing' }
MySMInstruction class >> opcodesWithArgument [
	"Answer the opcodes that take exactly one argument; all the others take none."

	^ #( #PUSH #LABEL #JUMP #JUMP_IF_ZERO )
]

{ #category : 'accessing' }
MySMInstruction class >> validOpcodes [
	"Answer all the opcodes of the language."

	^ #( #PUSH #POP #DUP #SWAP #ADD #SUB #MUL #MOD #EQ #LT #LABEL #JUMP #JUMP_IF_ZERO )
]

{ #category : 'accessing' }
MySMInstruction >> argument [

	^ argument
]

{ #category : 'accessing' }
MySMInstruction >> argument: anObject [

	argument := anObject
]

{ #category : 'accessing' }
MySMInstruction >> executionSelector [
	"Answer the selector the machine performs to execute me, e.g. #executeJUMP_IF_ZERO:."

	^ ('execute' , opcode , ':') asSymbol
]

{ #category : 'testing' }
MySMInstruction >> isLabel [

	^ opcode = #LABEL
]

{ #category : 'accessing' }
MySMInstruction >> opcode [

	^ opcode
]

{ #category : 'accessing' }
MySMInstruction >> opcode: aSymbol [

	opcode := aSymbol
]

{ #category : 'printing' }
MySMInstruction >> printOn: aStream [

	aStream nextPutAll: opcode.
	argument ifNotNil: [
			aStream
				space;
				nextPutAll: argument asString ]
]
