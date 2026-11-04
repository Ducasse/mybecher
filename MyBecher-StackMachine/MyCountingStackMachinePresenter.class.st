"
I am a `MyStackMachinePresenter` used only by tests: I count how many times I am refreshed, to check that an action redraws the stepper exactly once.

## Responsibility:

- I behave exactly like `MyStackMachinePresenter`.
- I count my `refresh` calls in `refreshCount`.
- `resetRefreshCount` starts a new measure.

## Collaborators: 

- `MyStackMachinePresenterTest` creates me and reads `refreshCount`.

## Public API and Key Messages

- `MyCountingStackMachinePresenter on: aMachine`
- `refreshCount`, `resetRefreshCount`

```
| stepper |
stepper := MyCountingStackMachinePresenter on: MyStackMachine exampleSumToN.
stepper resetRefreshCount.
stepper stepButton click.
stepper refreshCount   ""1""
```

See `MyCountingStackMachinePresenter class >> #exampleSumToN`.
"
Class {
	#name : 'MyCountingStackMachinePresenter',
	#superclass : 'MyStackMachinePresenter',
	#instVars : [
		'refreshCount'
	],
	#category : 'MyBecher-StackMachine-Tests',
	#package : 'MyBecher-StackMachine',
	#tag : 'Tests'
}

{ #category : 'private' }
MyCountingStackMachinePresenter >> refresh [

	refreshCount := (refreshCount ifNil: [ 0 ]) + 1.
	super refresh
]

{ #category : 'accessing' }
MyCountingStackMachinePresenter >> refreshCount [

	^ refreshCount ifNil: [ 0 ]
]

{ #category : 'actions' }
MyCountingStackMachinePresenter >> resetRefreshCount [

	refreshCount := 0
]
