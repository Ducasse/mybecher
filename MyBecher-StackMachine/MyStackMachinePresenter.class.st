"
I am a small Spec debugger for a `MyStackMachine`: I let you execute its program one instruction at a time and watch the stack change.

## Responsibility:

- I show the program, with an arrow and the selection on the next instruction to execute.
- I show the operand stack, top first (depth 1 is the top), refreshed after every action.
- I offer Step, Run and Reset buttons, and a status line giving the pc, the end of the program or the last error.

## Collaborators: 

- `MyStackMachine`: the model I drive with `step`, `run` and `reset`.
- `MyStackPresenter`: embedded to show the stack.
- `MyStackMachineChanged`: I subscribe to it weakly, so I refresh whoever changes the machine (my buttons, inspector code, direct manipulation).
- `MySMError`: caught when an instruction fails, and shown in the status line instead of opening a debugger.
- Spec presenters (`SpTablePresenter`, `SpButtonPresenter`, `SpLabelPresenter`) build my layout.

## Public API and Key Messages

- `MyStackMachinePresenter on: aMachine` creates me; `open` shows me in a window.
- `stepInstruction`, `runProgram`, `resetProgram`: the actions behind the buttons.
- `stepButton`, `runButton`, `resetButton`, `stackTable`, `programTable`, `statusLabel`: my parts, mostly for tests.

```
(MyStackMachinePresenter on: MyStackMachine exampleSumToN) open
```

See `MyStackMachinePresenter class >> #exampleSumToN` and `MyStackMachinePresenter class >> #scriptFactorial`.

## Internal Representation

- `machine`: the `MyStackMachine` being stepped.
- `programTable`: the instructions; `stackPresenter`: a `MyStackPresenter` for the stack.
- `stepButton`, `runButton`, `resetButton`: the actions; Step and Run are disabled once the program is finished.
- `statusLabel`: the pc, the end of the program, or the last error message.

### Implementation Points

- I never refresh myself after an action: the machine announces `MyStackMachineChanged` exactly once per change and my subscription calls `refresh`, which reloads the program if needed, moves the selection to the pc, and updates the buttons and status. So one click means one refresh.
- `performReportingErrors:` catches `MySMError` around each action, so a faulty program shows its error in the status line instead of opening a debugger. The message is written after the announcement (sent while the error unwinds), so the refresh does not erase it.
"
Class {
	#name : 'MyStackMachinePresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'machine',
		'programTable',
		'stepButton',
		'runButton',
		'resetButton',
		'statusLabel',
		'stackPresenter'
	],
	#category : 'MyBecher-StackMachine-UI',
	#package : 'MyBecher-StackMachine',
	#tag : 'UI'
}

