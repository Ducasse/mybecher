"
I test `ProjectBaseliner` and the `StBaselineElement` tree it builds.

Each test interprets a small fixture: a `BaselineOf` subclass built with the class builder in a private `SystemEnvironment`, never installed, with methods compiled without logging, so tests leave no trace in the image. `testEveryBaselineOfTheImageIsRepresented` runs over every `BaselineOf` of the image.
"
Class {
	#name : 'ProjectBaselinerTest',
	#superclass : 'ProjectBaselinerAbstractTest',
	#category : 'NewTools-ProjectBaseliner-Tests',
	#package : 'NewTools-ProjectBaseliner-Tests'
}

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testBaselineIsNilBeforeRepresent [

	| baseliner |
	baseliner := ProjectBaseliner new.
	baseliner interpret: (self baselineClassWithMethod: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec package: ''A'' ]').
	self assert: baseliner baseline isNil
]

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testBaselineMethodIsFoundByItsPragma [

	| class baseliner |
	class := self baselineClassWithMethod: 'defineOn: spec
	<baseline>
	spec for: #common do: [ spec package: ''A'' ]'.
	class
		compile: 'baseline: spec
	spec for: #common do: [ spec package: ''NotThisOne'' ]'
		classified: #baselines
		withStamp: nil
		logSource: false.
	baseliner := ProjectBaseliner new.
	baseliner
		interpret: class;
		represent.
	self assert: (self namesOf: baseliner baseline packages) equals: #( 'A' )
]

