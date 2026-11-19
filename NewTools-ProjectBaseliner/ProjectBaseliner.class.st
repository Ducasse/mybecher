"
I interpret the method of a `BaselineOf` tagged `<baseline>` and represent what it declares as a tree of `StBaselineElement`s rooted in a `StBaseline`. The baseline method runs with me as its `spec` argument: I record the packages, groups and projects it declares, and I collect the messages I do not support, so that running me over every baseline of the image tells what we miss.

## Life cycle: who creates me and who uses me

1. A client creates me with `ProjectBaseliner new` (`ProjectBaseliner class>>exampleDebuggerCLI`, `ProjectBaselinerTest`).
2. `interpret:` finds the method tagged `<baseline>` of a `BaselineOf` class, takes my name from the class name, and executes the method on a new instance with me as `spec`. The method sends me `for:do:`, `package:`, `package:with:`, `requires:`, `group:with:`, `baseline:with:`, `repository:`, `loads:` and `repositoryDescriptions`. Sending `baseline:` to the `BaselineOf` instance by hand records the same way, without a name.
3. `represent` builds the `StBaseline` from what was recorded and links `requires:` and group members to their elements.
4. The client reads `baseline`, `unsupportedAPI` and `interpretationError`.

## Responsibility:

- Record what a baseline method declares, merging packages and groups declared several times.
- Collect what I do not support: messages I do not understand, platforms other than `#common` (their block is not evaluated), `requires:` outside a package, `repository:` and `loads:` outside a project. An error stops the interpretation and is kept.
- Build the linked `StBaseline` tree, with one `StBaselineUnresolvedReference` per name the baseline uses but does not declare.

## Collaborators: 

- `BaselineOf`: the class whose `<baseline>` method I execute; `BaselineOf>>packageRepositoryURLForSpec:` asks me `repositoryDescriptions`.
- `StBaselineOwnRepository`: what I answer in `repositoryDescriptions`, so that a project in the baseline's own repository is recorded as such.
- `StBaseline`, `StBaselinePackage`, `StBaselineGroup`, `StBaselineProject`, `StBaselineUnresolvedReference`: the tree I build.

## Public API and Key Messages

- `interpret: aBaselineClass` executes its `<baseline>` method with me as spec.
- `represent` builds the tree; `baseline` answers it (nil before `represent`).
- `unsupportedAPI` answers the `Message`s I did not support, `interpretationError` the error that stopped the interpretation.
- `name:` names the baseline when it is not interpreted through `interpret:`.

## Examples

```
ProjectBaseliner exampleDebuggerCLI.
ProjectBaseliner scriptUnsupportedAPIReport.
```

## Internal Representation

- `packages`: package name -> names it requires; `groups`: group name -> member names; `projects`: project name -> `StBaselineProject`. All are `OrderedDictionary`s, to keep the declaration order.
- `current`: `#package -> name` or `#project -> name`, the element `requires:`, `repository:` and `loads:` apply to while a `with:` block runs.

### Implementation Points

- `doesNotUnderstand:` records the message and answers me, so that cascades go on. Beware: any message I do not understand, even from a tool, is recorded instead of raising an error.
- Names are converted to strings: baselines mix symbols and strings.
"
Class {
	#name : 'ProjectBaseliner',
	#superclass : 'Object',
	#instVars : [
		'name',
		'packages',
		'groups',
		'projects',
		'current',
		'unsupportedAPI',
		'interpretationError',
		'baseline'
	],
	#category : 'NewTools-ProjectBaseliner-Interpreter',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Interpreter'
}