{ #category : 'examples' }
MyStackMachinePresenter class >> exampleSumToN [
	"A stepper on the program summing 1..10, not yet opened."

	<sampleInstance>
	^ self on: MyStackMachine exampleSumToN
]

{ #category : 'script' }
MyStackMachinePresenter class >> scriptFactorial [
	"Open a stepper on the program computing 5!: click Step and watch the stack."

	<script>
	(self on: (MyStackMachine new
			  source: MyStackMachine factorialSource;
			  variableAt: #N put: 5;
			  yourself)) open
]

{ #category : 'initialization' }
MyStackMachinePresenter >> connectPresenters [
	"Follow the machine whoever changes it (buttons, inspector code, direct manipulation); weakly, so the machine does not keep me alive."

	machine announcer weak when: MyStackMachineChanged send: #refresh to: self
]

{ #category : 'layout' }
MyStackMachinePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: stepButton expand: false;
				   add: runButton expand: false;
				   add: resetButton expand: false;
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newLeftToRight
				   add: programTable;
				   add: stackPresenter;
				   yourself);
		  add: statusLabel expand: false;
		  yourself
]

{ #category : 'initialization' }
MyStackMachinePresenter >> initializePresenters [

	programTable := self newTable
		                addColumn: ((SpStringTableColumn title: '' evaluated: [ :instruction | self markerFor: instruction ])
				                 width: 20;
				                 yourself);
		                addColumn: (SpIndexTableColumn new
				                 title: '#';
				                 width: 30;
				                 yourself);
		                addColumn: (SpStringTableColumn title: 'Instruction' evaluated: [ :instruction | instruction printString ]);
		                items: machine program;
		                yourself.
	stackPresenter := self instantiate: MyStackPresenter on: machine.
	stepButton := self newButton
		              label: 'Step';
		              icon: (self iconNamed: #glamorousInto);
		              help: 'Execute the next instruction';
		              action: [ self stepInstruction ];
		              yourself.
	runButton := self newButton
		             label: 'Run';
		             icon: (self iconNamed: #glamorousGo);
		             help: 'Execute until the end of the program';
		             action: [ self runProgram ];
		             yourself.
	resetButton := self newButton
		               label: 'Reset';
		               icon: (self iconNamed: #glamorousRestart);
		               help: 'Restart the program with an empty stack';
		               action: [ self resetProgram ];
		               yourself.
	statusLabel := self newLabel.
	self refresh
]

{ #category : 'initialization' }
MyStackMachinePresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'Stack machine stepper';
		initialExtent: 600 @ 400
]

{ #category : 'private' }
MyStackMachinePresenter >> markerFor: anInstruction [
	"Answer an arrow for the next instruction to execute, an empty string otherwise."

	^ (machine isFinished not and: [ (machine program at: machine pc) == anInstruction ])
		  ifTrue: [ '▶' ]
		  ifFalse: [ '' ]
]

{ #category : 'private' }
MyStackMachinePresenter >> performReportingErrors: aBlock [
	"Run aBlock on the machine; the machine's change announcement refreshes me. A machine error is shown in the status line instead of opening a debugger. It is written after the announcement, which runs while the error unwinds and would otherwise overwrite it."

	| errorText |
	[ aBlock value ]
		on: MySMError
		do: [ :error | errorText := error messageText ].
	errorText ifNotNil: [ statusLabel label: 'Error: ' , errorText ]
]

{ #category : 'accessing' }
MyStackMachinePresenter >> programTable [
	^ programTable
]

{ #category : 'private' }
MyStackMachinePresenter >> refresh [
	"Show the current state of the machine: program (if replaced), stack top first, next instruction selected, buttons and status updated."

	| finished |
	finished := machine isFinished.
	programTable items asArray = machine program ifFalse: [ programTable items: machine program ].
	stackPresenter refresh.
	programTable refresh.
	finished
		ifTrue: [ programTable unselectAll ]
		ifFalse: [ programTable selectIndex: machine pc scrollToSelection: true ].
	stepButton enabled: finished not.
	runButton enabled: finished not.
	statusLabel label: (finished
			 ifTrue: [ 'Finished. Result: ' , (machine stack ifEmpty: [ 'empty stack' ] ifNotEmpty: [ :stack | stack last printString ]) ]
			 ifFalse: [ 'pc ' , machine pc printString , ' - next: ' , (machine program at: machine pc) printString ])
]

{ #category : 'accessing' }
MyStackMachinePresenter >> resetButton [
	^ resetButton
]

{ #category : 'actions' }
MyStackMachinePresenter >> resetProgram [
	"Restart the program from its first instruction with an empty stack."

	self performReportingErrors: [ machine reset ]
]

{ #category : 'accessing' }
MyStackMachinePresenter >> runButton [
	^ runButton
]

{ #category : 'actions' }
MyStackMachinePresenter >> runProgram [
	"Execute the rest of the program and show the final state."

	self performReportingErrors: [ machine run ]
]

{ #category : 'initialization' }
MyStackMachinePresenter >> setModelBeforeInitialization: aMachine [

	machine := aMachine
]

{ #category : 'accessing' }
MyStackMachinePresenter >> stackPresenter [

	^ stackPresenter
]

{ #category : 'accessing' }
MyStackMachinePresenter >> stackTable [

	^ stackPresenter table
]

{ #category : 'accessing' }
MyStackMachinePresenter >> statusLabel [
	^ statusLabel
]

{ #category : 'accessing' }
MyStackMachinePresenter >> stepButton [
	^ stepButton
]

{ #category : 'actions' }
MyStackMachinePresenter >> stepInstruction [
	"Execute the next instruction and show the new state."

	self performReportingErrors: [ machine step ]
]
