Class {
	#name : 'StObjectTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'logList',
		'zoom',
		'logger'
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
	"self example"
	
	| cb |
	cb := self new.
	cb logger: (CircularMemoryLogger start; instance).
	'this is a message only interesting from the logger domain' asBeaconSignal emit.
	cb open.
	^ cb
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> browse [ 
	
	^ self selectedItem browse
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> connectPresenters [
	
	logList whenSelectedItemChangedDo: [ :selection |
		selection 
			ifNotNil: [ :log | 
				zoom model: log asInspectorModel ]].
		
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
StObjectTranscriptPresenter >> initializePresenters [

	logList := self newList.
	zoom := StInspectorPresenter newApplication: self application. 
	
	
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> logger: aLogger [
	aLogger ifNil: [ ^ self ].
	logger := aLogger.
	logList items: aLogger recordings.
	
]

{ #category : 'initialization' }
StObjectTranscriptPresenter >> selectedItem [

	^  logList selectedItem
]

{ #category : 'accessing' }
StObjectTranscriptPresenter >> windowTitle [ 

	^ 'Object Transcript'
]
