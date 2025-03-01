"
I'm a new transcript. 

My existence is to be able to remove the global variable Transcript from the system dictionary.
I'm raising an announcement so that my visual representant can update themselves.

I'm based on a circular list.

"
Class {
	#name : 'NewThreadSafeTranscript',
	#superclass : 'Model',
	#instVars : [
		'stream',
		'accessSemaphore',
		'deferredClear',
		'deferredEndEntry',
		'stepContents',
		'mutex',
		'recordings',
		'index',
		'loopCount',
		'maxEntry'
	],
	#classVars : [
		'UniqueInstance'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'declare' }
NewThreadSafeTranscript class >> install [

	self installThreadSafeAsTranscript
]

{ #category : 'declare' }
NewThreadSafeTranscript class >> installThreadSafeAsTranscript [
	<script>

	Smalltalk globals at: #Transcript put: (self new)
]

{ #category : 'icons' }
NewThreadSafeTranscript class >> taskbarIconName [
	"Answer the icon for the receiver in a task bar."

	^#transcript
]

{ #category : 'declare' }
NewThreadSafeTranscript class >> uniqueInstance [
	<script>

	UniqueInstance ifNil: [ UniqueInstance := self new ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> << anObject [
	"Write anObject to the receiver, dispatching using #putOn:
	This is a shortcut for both nextPut: and nextPutAll: since anObject can be both
	the element type of the receiver as well as a collection of those elements.
	No further conversions of anObject are applied.
	Return self to accomodate chaining."

 	anObject putOn: self
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> clear [

	mutex critical: [
		recordings := OrderedCollection new.
		SystemAnnouncer uniqueInstance announce: (NewEntryToTranscript new recordings: recordings)  ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> close [
	"Close the receiver, indicating it is not longer needed"
]

{ #category : 'protected low level' }
NewThreadSafeTranscript >> contents [ 
	"probably super inefficient again... "
	
	^ String streamContents: [ :s |
		recordings do: [ :each | s << each ] ] 
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> cr [
	"Output a cr on the receiver, buffered and not yet shown"

	self nextPut: Character cr
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> crShow: anObject [
	"Output anObject asString on the receiver preceded by a cr and show the output"

	self critical: [ self cr; show: anObject ]
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> critical: block [
	"Execute block making sure only one thread accesses the receiver"

	^ accessSemaphore critical: block
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> endEntry [
	"Show the currently buffered output"
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> flush [
	
	
]

{ #category : 'testing' }
NewThreadSafeTranscript >> hasBindingOf: aString [
	^ false
]

{ #category : 'initialization' }
NewThreadSafeTranscript >> initialize [

	super initialize.
	accessSemaphore := Mutex new.
	maxEntry := 5000.
	index := 0.
	loopCount := 0.
	
]

{ #category : 'initialization' }
NewThreadSafeTranscript >> maxEntry: aNumber [


	maxEntry := aNumber
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> nextPut: aCharacter [

	mutex critical: [
		self rawNextPut: aCharacter ].
	^ aCharacter

]

{ #category : 'streaming' }
NewThreadSafeTranscript >> nextPutAll: value [
	"Ineffient way...."

	self critical: [ value do: [ :each | each rawNewPut: each  ] ].
	^ value
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> rawNextPut: aCharacter [

	
		index := index >= maxEntry
						ifTrue: [
				         loopCount := loopCount + 1.
				         1 ]
			         ifFalse: [ index + 1 ].
		recordings at: index put: aCharacter.
	
]

{ #category : 'streaming' }
NewThreadSafeTranscript >> reset [

	self clear
]

{ #category : 'updating' }
NewThreadSafeTranscript >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	^ false
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> show: anObject [
	"Output anObject asString on the receiver and show the output"

	self critical: [ self print: anObject  ]
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> space [
	"Output a space on the receiver, buffered and not yet shown"

	self nextPut: Character space
]

{ #category : 'stop conditions' }
NewThreadSafeTranscript >> tab [
	"Output a tab on the receiver, buffered and not yet shown"

	self nextPut: Character tab
]
