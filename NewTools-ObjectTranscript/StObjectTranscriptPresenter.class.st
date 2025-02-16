"
I'm a circular logger that works with `StObjectTranscriptPresenter` instances.
II get a direct reference to my UI so that I can ask them to refresh them.
I do not use announcements for this by design!

"
Class {
	#name : 'StObjectTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'logList',
		'zoom',
		'logger',
		'inspectSelectedItem'
	],
	#category : 'NewTools-ObjectTranscript',
	#package : 'NewTools-ObjectTranscript'
}

{ #category : 'accessing' }
StObjectTranscriptPresenter class >> defaultPreferredExtent [
	"Answer the desired extent for the receiver when it is first opened on the screen.  "

	^ 450 @ 650
]

{ #category : 'accessing' }
StObjectTranscriptPresenter class >> example [
	"StObjectTranscriptLogger start.
	
	
	self example"
	
	| cb |
	StObjectTranscriptLogger start.
	cb := self new.
	cb logger: StObjectTranscriptLogger instance.
	'this is a message only interesting from the logger domain' emit.
	cb open.
	^ cb
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> connectPresenters [
	
	logList whenSelectionChangedDo: [ :selection |
		selection selectedItem
			ifNotNil: [ :log | 
				"zoom model: log asInspectorModel"
				inspectSelectedItem 
						ifTrue: [ self inspect: log ]
						ifFalse: [ self inspect: logger recordings ]
				]]
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> defaultLayout [
	

	^ SpBoxLayout
		newTopToBottom 
			add: logList ;
			add: zoom ;
		yourself
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initialize [

	super initialize. 
	inspectSelectedItem := true.
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initializePresenters [

	logList := self instantiate: SpFilteringListPresenter.
	zoom := StInspectorPresenter newApplication: self application. 

	logList 
		addActionWith: [ :item | item
			name: 'Toggle inspector';
			iconName: #smallHelp;
			action: [ inspectSelectedItem := inspectSelectedItem not ] ].
	
	
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> initializeWindow: aWindowPresenter [


	super initializeWindow: aWindowPresenter.
	aWindowPresenter whenClosedDo: [ logger removeAsClient: self ]
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> inspect: anObject [
	
	zoom model: anObject asInspectorModel
		
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> logger: aLogger [
	
	aLogger ifNil: [ ^ self ].
	logger := aLogger.
	logger addAsClient: self. 
	logList items: aLogger recordings.
	
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> refresh [ 
	
	logList items: logger recordings.
	logList scrollToIndex: logList listSize.

]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> selectedItem [

	^  logList selectedItem
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> windowTitle [ 

	^ 'Object Transcript'
]
