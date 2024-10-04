Class {
	#name : 'IconCleaner',
	#superclass : 'Object',
	#instVars : [
		'tempTarget',
		'source'
	],
	#category : 'MyBecher-IconCleaner',
	#package : 'MyBecher-IconCleaner'
}

{ #category : 'as yet unclassified' }
IconCleaner >> copyIconsInTempThatAreNotInSource [

	self iconsInTempThatAreNotInSource do: [ :each |
		FileSystem / tempTarget / each copyTo:
			FileSystem / (source , each) ]
]

{ #category : 'as yet unclassified' }
IconCleaner >> duplicatesGIconsInSeparateFolder [

	(FileSystem / tempTarget) ensureDeleteAll.
	(FileSystem / tempTarget) ensureCreateDirectory.
	(FileSystem / source) allFiles do: [ :each |
		('glamorous*' match: each basename) ifTrue: [
			each copyTo: FileSystem / (tempTarget , each basename) ] ].

	((FileSystem / tempTarget) allFiles select: [ :each |
		 'glamorous*' match: each basename ]) do: [ :f |
		| g b |
		g := f.
		b := g basename.
		b := b copyFrom: 'glamorous' size + 1 to: b size.
		b := b uncapitalized.
		g renameTo: b ]
]

{ #category : 'as yet unclassified' }
IconCleaner >> iconsInTempThatAreNotInSource [

	
	^ (( FileSystem / tempTarget) allFiles collect: [ :each | each basename ])
		difference: 
	(( FileSystem / source) allFiles collect: [ :each | each basename ])
]

{ #category : 'as yet unclassified' }
IconCleaner >> initialize [

	tempTarget := '/Users/ducasse/Test2/pharo-icon-packs/G/'.
	source := '/Users/ducasse/Test2/pharo-icon-packs/icons/'.

	
]
