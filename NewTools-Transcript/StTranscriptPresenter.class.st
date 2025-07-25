"
I a simple presenter that displays the contents of newThreadSafeTranscript instances.
I listen to the NewEntryToTranscript announcement to refresh my contents.


"
Class {
	#name : 'StTranscriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'text',
		'transcript',
		'leftToolbar',
		'rightToolBar',
		'service',
		'mutex',
		'waitingEntries',
		'keepServiceAliveStep'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'accessing' }
StTranscriptPresenter class >> defaultPreferredExtent [

	^ (447 @ 300) scaledByDisplayScaleFactor
]

{ #category : 'accessing' }
StTranscriptPresenter class >> exampleDefault [
	"this example shows that we can use a different instance than the singleton."

	<script>
	^ self new open
]

{ #category : 'accessing' }
StTranscriptPresenter class >> exampleNonGlobalTranscript [
	"this example shows that we can use a different instance than the singleton."

	<script>
	| presenter transcript |
	presenter := self new.
	transcript := StThreadSafeTranscript new.
	transcript show: 'Hello Pharo I''m a new textual transcript'.
	presenter transcript: transcript.
	^ presenter open
]

{ #category : 'tools registry' }
StTranscriptPresenter class >> maxEmptySteps [
"Maximum amount of steps with the queue empty for the service to stop"
	^ 5
]

{ #category : 'accessing' }
StTranscriptPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Transcript')
		action: [ (Smalltalk tools toolNamed: #transcript) new open ];
		order: 2;
		parent: #InputOutput;
		help: 'Transcript';
		keyText: 'o, t';
		help: 'Window on the new Transcript output stream, which is useful for writing log messages.';
		iconName: #transcript
	
]

{ #category : 'instance creation' }
StTranscriptPresenter class >> open [

	<script>
	^ self new open
]

{ #category : 'instance creation' }
StTranscriptPresenter class >> openOn: aTranscript [

	<script>
	^ self new transcript: aTranscript; open
]

{ #category : 'tools registry' }
StTranscriptPresenter class >> registerToolsOn: aRegistry [
	"Smalltalk tools register: self as: #transcript"

	aRegistry register: self as: #transcript
]

{ #category : 'actions' }
StTranscriptPresenter >> clear [
	
	text clearContent
]

{ #category : 'private' }
StTranscriptPresenter >> ensureTranscriptService [
		
	service ifNotNil: [ 
		service isRunning ifFalse: [ service restart ].
		^ service ].
	
	service := TKTParameterizableService new.
	service name: 'Transcript service: ', UUID new asString.
	service stepDelay: 50 milliSeconds.
	service step: [ self processEntries ].
	service start.
	
	^ service
]

{ #category : 'actions' }
StTranscriptPresenter >> fetchOld [ 

	text appendText: transcript contents
]

{ #category : 'initialization' }
StTranscriptPresenter >> initialize [

	super initialize.
	self registerToAnnouncer.
	transcript := StThreadSafeTranscript defaultInstance.
	keepServiceAliveStep := 0
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeLeftToolbar [

	leftToolbar := self newToolbar 
  		addStyle: 'stToolbar';
  		displayMode: self application toolbarDisplayMode;
  		yourself.
	
	leftToolbar
		add: (leftToolbar newToolbarButton 
			label: 'Clear';
			icon: (self application iconNamed: #changeRemove );
			help: 'Clears the transcript';
			action: [ self clear ])
			
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializePresenters [ 


	text := self newText.
	text beEditable.
	self initializeToolbars
	
	
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeRightToolbar [
		
	rightToolBar := self newToolbar 
	  		addStyle: 'stToolbar';
  		displayMode: self application toolbarDisplayMode;
  		yourself.
			
	rightToolBar 
		add: (rightToolBar newToolbarButton 
			label: 'Reset';
			icon: (self application iconNamed: #glamorousTrash );
			help: 'Resets the transcript history';
			action: [ self reset ]);
		add: (rightToolBar newToolbarButton 
			label: 'Fetch';
			icon: (self application iconNamed: #down );
			help: 'Fetches transcript history';
			action: [ self fetchOld ])
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeToolbars [

	self initializeLeftToolbar.
	self initializeRightToolbar
]

{ #category : 'initialization' }
StTranscriptPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ self unregister ]
]

{ #category : 'layout' }
StTranscriptPresenter >> layout [ 

	^ SpBoxLayout newTopToBottom 
		add: (SpBoxLayout newLeftToRight 
			add: leftToolbar ;
			add: rightToolBar expand: false ) 
			expand: false;
		add: text;
		yourself
]

{ #category : 'private' }
StTranscriptPresenter >> maybeStopService [

	self waitingEntries isEmpty 
		ifFalse: [ 
			keepServiceAliveStep := 0.
			^ self ].
		
	keepServiceAliveStep := keepServiceAliveStep + 1.
	keepServiceAliveStep = self class maxEmptySteps 
		ifTrue: [ service stop ].

]

{ #category : 'private' }
StTranscriptPresenter >> mutex [
		
	^ mutex ifNil: [ mutex := Mutex new ]
]

{ #category : 'private' }
StTranscriptPresenter >> processEntries [
	| entries |
	
	self maybeStopService.
	self waitingEntries ifEmpty: [ ^ self ].
	
	entries := #().
	self mutex critical: [
		entries := self waitingEntries copy. 
		self waitingEntries removeAll ].

	self application defer: [
		| newText |
		newText := String streamContents: [ :stream | 
			entries do: [ :each | stream nextPutAll: each ] ].
		text appendText: newText ]
]

{ #category : 'registration' }
StTranscriptPresenter >> registerToAnnouncer [

	SystemAnnouncer uniqueInstance
		when: NewEntryToTranscript
		send: #updateNewEntry: 
		to: self
]

{ #category : 'actions' }
StTranscriptPresenter >> reset [

	transcript clear.
	self clear
]

{ #category : 'accessing' }
StTranscriptPresenter >> text [

	^ text
]

{ #category : 'accessing' }
StTranscriptPresenter >> transcript: aTranscript [

	transcript := aTranscript
]

{ #category : 'registration' }
StTranscriptPresenter >> unregister [

	self ensureTranscriptService stop.
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : 'private' }
StTranscriptPresenter >> updateNewEntry: anAnnouncement [

	self ensureTranscriptService.
	self mutex critical: [ 
		self waitingEntries add: anAnnouncement entry ]
]

{ #category : 'private' }
StTranscriptPresenter >> waitingEntries [

	^ waitingEntries ifNil: [ waitingEntries := OrderedCollection new: 100 ]
]

{ #category : 'accessing' }
StTranscriptPresenter >> windowTitle [

	^ 'Transcript'
]
