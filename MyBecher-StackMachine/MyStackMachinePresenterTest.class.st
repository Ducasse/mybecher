"
I test `MyStackMachinePresenter` without opening any window: I click its buttons and check what its tables and status line show.
"
Class {
	#name : 'MyStackMachinePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'machine',
		'presenter'
	],
	#category : 'MyBecher-StackMachine-Tests',
	#package : 'MyBecher-StackMachine',
	#tag : 'Tests'
}

{ #category : 'running' }
MyStackMachinePresenterTest >> setUp [

	super setUp.
	machine := MyStackMachine new.
	machine source: 'PUSH 1
PUSH 2
ADD'.
	presenter := MyStackMachinePresenter on: machine
]

{ #category : 'tests - external changes' }
MyStackMachinePresenterTest >> testDirectManipulationRefreshesStepper [

	machine
		push: 3;
		dup.
	self assert: presenter stackTable items asArray equals: #( 3 3 )
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testEachButtonRefreshesOnlyOnce [

	| stepper |
	stepper := MyCountingStackMachinePresenter on: machine.
	#( #stepButton #runButton #resetButton ) do: [ :button |
			stepper resetRefreshCount.
			(stepper perform: button) click.
			self assert: stepper refreshCount equals: 1 ]
]

{ #category : 'tests - external changes' }
MyStackMachinePresenterTest >> testExternalRunAndResetRefreshStepper [

	machine run.
	self deny: presenter stepButton isEnabled.
	self assert: presenter stackTable items asArray equals: #( 3 ).
	machine reset.
	self assert: presenter stepButton isEnabled.
	self assert: presenter stackTable items isEmpty.
	self assert: presenter programTable selection selectedIndex equals: 1
]

{ #category : 'tests - external changes' }
MyStackMachinePresenterTest >> testExternalStepRefreshesSelectionAndStatus [

	machine step.
	self assert: presenter programTable selection selectedIndex equals: 2.
	self assert: (presenter statusLabel label includesSubstring: 'pc 2').
	self assert: presenter stackTable items asArray equals: #( 1 )
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testFailingStepRefreshesOnlyOnce [
	"A failing instruction is not an expected error here: it is reported in the status line, after a single refresh."

	| stepper |
	stepper := MyCountingStackMachinePresenter on: (MyStackMachine new
			            source: 'POP';
			            yourself).
	stepper resetRefreshCount.
	stepper stepButton click.
	self assert: stepper refreshCount equals: 1.
	self assert: (stepper statusLabel label includesSubstring: 'Error')
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testFailingStepShowsErrorInStatus [
	"A failing instruction is reported in the status line, not by a debugger."

	presenter := MyStackMachinePresenter on: (MyStackMachine new
			              source: 'POP';
			              yourself).
	presenter stepButton click.
	self assert: (presenter statusLabel label includesSubstring: 'Error').
	self assert: (presenter statusLabel label includesSubstring: 'POP needs 1')
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testInitialState [

	self assert: presenter programTable items asArray equals: machine program.
	self assert: presenter programTable selection selectedIndex equals: 1.
	self assert: presenter stackTable items isEmpty.
	self assert: presenter stepButton isEnabled.
	self assert: presenter runButton isEnabled
]

{ #category : 'tests - external changes' }
MyStackMachinePresenterTest >> testNewProgramRefreshesProgramTable [

	machine source: 'PUSH 9'.
	self assert: presenter programTable items asArray equals: machine program.
	self assert: presenter programTable selection selectedIndex equals: 1
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testResetRestartsTheProgram [

	presenter runButton click.
	presenter resetButton click.
	self assert: presenter stackTable items isEmpty.
	self assert: presenter programTable selection selectedIndex equals: 1.
	self assert: presenter stepButton isEnabled
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testRunGoesToTheEnd [

	presenter runButton click.
	self assert: presenter stackTable items asArray equals: #( 3 ).
	self assert: presenter programTable selection isEmpty.
	self deny: presenter stepButton isEnabled.
	self deny: presenter runButton isEnabled.
	self assert: (presenter statusLabel label includesSubstring: 'Finished')
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testStatusShowsNextInstruction [

	presenter stepButton click.
	self assert: (presenter statusLabel label includesSubstring: 'pc 2').
	self assert: (presenter statusLabel label includesSubstring: 'PUSH 2')
]

{ #category : 'tests' }
MyStackMachinePresenterTest >> testStepRefreshesStackAndSelection [

	presenter stepButton click.
	self assert: presenter stackTable items asArray equals: #( 1 ).
	self assert: presenter programTable selection selectedIndex equals: 2.
	presenter stepButton click.
	"Top first: 2 is on top of 1."
	self assert: presenter stackTable items asArray equals: #( 2 1 ).
	self assert: presenter programTable selection selectedIndex equals: 3
]

{ #category : 'tests - external changes' }
MyStackMachinePresenterTest >> testSubscriptionIsWeak [
	"The machine must not keep closed steppers alive."

	self assert: (machine announcer subscriptions subscriptions allSatisfy: [ :each | each class = WeakAnnouncementSubscription ]).
	self deny: machine announcer subscriptions subscriptions isEmpty
]
