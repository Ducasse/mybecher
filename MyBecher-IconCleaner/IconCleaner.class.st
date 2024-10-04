"
To clean icons. 
- First we copy the G icons in a separate folder
- We renamed them.
- We copy back to the source the one with non clashing names. 
- The we remove from the copy the ones that are similar to one with the same name in the source
- We are left with icons with the same name but different contents. 

These ones we have to manually add new names.

```
IconCleaner new
	duplicatesGIconsInSeparateFolder;
	copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource;
	removeIconsWithSimilarContents
```


```
IconCleaner new
	source: '/Users/ducasse/Test2/pharo-icon-packs/png-scale1.0/';
	duplicatesGIconsInSeparateFolder;
	copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource;
	removeIconsWithSimilarContents.
	

IconCleaner new
	source: '/Users/ducasse/Test2/pharo-icon-packs/png-scale1.5/';
	duplicatesGIconsInSeparateFolder;
	copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource;
	removeIconsWithSimilarContents.
	
IconCleaner new
	source: '/Users/ducasse/Test2/pharo-icon-packs/png-scale2.0/';
	duplicatesGIconsInSeparateFolder;
	copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource;
	removeIconsWithSimilarContents.
	
IconCleaner new
	source: '/Users/ducasse/Test2/pharo-icon-packs/svg/';
	duplicatesGIconsInSeparateFolder;
	copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource;
	removeIconsWithSimilarContents.
```
"
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

{ #category : 'copying' }
IconCleaner >> copyIconsFromTempToSourceButOnlyThoseThatAreNotInSource [

	self iconsInTempThatAreNotInSource do: [ :each |
		FileSystem / tempTarget / each copyTo:
			FileSystem / (source , each) ]
]

{ #category : 'initialization' }
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

{ #category : 'queries' }
IconCleaner >> iconsInTempThatAreNotInSource [

	
	^ (( FileSystem / tempTarget) allFiles collect: [ :each | each basename ])
		difference: 
	(( FileSystem / source) allFiles collect: [ :each | each basename ])
]

{ #category : 'queries' }
IconCleaner >> iconsWithSimilarContents [
	"once renamed now check the ones that have the same name."

	^ self iconsWithSimilarNames select: [ :n |
		
		 ((FileSystem / tempTarget / n) binaryReadStream contents) =  ((FileSystem / source / n) binaryReadStream contents)
		 ]
]

{ #category : 'queries' }
IconCleaner >> iconsWithSimilarNames [
	"once renamed now check the ones that have the same name."

	^ ((FileSystem / tempTarget) allFiles collect: [ :each |
		   each basename ]) intersection:
		  ((FileSystem / source) allFiles collect: [ :each | each basename ])
]

{ #category : 'initialization' }
IconCleaner >> initialize [

	tempTarget := '/Users/ducasse/Test2/pharo-icon-packs/G/'.
	source := '/Users/ducasse/Test2/pharo-icon-packs/icons/'.

	
]

{ #category : 'operations' }
IconCleaner >> removeIconsWithSimilarContents [

	self iconsWithSimilarContents do: [ :each | (FileSystem / tempTarget / each ) delete ]
]

{ #category : 'initialization' }
IconCleaner >> source: aString [

	source := aString
]
