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

{ #category : 'tools registry' }
StTranscriptPresenter class >> contents [ 

	"It answers a copy of the recorded collection to not grant
	access to the users to a shared resource that should only be
	modified via the mutex"
	^ recordings copy
]

{ #category : 'accessing' }
StTranscriptPresenter class >> defaultPreferredExtent [ 

	^ 200@800
]

{ #category : 'tools registry' }
StTranscriptPresenter class >> registerToolsOn: aRegistry [
	"Smalltalk tools register: self as: #transcript"
	
	aRegistry register: self as: #newtranscript
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

{ #category : 'registration' }
StTranscriptPresenter >> unregister [

	^ SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : 'accessing' }
StTranscriptPresenter >> updateNewEntry [

	self update.
	text text: transcript contents
]

{ #category : 'accessing' }
StTranscriptPresenter >> windowTitle [

	^ 'New basic transcript'
]