{ #category : 'examples' }
ProjectBaseliner class >> exampleDebuggerCLI [
	"A baseliner that interpreted and represented BaselineOfDebuggerCLI: two packages, one project in its own repository, groups Core and Tests."

	<sampleInstance>
	^ self new
		  interpret: BaselineOfDebuggerCLI;
		  represent;
		  yourself
]

{ #category : 'private - demo' }
ProjectBaseliner class >> reportKeyOf: aMessage [
	"Answer the selector of aMessage, with the platform for for:do:, as the unsupported API reports group them."

	aMessage selector = #for:do: ifFalse: [ ^ aMessage selector ].
	^ 'for: {1} do:' format: { aMessage arguments first printString }
]

{ #category : 'script' }
ProjectBaseliner class >> scriptUnsupportedAPIReport [
	"Interpret every BaselineOf of the image and inspect what we miss: for each unsupported selector (each platform for for:do:), the baselines that use it, most used first."

	<example>
	| report |
	report := Dictionary new.
	BaselineOf allSubclasses do: [ :baselineClass |
		(self new interpret: baselineClass) unsupportedAPI do: [ :message |
			(report at: (self reportKeyOf: message) ifAbsentPut: [ Set new ]) add: baselineClass name ] ].
	^ (report associations sort: [ :a :b | a value size > b value size ]) inspect
]

{ #category : 'accessing' }
ProjectBaseliner >> baseline [
	"Answer the StBaseline built by represent, nil before."

	^ baseline
]

{ #category : 'spec' }
ProjectBaseliner >> baseline: aName with: aBlock [

	projects at: aName asString ifAbsentPut: [ StBaselineProject named: aName asString ].
	self within: #project -> aName asString do: aBlock
]

{ #category : 'reflective operations' }
ProjectBaseliner >> doesNotUnderstand: aMessage [
	"Record what a baseline asks and I do not support, and answer myself so that cascades go on."

	self recordUnsupported: aMessage
]

{ #category : 'spec' }
ProjectBaseliner >> for: aPlatform do: aBlock [
	"Only #common is supported: the block of another platform is not evaluated."

	aPlatform = #common ifFalse: [
		^ self recordUnsupported: (Message selector: #for:do: arguments: {
			   aPlatform.
			   aBlock }) ].
	aBlock value
]

{ #category : 'spec' }
ProjectBaseliner >> group: aName with: aNameOrCollection [

	(groups at: aName asString ifAbsentPut: [ OrderedCollection new ]) addAll: (self namesFrom: aNameOrCollection)
]

{ #category : 'initialization' }
ProjectBaseliner >> initialize [

	super initialize.
	packages := OrderedDictionary new.
	groups := OrderedDictionary new.
	projects := OrderedDictionary new.
	unsupportedAPI := OrderedCollection new
]

{ #category : 'interpreting' }
ProjectBaseliner >> interpret: aBaselineClass [
	"Execute the method of aBaselineClass tagged <baseline> with me as spec, recording what it declares. An error stops the interpretation and is kept in interpretationError."

	| method |
	method := aBaselineClass methods detect: [ :each | each hasPragmaNamed: #baseline ].
	name := self nameOf: aBaselineClass.
	[ method valueWithReceiver: aBaselineClass new arguments: { self } ]
		on: Error
		do: [ :error | interpretationError := error ]
]

{ #category : 'accessing' }
ProjectBaseliner >> interpretationError [
	"Answer the error that stopped the interpretation of the baseline method, nil when there was none."

	^ interpretationError
]

{ #category : 'private' }
ProjectBaseliner >> isWithin: aKind [

	^ current isNotNil and: [ current key = aKind ]
]

{ #category : 'spec' }
ProjectBaseliner >> loads: aNameOrCollection [

	(self isWithin: #project) ifFalse: [ ^ self recordUnsupported: (Message selector: #loads: argument: aNameOrCollection) ].
	(projects at: current value) loads: (self namesFrom: aNameOrCollection) asArray
]

{ #category : 'accessing' }
ProjectBaseliner >> name [

	^ name
]

{ #category : 'accessing' }
ProjectBaseliner >> name: aString [

	name := aString
]

{ #category : 'private' }
ProjectBaseliner >> nameOf: aBaselineClass [

	| className |
	className := aBaselineClass name.
	^ (className beginsWith: 'BaselineOf')
		  ifTrue: [ className allButFirst: 'BaselineOf' size ]
		  ifFalse: [ className asString ]
]

{ #category : 'private' }
ProjectBaseliner >> namesFrom: aNameOrCollection [
	"Answer the names as strings: baselines mix symbols and strings, and give a single name or a collection."

	aNameOrCollection isString ifTrue: [ ^ OrderedCollection with: aNameOrCollection asString ].
	^ aNameOrCollection collect: [ :each | each asString ] as: OrderedCollection
]

{ #category : 'spec' }
ProjectBaseliner >> package: aName [

	packages at: aName asString ifAbsentPut: [ OrderedCollection new ]
]

{ #category : 'spec' }
ProjectBaseliner >> package: aName with: aBlock [

	self package: aName.
	self within: #package -> aName asString do: aBlock
]

{ #category : 'private' }
ProjectBaseliner >> recordUnsupported: aMessage [

	unsupportedAPI add: aMessage
]

{ #category : 'spec' }
ProjectBaseliner >> repository: aDescription [

	(self isWithin: #project) ifFalse: [ ^ self recordUnsupported: (Message selector: #repository: argument: aDescription) ].
	(projects at: current value) repository: aDescription
]

{ #category : 'spec' }
ProjectBaseliner >> repositoryDescriptions [
	"BaselineOf>>packageRepositoryURLForSpec: asks me where the baseline is loaded from. The marker records that the baseline means its own repository."

	^ { StBaselineOwnRepository new }
]

{ #category : 'representing' }
ProjectBaseliner >> represent [
	"Build the StBaseline tree from what was recorded, linking requires: and group members to their elements. A name the baseline does not declare becomes one StBaselineUnresolvedReference."

	| elements resolve |
	baseline := StBaseline named: name.
	elements := Dictionary new.
	groups keysDo: [ :each | baseline addGroup: (elements at: each put: (StBaselineGroup named: each)) ].
	projects valuesDo: [ :each | baseline addProject: (elements at: each name put: each) ].
	packages keysDo: [ :each | baseline addPackage: (elements at: each put: (StBaselinePackage named: each)) ].
	resolve := [ :aName | elements at: aName ifAbsentPut: [ StBaselineUnresolvedReference named: aName ] ].
	packages keysAndValuesDo: [ :packageName :requiredNames |
		requiredNames do: [ :each | (baseline packageNamed: packageName) addRequired: (resolve value: each) ] ].
	groups keysAndValuesDo: [ :groupName :memberNames |
		memberNames do: [ :each | (baseline groupNamed: groupName) addMember: (resolve value: each) ] ]
]

{ #category : 'spec' }
ProjectBaseliner >> requires: aNameOrCollection [

	(self isWithin: #package) ifFalse: [ ^ self recordUnsupported: (Message selector: #requires: argument: aNameOrCollection) ].
	(packages at: current value) addAll: (self namesFrom: aNameOrCollection)
]

{ #category : 'accessing' }
ProjectBaseliner >> unsupportedAPI [
	"Answer the messages the baseline sent me and that I do not support, in the order received."

	^ unsupportedAPI
]

{ #category : 'private' }
ProjectBaseliner >> within: aKindAndName do: aBlock [
	"Evaluate aBlock with aKindAndName (#package -> name or #project -> name) as the element that requires:, repository: and loads: apply to."

	| previous |
	previous := current.
	current := aKindAndName.
	aBlock ensure: [ current := previous ]
]
