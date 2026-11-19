"
I hold what the tests of `ProjectBaseliner` and `BaselinerPrinter` share: fixtures that are `BaselineOf` subclasses built with the class builder in a private `SystemEnvironment`, never installed, with methods compiled without logging, so tests leave no trace in the image.
"
Class {
	#name : 'ProjectBaselinerAbstractTest',
	#superclass : 'TestCase',
	#instVars : [
		'environment'
	],
	#category : 'NewTools-ProjectBaseliner-Tests',
	#package : 'NewTools-ProjectBaseliner-Tests'
}

{ #category : 'testing' }
ProjectBaselinerAbstractTest class >> isAbstract [

	^ self == ProjectBaselinerAbstractTest
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> baselineClassNamed: aSymbol withMethod: aSource [
	"Answer a BaselineOf subclass built in the private environment, never installed, whose only method is aSource."

	| class |
	class := (BaselineOf << aSymbol)
		         environment: environment;
		         build.
	class
		compile: aSource
		classified: #baselines
		withStamp: nil
		logSource: false.
	^ class
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> baselineClassWithMethod: aSource [

	^ self baselineClassNamed: #BaselineOfFixture withMethod: aSource
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> interpret: aBaselineBody [
	"Answer a baseliner that interpreted and represented a fixture whose baseline: method has aBaselineBody as body."

	^ self interpretMethod: 'baseline: spec
	<baseline>
	' , aBaselineBody
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> interpretMethod: aSource [

	^ ProjectBaseliner new
		  interpret: (self baselineClassWithMethod: aSource);
		  represent;
		  yourself
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> namesOf: aCollection [

	^ aCollection collect: [ :each | each name ] as: Array
]

{ #category : 'helpers' }
ProjectBaselinerAbstractTest >> represent: aBaselineBody [

	^ (self interpret: aBaselineBody) baseline
]

{ #category : 'running' }
ProjectBaselinerAbstractTest >> setUp [

	super setUp.
	environment := SystemEnvironment new.
	environment codeChangeAnnouncer: Announcer new.
	environment
		at: #BaselineOf put: BaselineOf;
		at: #FixedLayout put: FixedLayout;
		at: #Error put: Error
]
