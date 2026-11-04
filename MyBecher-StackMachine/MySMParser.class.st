"
I turn the textual source of a stack machine program into a sequence of `MySMInstruction`.

## Responsibility:

- I read one instruction per line; opcodes are case insensitive.
- I skip blank lines and comments (from `;` or `#` to the end of the line).
- I check opcodes and their arguments, and signal `MySMError` on malformed lines.

## Collaborators: 

- `MySMInstruction`: I create one per meaningful line.
- `MyStackMachine`: uses me to load programs given as text.
- `MySMError`: signaled on syntax errors.

## Public API and Key Messages

- `MySMParser parse: aString` answers an Array of instructions.

```
MySMParser parse: 'PUSH 1
PUSH 2
ADD   ; 3'
```

See `MySMParser class >> #exampleDefault`.

### Implementation Points

- `PUSH` takes an integer constant (possibly negative) or a variable name.
- `LABEL`, `JUMP` and `JUMP_IF_ZERO` take a label name.
"
Class {
	#name : 'MySMParser',
	#superclass : 'Object',
	#category : 'MyBecher-StackMachine-Core',
	#package : 'MyBecher-StackMachine',
	#tag : 'Core'
}

{ #category : 'examples' }
MySMParser class >> exampleDefault [

	<sampleInstance>
	^ self new
]

{ #category : 'parsing' }
MySMParser class >> parse: aString [
	"Answer the Array of instructions described by aString."

	^ self new parse: aString
]

{ #category : 'private' }
MySMParser >> error: aString line: lineNumber [

	^ MySMError signal: 'Line ' , lineNumber printString , ': ' , aString
]

{ #category : 'private' }
MySMParser >> isInteger: aToken [

	| digits |
	digits := aToken first = $-
		          ifTrue: [ aToken allButFirst ]
		          ifFalse: [ aToken ].
	^ digits isNotEmpty and: [ digits allSatisfy: [ :each | each isDigit ] ]
]

{ #category : 'parsing' }
MySMParser >> parse: aString [
	"Answer the Array of instructions described by aString, one per non-empty line."

	^ Array streamContents: [ :stream |
			  aString lines withIndexDo: [ :line :lineNumber |
				  (self parseLine: line number: lineNumber) ifNotNil: [ :instruction | stream nextPut: instruction ] ] ]
]

{ #category : 'parsing' }
MySMParser >> parseArgument: aToken of: opcode line: lineNumber [
	"Answer an Integer for a numeric PUSH argument, a Symbol for a variable or label name."

	(opcode = #PUSH and: [ self isInteger: aToken ]) ifTrue: [ ^ aToken asInteger ].
	(aToken first isLetter or: [ aToken first = $_ ]) ifFalse: [ ^ self error: 'Invalid name ' , aToken printString line: lineNumber ].
	^ aToken asSymbol
]

{ #category : 'parsing' }
MySMParser >> parseLine: aLine number: lineNumber [
	"Answer the instruction written on aLine, or nil when the line holds no instruction."

	| tokens opcode |
	tokens := (self withoutComment: aLine) substrings.
	tokens ifEmpty: [ ^ nil ].
	opcode := tokens first asUppercase asSymbol.
	(MySMInstruction validOpcodes includes: opcode) ifFalse: [
		^ self error: 'Unknown instruction ' , tokens first printString line: lineNumber ].
	(MySMInstruction opcodesWithArgument includes: opcode)
		ifTrue: [
				tokens size = 2 ifFalse: [ ^ self error: opcode , ' expects one argument' line: lineNumber ].
				^ MySMInstruction opcode: opcode argument: (self parseArgument: tokens second of: opcode line: lineNumber) ]
		ifFalse: [
				tokens size = 1 ifFalse: [ ^ self error: opcode , ' takes no argument' line: lineNumber ].
				^ MySMInstruction opcode: opcode ]
]

{ #category : 'private' }
MySMParser >> withoutComment: aLine [
	"Answer aLine truncated at the first comment character (; or #)."

	| index |
	index := aLine findFirst: [ :each | each = $; or: [ each = $# ] ].
	^ index = 0
		  ifTrue: [ aLine ]
		  ifFalse: [ aLine first: index - 1 ]
]
