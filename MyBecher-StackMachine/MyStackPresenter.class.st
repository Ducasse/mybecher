"
I show the operand stack of a `MyStackMachine`, top first, and redraw myself whenever the machine changes.

## Responsibility:

- I list the stack values with their depth: depth 1 is the top of the stack.
- I subscribe weakly to `MyStackMachineChanged`, so I stay up to date whoever changes the machine (stepper buttons, inspector code, direct manipulation).
- I do not keep the machine alive: once my window is closed I can be garbage collected.

## Collaborators: 

- `MyStackMachine`: the model whose `stack` I display.
- `MyStackMachineChanged`: the announcement that triggers my `refresh`.
- `MyStackMachinePresenter` embeds me as its stack view; `MyStackMachine >> #inspectionStack:` uses me as the Stack inspector pane.

## Public API and Key Messages

- `MyStackPresenter on: aMachine`, then `open`.
- `refresh` redraws the stack; `table` gives the underlying `SpTablePresenter`.

```
| machine |
machine := MyStackMachine new.
(MyStackPresenter on: machine) open.
machine push: 3; dup   ""the window now shows 3 and 3""
```

See `MyStackPresenter class >> #exampleDefault`.

## Internal Representation

- `machine`: the displayed `MyStackMachine`.
- `table`: an `SpTablePresenter` with a Depth and a Value column.
"
Class {
	#name : 'MyStackPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'machine',
		'table'
	],
	#category : 'MyBecher-StackMachine-UI',
	#package : 'MyBecher-StackMachine',
	#tag : 'UI'
}

{ #category : 'examples' }
MyStackPresenter class >> exampleDefault [
	"A stack view on a machine holding 1, 2 and 3 (3 on top), not yet opened."

	<sampleInstance>
	^ self on: (MyStackMachine new
			   push: 1;
			   push: 2;
			   push: 3;
			   yourself)
]

{ #category : 'initialization' }
MyStackPresenter >> connectPresenters [
	"Follow the machine whoever changes it; weakly, so the machine does not keep me alive."

	machine announcer weak when: MyStackMachineChanged send: #refresh to: self
]

{ #category : 'layout' }
MyStackPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: table;
		  yourself
]

{ #category : 'initialization' }
MyStackPresenter >> initializePresenters [

	table := self newTable
		         addStyle: 'stList';
		         addColumn: (SpIndexTableColumn new
				          title: 'Depth';
				          width: 60;
				          yourself);
		         addColumn: (SpStringTableColumn new
				          title: 'Value';
				          evaluated: [ :each | StObjectPrinter asTruncatedTextFrom: each ];
				          yourself);
		         yourself.
	self refresh
]

{ #category : 'initialization' }
MyStackPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Stack';
		initialExtent: 250 @ 300
]

{ #category : 'updating' }
MyStackPresenter >> refresh [
	"Show the current stack, top first."

	table items: machine stack reversed
]

{ #category : 'initialization' }
MyStackPresenter >> setModelBeforeInitialization: aMachine [

	machine := aMachine
]

{ #category : 'accessing' }
MyStackPresenter >> table [

	^ table
]
