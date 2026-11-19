"
I test `BaselinerPrinter`: the method it prints for a `StBaseline`, compared with an expected method once both are formatted, and the round trip print, interpret, represent, print.
"
Class {
	#name : 'BaselinerPrinterTest',
	#superclass : 'ProjectBaselinerAbstractTest',
	#category : 'NewTools-ProjectBaseliner-Tests',
	#package : 'NewTools-ProjectBaseliner-Tests'
}

{ #category : 'helpers' }
BaselinerPrinterTest >> assertPrinting: aBaselineBody gives: anExpectedMethodSource [

	self assert: (self formatted: (self printBody: aBaselineBody)) equals: (self formatted: anExpectedMethodSource)
]

{ #category : 'helpers' }
BaselinerPrinterTest >> formatted: aMethodSource [

	^ (RBParser parseMethod: aMethodSource) formattedCode
]

{ #category : 'helpers' }
BaselinerPrinterTest >> print: aBaseline [

	| printer |
	printer := BaselinerPrinter new.
	aBaseline acceptVisitor: printer.
	^ printer contents
]

{ #category : 'helpers' }
BaselinerPrinterTest >> printBody: aBaselineBody [
	"Answer the method printed for the tree of a fixture whose baseline: method has aBaselineBody as body."

	^ self print: (self represent: aBaselineBody)
]

{ #category : 'helpers' }
BaselinerPrinterTest >> roundTrip: aMethodSource [
	"Answer the method printed for the tree of a fixture whose only method is aMethodSource."

	^ self print: (self interpretMethod: aMethodSource) baseline
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testDebuggerCLI [

	self assert: (self print: StBaseline exampleDebuggerCLI) equals: (self formatted: 'baseline: spec

	<baseline>
	spec for: #common do: [
		spec
			baseline: ''Debugging'' with: [
				spec
					repository: (self packageRepositoryURLForSpec: spec);
					loads: #( ''Debugger-Model'' ) ];
			package: ''Debugger-CLI'' with: [ spec requires: #( ''Debugging'' ) ];
			package: ''Debugger-CLI-Tests'' with: [ spec requires: #( ''Debugger-CLI'' ''Debugging'' ) ].
		spec
			group: ''Core'' with: #( ''Debugger-CLI'' );
			group: ''Tests'' with: #( ''Debugger-CLI-Tests'' ) ]')
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testEmptyBaseline [

	self assertPrinting: 'spec for: #common do: [ ]' gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testGroups [

	self
		assertPrinting: 'spec for: #common do: [ spec group: ''Core'' with: #( ''Tests'' ); group: ''Tests'' with: #( ) ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			group: ''Core'' with: #( ''Tests'' );
			group: ''Tests'' with: #( ) ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testNameWithAQuoteIsEscaped [

	self assertPrinting: 'spec for: #common do: [ spec package: ''It''''s'' ]' gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec package: ''It''''s'' ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testPackageRequiringSeveralElements [

	self
		assertPrinting:
		'spec for: #common do: [ spec package: ''A''; package: ''B''; package: ''C'' with: [ spec requires: #( ''A'' ''B'' ) ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'';
			package: ''C'' with: [ spec requires: #( ''A'' ''B'' ) ] ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testPackageWithRequires [

	self
		assertPrinting: 'spec for: #common do: [ spec package: ''A''; package: ''B'' with: [ spec requires: #( ''A'' ) ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'' with: [ spec requires: #( ''A'' ) ] ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testPackagesAndGroupsAreTwoStatements [

	self assertPrinting: 'spec for: #common do: [ spec package: ''A''; group: ''Core'' with: { ''A'' } ]' gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec package: ''A''.
		spec group: ''Core'' with: #( ''A'' ) ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testPrintPackageWithoutRequires [

	self assertPrinting: 'spec for: #common do: [ spec package: ''A'' ]' gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec package: ''A'' ]'
]

{ #category : 'tests - projects' }
BaselinerPrinterTest >> testPrintProjectWithRepositoryAndLoads [

	self
		assertPrinting: 'spec for: #common do: [ spec baseline: ''P'' with: [ spec repository: ''github://x/y''; loads: ''X'' ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec baseline: ''P'' with: [
			spec
				repository: ''github://x/y'';
				loads: #( ''X'' ) ] ]'
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testPrintedMethodIsFormatted [

	| printed |
	printed := self print: StBaseline exampleDebuggerCLI.
	self assert: printed equals: (self formatted: printed)
]

{ #category : 'tests - projects' }
BaselinerPrinterTest >> testProjectInOwnRepository [

	self
		assertPrinting: '| repository |
	repository := self packageRepositoryURLForSpec: spec.
	spec for: #common do: [ spec baseline: ''P'' with: [ spec repository: repository ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec baseline: ''P'' with: [ spec repository: (self packageRepositoryURLForSpec: spec) ] ]'
]

{ #category : 'tests - projects' }
BaselinerPrinterTest >> testProjectWithRepository [

	self
		assertPrinting: 'spec for: #common do: [ spec baseline: ''P'' with: [ spec repository: ''github://x/y'' ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec baseline: ''P'' with: [ spec repository: ''github://x/y'' ] ]'
]

{ #category : 'tests - projects' }
BaselinerPrinterTest >> testProjectWithoutRepository [

	self assertPrinting: 'spec for: #common do: [ spec baseline: ''P'' with: [ ] ]' gives: 'baseline: spec
	<baseline>
	spec for: #common do: [ spec baseline: ''P'' with: [ ] ]'
]

{ #category : 'tests - projects' }
BaselinerPrinterTest >> testProjectsArePrintedBeforePackages [

	self
		assertPrinting: 'spec for: #common do: [
		spec package: ''A'' with: [ spec requires: #( ''P'' ) ].
		spec baseline: ''P'' with: [ spec repository: ''github://x/y'' ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			baseline: ''P'' with: [ spec repository: ''github://x/y'' ];
			package: ''A'' with: [ spec requires: #( ''P'' ) ] ]'
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testRoundTripKeepsTheTree [

	| original again |
	original := StBaseline exampleDebuggerCLI.
	again := (self interpretMethod: (self print: original)) baseline.
	self assert: (self namesOf: again packages) equals: (self namesOf: original packages).
	self assert: (self namesOf: again groups) equals: (self namesOf: original groups).
	self assert: (self namesOf: again projects) equals: (self namesOf: original projects).
	self
		assert: (self namesOf: (again packageNamed: 'Debugger-CLI-Tests') requires)
		equals: (self namesOf: (original packageNamed: 'Debugger-CLI-Tests') requires).
	self assert: (again projectNamed: 'Debugging') isInOwnRepository.
	self assert: (again projectNamed: 'Debugging') loads equals: #( 'Debugger-Model' )
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testRoundTripKeepsUnresolvedReferences [

	| again |
	again := (self interpretMethod:
		          (self printBody: 'spec for: #common do: [ spec package: ''A'' with: [ spec requires: #( ''Missing'' ) ] ]')) baseline.
	self assert: (self namesOf: again unresolvedReferences) equals: #( 'Missing' )
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testRoundTripOfDebuggerCLIIsStable [

	| printed |
	printed := self print: StBaseline exampleDebuggerCLI.
	self assert: (self roundTrip: printed) equals: printed
]

{ #category : 'tests - round trip' }
BaselinerPrinterTest >> testRoundTripOfEveryBaselineOfTheImageIsStable [
	"Printing the tree of a baseline, interpreting the printed method and printing again gives the same method."

	BaselineOf allSubclasses do: [ :each |
		| printed |
		printed := self print: (ProjectBaseliner new
			            interpret: each;
			            represent;
			            baseline).
		self assert: (self roundTrip: printed) = printed description: [ each name ] ]
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testSymbolNamesArePrintedAsStrings [

	self
		assertPrinting: 'spec for: #common do: [ spec package: #A; package: #B with: [ spec requires: #( #A ) ] ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec
			package: ''A'';
			package: ''B'' with: [ spec requires: #( ''A'' ) ] ]'
]

{ #category : 'tests - packages and groups' }
BaselinerPrinterTest >> testUnresolvedReferencesArePrintedByName [

	self
		assertPrinting:
		'spec for: #common do: [ spec package: ''A'' with: [ spec requires: #( ''Missing'' ) ]; group: ''Core'' with: #( ''Other'' ) ]'
		gives: 'baseline: spec
	<baseline>
	spec for: #common do: [
		spec package: ''A'' with: [ spec requires: #( ''Missing'' ) ].
		spec group: ''Core'' with: #( ''Other'' ) ]'
]
