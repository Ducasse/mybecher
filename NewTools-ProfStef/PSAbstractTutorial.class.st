"
Parent class of all Pharo tutorials.

To create your own tutorial:
- subclass `AbstractTutorial`
- implement a few methods which returns an instance of `Lesson`
- implement the method #tutorial which returns a collection of selectors that when executed create related lessons.

For example, see `MockTutorial` (minimalist) and `PharoySyntaxTutorial` (default PharoTutorial one).

See the `PharoTutorial` class comment to execute your own tutorial.
"
Class {
	#name : 'PSAbstractTutorial',
	#superclass : 'Object',
	#category : 'NewTools-ProfStef',
	#package : 'NewTools-ProfStef'
}

{ #category : 'tutorial metainfo' }
PSAbstractTutorial class >> contentsOfTutorials [
	^ String
		streamContents: [ :aStream |
			self tutorials
				do: [ :aTutorial |
					aStream
						nextPutAll: aTutorial title;
						cr;
						tab;
						nextPutAll: 'ProfStef goOn: ';
						nextPutAll: aTutorial name;
						cr;
						cr ] ]
]

{ #category : 'tutorial metainfo' }
PSAbstractTutorial class >> title [
	"Return the title of the tutorial by parsing the class name
	like a Wiki link and interspersing whitespaces between the tokens"
	| className separators groups |

	className := self name.
	separators := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.
	groups := className findTokens: separators keep: separators.
	^' ' join: (groups pairsCollect: [ :sep :rest | sep , rest ])
]

{ #category : 'tutorial metainfo' }
PSAbstractTutorial class >> tutorials [

	^ (self subclasses sort: [ :a :b | a name < b name ]) reject: [ :aTutorial | aTutorial package name = 'ProfStef-Tests' ]
]

{ #category : 'tutorial' }
PSAbstractTutorial >> indexOfLesson: aSelector [
	^self tutorial indexOf: aSelector
]

{ #category : 'tutorial' }
PSAbstractTutorial >> lessonAt: anInteger [
	| lessonSelector |
	lessonSelector := self tutorial at: anInteger.
	^ self perform: lessonSelector
]

{ #category : 'accessing' }
PSAbstractTutorial >> lessons [
	^ self tutorial collect: [:aSelector| self perform: aSelector]
]

{ #category : 'printing' }
PSAbstractTutorial >> printOn: aStream [
	aStream
		nextPutAll: 'a Pharo Tutorial (';
		nextPutAll: self class title;
		nextPutAll: ')'
]

{ #category : 'accessing' }
PSAbstractTutorial >> size [
	^ self tutorial size
]

{ #category : 'tutorial' }
PSAbstractTutorial >> tutorial [
	"Should return an Array of selectors which returns Lesson instances.
	See PharoSyntaxTutorial."
	
	^ self shouldBeImplemented
]
