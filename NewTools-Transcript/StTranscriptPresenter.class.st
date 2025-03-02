Class {
	#name : 'StTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'text',
		'transcript'
	],
	#classInstVars : [
		'recordings'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'accessing' }
StTranscriptPresenter class >> defaultPreferredExtent [

	^ 700@500
]

{ #category : 'tools registry' }
StTranscriptPresenter class >> registerToolsOn: aRegistry [
	"Smalltalk tools register: self as: #newTranscript"
	
	aRegistry register: self as: #transcript
]

{ #category : 'initialization' }
StTranscriptPresenter >> initialize [ 

	super initialize.
	self registerToAnnouncer. 
	transcript := NewThreadSafeTranscript uniqueInstance
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializePresenters [ 


	text := self newText.
	
	
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenOpenedDo: [ self updateNewEntry ];
		whenClosedDo: [ self unregister ]
]

{ #category : 'accessing' }
StTranscriptPresenter >> layout [ 

	^ SpBoxLayout newLeftToRight 
			add: text;
			yourself
]

{ #category : 'registration' }
StTranscriptPresenter >> registerToAnnouncer [

	
	SystemAnnouncer uniqueInstance
		when: NewEntryToTranscript
		send: #updateNewEntry
		to: self
]

{ #category : 'accessing' }
StTranscriptPresenter >> text [

	^ text
]

{ #category : 'registration' }
StTranscriptPresenter >> unregister [

	^ SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : 'accessing' }
StTranscriptPresenter >> updateNewEntry [

	text text: transcript contents.
	
]

{ #category : 'accessing' }
StTranscriptPresenter >> windowTitle [

	^ 'New basic transcript'
]
