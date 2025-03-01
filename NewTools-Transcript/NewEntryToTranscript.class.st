Class {
	#name : 'NewEntryToTranscript',
	#superclass : 'Announcement',
	#instVars : [
		'recordings'
	],
	#category : 'NewTools-Transcript',
	#package : 'NewTools-Transcript'
}

{ #category : 'accessing' }
NewEntryToTranscript >> recordings [

	^ recordings
]

{ #category : 'accessing' }
NewEntryToTranscript >> recordings: anObject [

	recordings := anObject
]
