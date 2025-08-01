Class {
	#name : 'StTranscriptPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter',
		'transcript'
	],
	#category : 'NewTools-Transcript-Tests',
	#package : 'NewTools-Transcript-Tests'
}

{ #category : 'running' }
StTranscriptPresenterTest >> setUp [ 

	super setUp.
	presenter := StTranscriptPresenter new.
	presenter transcript: (transcript := StThreadSafeTranscript createTestingInstance)
]

{ #category : 'running' }
StTranscriptPresenterTest >> tearDown [ 

	presenter withWindowDo: #close.
	super tearDown
]

{ #category : 'tests' }
StTranscriptPresenterTest >> testAnnouncementIsWritten [

	| window |
	
	[ 
		window := presenter open.
		transcript show: 'test'.
		300 milliSeconds wait.
		self assert: presenter text text equals: 'test' ]
	ensure: [ window close ]
]

{ #category : 'tests' }
StTranscriptPresenterTest >> testClear [

	| window |
	
	[ 
		window := presenter open.
		transcript show: 'test'.
		300 milliSeconds wait.
		self assert: presenter text text equals: 'test'.
		presenter clear.
		self assert: presenter text text equals: ''.
		self assert: transcript contents equals: 'test' ]
	ensure: [ window close ]
]

{ #category : 'tests' }
StTranscriptPresenterTest >> testFetchOld [

	| window |
	
	[ 
		window := presenter open.
		transcript show: 'test'.
		300 milliSeconds wait.
		presenter clear.
		self assert: presenter text text equals: ''.
		presenter fetchOld.
		self assert: transcript contents equals: 'test' ]
	ensure: [ window close ]
]

{ #category : 'tests' }
StTranscriptPresenterTest >> testReset [

	| window |
	
	[ 
		window := presenter open.
		transcript show: 'test'.
		300 milliSeconds wait.
		self assert: presenter text text equals: 'test'.
		self assert: transcript contents equals: 'test'.
		presenter reset.
		self assert: presenter text text equals: ''.
		self assert: transcript contents equals: '' ]
	ensure: [ window close ]
]

{ #category : 'tests' }
StTranscriptPresenterTest >> testSmoke [

	| window |
	[ self shouldnt: [ window := presenter open ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ].

	[ self shouldnt: [ window := StTranscriptPresenter exampleDefault ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ].

	[ self shouldnt: [ window := StTranscriptPresenter exampleNonGlobalTranscript ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ].

	[ self shouldnt: [ window := presenter openDialog ] raise: Error ] ensure: [ window ifNotNil: [ window close ] ]
]