{ #category : 'tests - platforms' }
ProjectBaselinerTest >> testCommonPlatformBlockIsEvaluated [

	self assert: (self namesOf: (self represent: 'spec for: #common do: [ spec package: ''A'' ]') packages) equals: #( 'A' )
]

{ #category : 'tests - errors' }
ProjectBaselinerTest >> testErrorInTheBaselineMethodIsRecorded [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [ spec package: ''A''. Error signal: ''boom'' ]'.
	self assert: baseliner interpretationError messageText equals: 'boom'
]

{ #category : 'tests - errors' }
ProjectBaselinerTest >> testErrorInTheBaselineMethodKeepsWhatWasRecordedBefore [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [ spec package: ''A''. Error signal: ''boom''. spec package: ''B'' ]'.
	self assert: (self namesOf: baseliner baseline packages) equals: #( 'A' )
]

{ #category : 'tests - system' }
ProjectBaselinerTest >> testEveryBaselineOfTheImageIsRepresented [
	"Smoke test: every BaselineOf of the image is interpreted without error and represented as a named tree."

	BaselineOf allSubclasses do: [ :each |
		| baseliner |
		baseliner := ProjectBaseliner new.
		baseliner
			interpret: each;
			represent.
		self assert: baseliner interpretationError isNil description: [
			'{1}: {2}' format: {
				each name.
				baseliner interpretationError description } ].
		self assert: baseliner baseline name equals: (each name allButFirst: 'BaselineOf' size) ]
]

{ #category : 'tests - examples' }
ProjectBaselinerTest >> testExampleDebuggerCLI [

	| baseline |
	baseline := ProjectBaseliner exampleDebuggerCLI baseline.
	self assert: baseline name equals: 'DebuggerCLI'.
	self assert: (self namesOf: baseline packages) equals: #( 'Debugger-CLI' 'Debugger-CLI-Tests' ).
	self assert: (self namesOf: baseline groups) equals: #( 'Core' 'Tests' ).
	self assert: (baseline packageNamed: 'Debugger-CLI') requires asArray equals: { (baseline projectNamed: 'Debugging') }.
	self assert: (baseline groupNamed: 'Tests') members asArray equals: { (baseline packageNamed: 'Debugger-CLI-Tests') }.
	self assert: (baseline projectNamed: 'Debugging') isInOwnRepository.
	self assert: (baseline projectNamed: 'Debugging') loads equals: #( 'Debugger-Model' )
]

{ #category : 'tests - examples' }
ProjectBaselinerTest >> testExampleDebuggerCLIHasNothingUnsupported [

	self assert: ProjectBaseliner exampleDebuggerCLI unsupportedAPI isEmpty
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testExplicitRepositoryIsNotOwnRepository [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''Refactoring'' with: [ spec repository: ''github://x/y'' ] ]') projectNamed: 'Refactoring'.
	self deny: project isInOwnRepository
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testForwardReferenceIsResolved [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''B'' with: [ spec requires: #( ''A'' ) ];
			package: ''A'' ]'.
	self assert: (baseline packageNamed: 'B') requires asArray equals: { (baseline packageNamed: 'A') }
]

{ #category : 'tests - groups' }
ProjectBaselinerTest >> testGroupMemberCanBeAGroupDeclaredLater [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			group: ''all'' with: #( ''Core'' );
			group: ''Core'' with: #( ''A'' ) ]'.
	self assert: (baseline groupNamed: 'all') members asArray equals: { (baseline groupNamed: 'Core') }
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testGroupMemberCanBeAProject [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			baseline: ''Debugging'' with: [ spec repository: ''github://x/y'' ];
			group: ''Core'' with: #( ''Debugging'' ) ]'.
	self assert: (baseline groupNamed: 'Core') members asArray equals: { (baseline projectNamed: 'Debugging') }
]

{ #category : 'tests - groups' }
ProjectBaselinerTest >> testGroupMembersAreResolvedToPackages [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'';
			group: ''Core'' with: #( ''A'' ''B'' ) ]'.
	self assert: (baseline groupNamed: 'Core') members asArray equals: {
		(baseline packageNamed: 'A').
		(baseline packageNamed: 'B') }
]

{ #category : 'tests - groups' }
ProjectBaselinerTest >> testGroupMembersGivenAsBraceArrayAreResolved [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			group: ''Core'' with: { ''A'' } ]'.
	self assert: (baseline groupNamed: 'Core') members asArray equals: { (baseline packageNamed: 'A') }
]

{ #category : 'tests - groups' }
ProjectBaselinerTest >> testGroupsKeepTheirDeclarationOrder [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			group: ''Tests'' with: #( ''A'' );
			group: ''Core'' with: #( ''A'' ) ]'.
	self assert: (self namesOf: baseline groups) equals: #( 'Tests' 'Core' )
]

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testHelperMethodsOfTheBaselineAreFollowed [

	| class baseliner |
	class := self baselineClassWithMethod: 'baseline: spec
	<baseline>
	spec for: #common do: [ self definePackagesOn: spec ]'.
	class
		compile: 'definePackagesOn: spec
	spec package: ''A'''
		classified: #baselines
		withStamp: nil
		logSource: false.
	baseliner := ProjectBaseliner new.
	baseliner
		interpret: class;
		represent.
	self assert: (self namesOf: baseliner baseline packages) equals: #( 'A' )
]

{ #category : 'tests - errors' }
ProjectBaselinerTest >> testInterpretClassWithoutBaselinePragmaRaisesError [

	| class |
	class := self baselineClassWithMethod: 'baseline: spec
	spec for: #common do: [ spec package: ''A'' ]'.
	self should: [ ProjectBaseliner new interpret: class ] raise: NotFound
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testLoadsGivenAsAStringIsACollection [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''SUnit'' with: [ spec repository: ''github://x/y''; loads: ''SUnit-Core'' ] ]') projectNamed: 'SUnit'.
	self assert: project loads asArray equals: #( 'SUnit-Core' )
]

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testManualInterpretationHasNoName [

	| baseliner |
	baseliner := ProjectBaseliner new.
	(self baselineClassWithMethod: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec package: ''A'' ]') new baseline: baseliner.
	baseliner represent.
	self assert: baseliner baseline name isNil.
	self assert: (self namesOf: baseliner baseline packages) equals: #( 'A' )
]

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testNameCanBeSet [

	| baseliner |
	baseliner := ProjectBaseliner new.
	baseliner name: 'Manual'.
	(self baselineClassWithMethod: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec package: ''A'' ]') new baseline: baseliner.
	baseliner represent.
	self assert: baseliner baseline name equals: 'Manual'
]

{ #category : 'tests - interpreting' }
ProjectBaselinerTest >> testNameIsTakenFromTheClassName [

	self assert: (self represent: 'spec for: #common do: [ spec package: ''A'' ]') name equals: 'Fixture'
]

{ #category : 'tests - errors' }
ProjectBaselinerTest >> testNoErrorMeansNoInterpretationError [

	self assert: (self interpret: 'spec for: #common do: [ spec package: ''A'' ]') interpretationError isNil
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testNotUnderstoodMessageDoesNotStopTheCascade [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [
		spec
			preLoadDoIt: #prepare;
			package: ''A'' ]'.
	self assert: (self namesOf: baseliner baseline packages) equals: #( 'A' )
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testNotUnderstoodMessageInsideAPackageBlockIsRecorded [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [
		spec package: ''A'' with: [ spec includes: #( ''B'' ) ] ]'.
	self assert: (baseliner unsupportedAPI collect: [ :each | each selector ] as: Array) equals: #( #includes: )
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testNotUnderstoodMessageIsRecorded [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [ spec blessing: #baseline ]'.
	self assert: baseliner unsupportedAPI size equals: 1.
	self assert: baseliner unsupportedAPI first selector equals: #blessing:.
	self assert: baseliner unsupportedAPI first arguments equals: #( #baseline )
]

{ #category : 'tests - platforms' }
ProjectBaselinerTest >> testOtherPlatformBlockIsNotEvaluated [

	| baseline |
	baseline := self represent: 'spec for: #common do: [ spec package: ''A'' ].
	spec for: #''pharo11.x'' do: [ spec package: ''OnlyOnPharo11'' ]'.
	self assert: (self namesOf: baseline packages) equals: #( 'A' )
]

{ #category : 'tests - platforms' }
ProjectBaselinerTest >> testOtherPlatformIsRecordedAsUnsupported [

	| baseliner |
	baseliner := self interpret: 'spec for: #''pharo11.x'' do: [ spec package: ''OnlyOnPharo11'' ]'.
	self assert: baseliner unsupportedAPI size equals: 1.
	self assert: baseliner unsupportedAPI first selector equals: #for:do:.
	self assert: baseliner unsupportedAPI first arguments first equals: #'pharo11.x'
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testOwnRepositoryAskedBeforeForCommon [

	| project |
	project := (self represent: '| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [
		spec baseline: ''Refactoring'' with: [ spec repository: repository ] ]') projectNamed: 'Refactoring'.
	self assert: project isInOwnRepository
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testOwnRepositoryAskedInsideProject [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''Refactoring'' with: [ spec repository: (self packageRepositoryURLForSpec: spec) ] ]') projectNamed:
		           'Refactoring'.
	self assert: project isInOwnRepository
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testOwnRepositoryCheckedByAnOverrideIsOwnRepository [
	"As BaselineOfNewTools>>packageRepositoryURLForSpec: does, an override may test the description before answering it."

	| class project |
	class := self baselineClassWithMethod: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec baseline: ''Chest'' with: [ spec repository: (self packageRepositoryURLForSpec: spec) ] ]'.
	class
		compile: 'packageRepositoryURLForSpec: spec
	| url |
	url := super packageRepositoryURLForSpec: spec.
	url ifEmpty: [ ^ url ].
	((url includesSubstring: ''pharo-spec'') or: [ url beginsWith: ''tonel:///home/runner/'' ]) ifTrue: [ ^ '''' ].
	^ url'
		classified: #accessing
		withStamp: nil
		logSource: false.
	project := (ProjectBaseliner new
		            interpret: class;
		            represent;
		            baseline) projectNamed: 'Chest'.
	self assert: project isInOwnRepository
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testOwnRepositoryWithFallbackIsOwnRepository [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''Spec2'' with: [
			spec repository: ((self packageRepositoryURLForSpec: spec) ifEmpty: [ ''github://pharo-spec/Spec'' ]) ] ]') projectNamed:
		           'Spec2'.
	self assert: project isInOwnRepository
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testPackageDeclaredTwiceIsMerged [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'';
			package: ''C'' with: [ spec requires: #( ''A'' ) ];
			package: ''C'' with: [ spec requires: #( ''B'' ) ] ]'.
	self assert: baseline packages size equals: 3.
	self assert: (baseline packageNamed: 'C') requires asArray equals: {
		(baseline packageNamed: 'A').
		(baseline packageNamed: 'B') }
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testPackageRequiresAProject [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			baseline: ''Debugging'' with: [ spec repository: ''github://x/y'' ];
			package: ''Debugger-CLI'' with: [ spec requires: #( ''Debugging'' ) ] ]'.
	self assert: (baseline packageNamed: 'Debugger-CLI') requires asArray equals: { (baseline projectNamed: 'Debugging') }
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testPackageRequiresAnotherPackage [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'' with: [ spec requires: #( ''A'' ) ] ]'.
	self assert: (baseline packageNamed: 'B') requires asArray equals: { (baseline packageNamed: 'A') }
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testPackageWithoutRequires [

	| baseline |
	baseline := self represent: 'spec for: #common do: [ spec package: ''A'' ]'.
	self assert: (self namesOf: baseline packages) equals: #( 'A' ).
	self assert: (baseline packageNamed: 'A') requires isEmpty
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testPackagesKeepTheirDeclarationOrder [

	| baseline |
	baseline := self represent: 'spec for: #common do: [ spec package: ''C''; package: ''A''; package: ''B'' ]'.
	self assert: (self namesOf: baseline packages) equals: #( 'C' 'A' 'B' )
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testProjectWithRepositoryAndLoads [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''Debugging'' with: [
			spec
				repository: ''github://pharo-project/pharo:Pharo13/src'';
				loads: #( ''Debugger-Model'' ) ] ]') projectNamed: 'Debugging'.
	self assert: project repository equals: 'github://pharo-project/pharo:Pharo13/src'.
	self assert: project loads asArray equals: #( 'Debugger-Model' )
]

{ #category : 'tests - projects' }
ProjectBaselinerTest >> testProjectWithoutLoadsHasEmptyLoads [

	| project |
	project := (self represent: 'spec for: #common do: [
		spec baseline: ''Refactoring'' with: [ spec repository: ''github://x/y'' ] ]') projectNamed: 'Refactoring'.
	self assert: project loads isEmpty
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testRepositoryOutsideAProjectIsUnsupported [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [ spec repository: ''github://x/y'' ]'.
	self assert: (baseliner unsupportedAPI collect: [ :each | each selector ] as: Array) equals: #( #repository: )
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testRequiresOutsideAPackageIsUnsupported [

	| baseliner |
	baseliner := self interpret: 'spec for: #common do: [ spec requires: #( ''A'' ) ]'.
	self assert: (baseliner unsupportedAPI collect: [ :each | each selector ] as: Array) equals: #( #requires: )
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testResolvedBaselineHasNoUnresolvedReferences [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'' with: [ spec requires: #( ''A'' ) ];
			group: ''Core'' with: #( ''A'' ''B'' ) ]'.
	self assert: baseline unresolvedReferences isEmpty
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testResolvedNodesAreNotUnresolved [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'';
			baseline: ''P'' with: [ spec repository: ''github://x/y'' ];
			group: ''Core'' with: #( ''A'' ''P'' ) ]'.
	self deny: ((baseline groupNamed: 'Core') members anySatisfy: [ :each | each isUnresolved ]).
	self deny: (baseline groupNamed: 'Core') isUnresolved
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testSameMissingNameSharesOnePlaceholder [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'' with: [ spec requires: #( ''Missing'' ) ];
			group: ''Core'' with: #( ''Missing'' ) ]'.
	self assert: (baseline packageNamed: 'A') requires first identicalTo: (baseline groupNamed: 'Core') members first
]

{ #category : 'tests - unsupported' }
ProjectBaselinerTest >> testSupportedMessagesAreNotUnsupported [

	| baseliner |
	baseliner := self interpret: '| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [
		spec
			baseline: ''P'' with: [ spec repository: repository; loads: #( ''X'' ) ];
			package: ''A'';
			package: ''B'' with: [ spec requires: #( ''A'' ''P'' ) ];
			group: ''Core'' with: #( ''A'' ) ]'.
	self assert: baseliner unsupportedAPI isEmpty
]

{ #category : 'tests - packages' }
ProjectBaselinerTest >> testSymbolNamesAreNormalisedToStrings [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: #''A'';
			package: #''B'' with: [ spec requires: #( #''A'' ) ] ]'.
	self assert: ((baseline packages collect: [ :each | each name class ]) allSatisfy: [ :each | each == ByteString ]).
	self assert: (baseline packageNamed: 'B') requires asArray equals: { (baseline packageNamed: 'A') }
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testUnresolvedGroupMemberIsAPlaceholder [

	| group |
	group := (self represent: 'spec for: #common do: [
		spec group: ''Core'' with: #( ''Missing'' ) ]') groupNamed: 'Core'.
	self assert: group members first isUnresolved.
	self assert: group members first name equals: 'Missing'
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testUnresolvedReferencesAreListedOncePerName [

	| baseline |
	baseline := self represent: 'spec for: #common do: [
		spec
			package: ''A'' with: [ spec requires: #( ''Missing'' ''Other'' ) ];
			group: ''Core'' with: #( ''A'' ''Missing'' ) ]'.
	self assert: (self namesOf: baseline unresolvedReferences) asSet equals: #( 'Missing' 'Other' ) asSet.
	self assert: baseline unresolvedReferences size equals: 2
]

{ #category : 'tests - unresolved' }
ProjectBaselinerTest >> testUnresolvedRequiresIsAPlaceholder [

	| required |
	required := (self represent: 'spec for: #common do: [
		spec package: ''A'' with: [ spec requires: #( ''Missing'' ) ] ]') packageNamed: 'A'.
	self assert: required requires size equals: 1.
	self assert: required requires first isUnresolved.
	self assert: required requires first name equals: 'Missing'
]
