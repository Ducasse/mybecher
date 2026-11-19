"
I am a visitor of the `StBaselineElement` tree that prints it back as the source of a `<baseline>` method. The method I print is canonical: in `spec for: #common do: [ ]`, one cascade declaring the projects then the packages, one cascade declaring the groups, names in literal arrays, and the Pharo formatter lays it out. Interpreting it with `ProjectBaseliner` gives the same tree again.

## Life cycle: who creates me and who uses me

1. A client creates me with `BaselinerPrinter new` (`BaselinerPrinter class>>exampleDebuggerCLI`, `BaselinerPrinterTest>>print:`).
2. The client sends `acceptVisitor:` with me to a `StBaseline`, usually `ProjectBaseliner>>baseline`; it sends me `visitBaseline:` and I visit its projects, packages and groups.
3. The client reads `contents`. I print one baseline: use a new printer for another one.

## Responsibility:

- Print the declarations of packages (with their `requires:`), groups and projects (with `repository:` and `loads:`).
- Print references (`requires:`, group members) by name, unresolved ones included, so that a broken baseline prints as it was written.
- Print a project in the baseline's own repository as `self packageRepositoryURLForSpec: spec`.

## Collaborators: 

- `StBaseline`, `StBaselinePackage`, `StBaselineGroup`, `StBaselineProject`, `StBaselineUnresolvedReference`: send me `visitBaseline:`, `visitPackage:`, `visitGroup:`, `visitProject:`, `visitUnresolvedReference:` from `acceptVisitor:`.
- `RBParser` and the Pharo formatter (`formattedCode`): lay out the method I print.

## Public API and Key Messages

- `anElement acceptVisitor: aPrinter` prints anElement.
- `contents` answers the formatted method.

## Examples

```
BaselinerPrinter exampleDebuggerCLI contents.
BaselinerPrinter scriptPrintDebuggerCLI.
```

## Internal Representation

- `stream`: the method source before formatting, written on one line.

### Implementation Points

- I lose what the tree does not keep: temporaries (`| repository |`), brace arrays, the interleaving of projects and packages, comments.
"
Class {
	#name : 'BaselinerPrinter',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'NewTools-ProjectBaseliner-Printer',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Printer'
}

{ #category : 'examples' }
BaselinerPrinter class >> exampleDebuggerCLI [
	"A printer that printed the tree of BaselineOfDebuggerCLI; its contents is the <baseline> method."

	<sampleInstance>
	| printer |
	printer := self new.
	StBaseline exampleDebuggerCLI acceptVisitor: printer.
	^ printer
]

{ #category : 'script' }
BaselinerPrinter class >> scriptPrintDebuggerCLI [
	"Interpret BaselineOfDebuggerCLI, represent it and print it back: inspect the method printed next to the original one."

	<example>
	^ {
		  (BaselineOfDebuggerCLI >> #baseline:) sourceCode.
		  self exampleDebuggerCLI contents } inspect
]

{ #category : 'accessing' }
BaselinerPrinter >> contents [
	"Answer the printed method, formatted by the Pharo formatter."

	^ (RBParser parseMethod: stream contents) formattedCode
]

{ #category : 'initialization' }
BaselinerPrinter >> initialize [

	super initialize.
	stream := WriteStream on: String new
]

{ #category : 'private' }
BaselinerPrinter >> literalArrayOf: names [

	^ String streamContents: [ :aStream |
		  aStream nextPutAll: '#( '.
		  names do: [ :each |
			  aStream
				  print: each asString;
				  space ].
		  aStream nextPut: $) ]
]

{ #category : 'private' }
BaselinerPrinter >> printCascadeOf: elements [

	stream nextPutAll: 'spec '.
	elements do: [ :each | each acceptVisitor: self ] separatedBy: [ stream nextPutAll: '; ' ]
]

{ #category : 'private' }
BaselinerPrinter >> printNamesOf: elements [
	"Print the elements as a literal array of their names, as requires: and group:with: take them."

	stream nextPutAll: (self literalArrayOf: (elements collect: [ :each | each name ]))
]

{ #category : 'private' }
BaselinerPrinter >> repositoryCodeOf: aProject [
	"The baseline's own repository is asked as the baseline does, other repositories are printed as written."

	aProject isInOwnRepository ifTrue: [ ^ '(self packageRepositoryURLForSpec: spec)' ].
	^ aProject repository printString
]

{ #category : 'visiting' }
BaselinerPrinter >> visitBaseline: aBaseline [
	"Print the <baseline> method declaring aBaseline: one statement for its projects and packages, one for its groups."

	| statements |
	statements := OrderedCollection new.
	aBaseline projects , aBaseline packages ifNotEmpty: [ :declarations | statements add: declarations ].
	aBaseline groups ifNotEmpty: [ :groups | statements add: groups ].
	stream nextPutAll: 'baseline: spec <baseline> spec for: #common do: [ '.
	statements do: [ :each | self printCascadeOf: each ] separatedBy: [ stream nextPutAll: '. ' ].
	stream nextPutAll: ' ]'
]

{ #category : 'visiting' }
BaselinerPrinter >> visitGroup: aGroup [

	stream
		nextPutAll: 'group: ';
		print: aGroup name;
		nextPutAll: ' with: '.
	self printNamesOf: aGroup members
]

{ #category : 'visiting' }
BaselinerPrinter >> visitPackage: aPackage [

	stream
		nextPutAll: 'package: ';
		print: aPackage name.
	aPackage requires ifEmpty: [ ^ self ].
	stream nextPutAll: ' with: [ spec requires: '.
	self printNamesOf: aPackage requires.
	stream nextPutAll: ' ]'
]

{ #category : 'visiting' }
BaselinerPrinter >> visitProject: aProject [

	| messages |
	messages := OrderedCollection new.
	aProject repository ifNotNil: [ messages add: 'repository: ' , (self repositoryCodeOf: aProject) ].
	aProject loads ifNotEmpty: [ :loads | messages add: 'loads: ' , (self literalArrayOf: loads) ].
	stream
		nextPutAll: 'baseline: ';
		print: aProject name;
		nextPutAll: ' with: [ '.
	messages ifNotEmpty: [
		stream nextPutAll: 'spec '.
		messages do: [ :each | stream nextPutAll: each ] separatedBy: [ stream nextPutAll: '; ' ] ].
	stream nextPutAll: ' ]'
]

{ #category : 'visiting' }
BaselinerPrinter >> visitUnresolvedReference: aReference [
	"A name the baseline does not declare is printed as it was written."

	stream print: aReference name
]
