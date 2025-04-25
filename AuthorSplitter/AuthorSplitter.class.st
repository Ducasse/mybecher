Class {
	#name : 'AuthorSplitter',
	#superclass : 'Object',
	#instVars : [
		'lines',
		'authors'
	],
	#category : 'AuthorSplitter',
	#package : 'AuthorSplitter'
}

{ #category : 'operations' }
AuthorSplitter >> authorsFromAuthorFileNamed: aStringPath [
	"self new authorsFromAuthorFileNamed: '/Users/ducasse/Desktop/AUTHORS_Original.txt'"
	
	| f |
 	f := aStringPath asFileReference.
	f readStreamDo: [ :s | 
			[ s atEnd ] whileFalse: [ lines add: s nextLine ]
	].
	self cleanLines. 
	self cleanAuthors. 

]

{ #category : 'operations' }
AuthorSplitter >> cleanAuthors [
	| f | 
	f := '/Users/ducasse/Desktop/Authors.txt' asFileReference.
	f writeStreamDo: [ :s |
		authors asOrderedCollection sorted 
			do: [ :each | s nextPutAll: each  ]
			separatedBy: [ s cr ]
			 ]

]

{ #category : 'operations' }
AuthorSplitter >> cleanLines [
	
	lines do: [ :each |  
		authors add: (self treatALine: each) ]
	
	
]

{ #category : 'initialization' }
AuthorSplitter >> initialize [

	super initialize. 
	lines := OrderedCollection new.
	authors := Set new
]

{ #category : 'operations' }
AuthorSplitter >> treatALine: aString [ 
	| line |
	line := aString copyUpTo: $<.
	line := line trimBoth.
	line := line copyFrom: (line indexOf: (Character value: 9)) + 1 to: line size.
	^ line
]
