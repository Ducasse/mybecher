"
I am announced by a `MyStackMachine` whenever its state changes: stack, program counter or program.

## Responsibility:

- I tell listeners, typically user interfaces, that they should redraw the machine.
- I know which machine changed.
- I carry no details about the change: listeners read what they need from the machine.

## Collaborators: 

- `MyStackMachine` announces me through its `announcer` after `step`, `run`, `reset`, `stack:`, `program:` and every direct-manipulation message.
- `MyStackMachinePresenter` and `MyStackPresenter` subscribe to me (weakly) and refresh.

## Public API and Key Messages

- `MyStackMachineChanged machine: aMachine`
- `machine`

```
machine announcer weak when: MyStackMachineChanged send: #refresh to: aPresenter
```

See `MyStackMachineChanged class >> #exampleDefault`.
"
Class {
	#name : 'MyStackMachineChanged',
	#superclass : 'Announcement',
	#instVars : [
		'machine'
	],
	#category : 'MyBecher-StackMachine-Core',
	#package : 'MyBecher-StackMachine',
	#tag : 'Core'
}

{ #category : 'examples' }
MyStackMachineChanged class >> exampleDefault [

	<sampleInstance>
	^ self machine: MyStackMachine exampleSumToN
]

{ #category : 'instance creation' }
MyStackMachineChanged class >> machine: aMachine [

	^ self new
		  machine: aMachine;
		  yourself
]

{ #category : 'accessing' }
MyStackMachineChanged >> machine [

	^ machine
]

{ #category : 'accessing' }
MyStackMachineChanged >> machine: aMachine [

	machine := aMachine
]
