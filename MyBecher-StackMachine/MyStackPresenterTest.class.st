"
I test `MyStackPresenter` without opening a window: it must show the stack top first and follow every change of its machine.
"
Class {
	#name : 'MyStackPresenterTest',
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
MyStackPresenterTest >> setUp [

	super setUp.
	machine := MyStackMachine new.
	machine stack: #( 10 20 ).
	presenter := MyStackPresenter on: machine
]

{ #category : 'tests' }
MyStackPresenterTest >> testFollowsMachineChanges [

	machine push: 30.
	self assert: presenter table items asArray equals: #( 30 20 10 ).
	machine add.
	self assert: presenter table items asArray equals: #( 50 10 ).
	machine reset.
	self assert: presenter table items isEmpty
]

{ #category : 'tests' }
MyStackPresenterTest >> testShowsStackTopFirst [

	self assert: presenter table items asArray equals: #( 20 10 ).
	self assert: (presenter table columns collect: [ :each | each title ]) asArray equals: #( 'Depth' 'Value' )
]

{ #category : 'tests' }
MyStackPresenterTest >> testSubscriptionIsWeak [
	"The machine must not keep closed presenters alive."

	self assert: (machine announcer subscriptions subscriptions allSatisfy: [ :each | each class = WeakAnnouncementSubscription ])
]
