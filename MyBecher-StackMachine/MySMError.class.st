"
I am the error signaled by the stack machine when a program cannot be parsed or executed.

## Responsibility:

- I report a faulty program: unknown instruction, missing argument, unknown label or variable.
- I report runtime problems: stack underflow, division by zero, step limit exceeded.
- I carry a human readable `messageText` describing what went wrong.

## Collaborators: 

- `MySMParser` signals me on syntax errors.
- `MyStackMachine` signals me on runtime errors.

## Public API and Key Messages

- `MySMError signal: 'Stack underflow'`

```
[ MyStackMachine new runSource: 'POP' ] on: MySMError do: [ :e | e messageText ]
```

See `MySMError class >> #exampleUnderflow`.
"
Class {
	#name : 'MySMError',
	#superclass : 'Error',
	#category : 'MyBecher-StackMachine-Core',
	#package : 'MyBecher-StackMachine',
	#tag : 'Core'
}

{ #category : 'examples' }
MySMError class >> exampleUnderflow [

	<sampleInstance>
	^ self new
		  messageText: 'POP needs 1 element(s) but the stack holds 0';
		  yourself
]
