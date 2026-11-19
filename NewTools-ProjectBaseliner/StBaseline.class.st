"
I am the root of the tree representing a baseline: its packages, groups and projects, in the order the `<baseline>` method declares them. My name is the name of the `BaselineOf` class without its `BaselineOf` prefix. See `StBaselineElement` for the life cycle.

## Responsibility:

- Hold the packages, groups and projects of the baseline.
- Find them by name.
- List the names used by `requires:` and groups but not declared.

## Collaborators: 

- `ProjectBaseliner>>represent`: creates me and fills me.
- `StBaselinePackage`, `StBaselineGroup`, `StBaselineProject`, `StBaselineUnresolvedReference`: my elements.

## Public API and Key Messages

- `packages`, `groups`, `projects`.
- `packageNamed:`, `groupNamed:`, `projectNamed:` answer nil when there is none.
- `unresolvedReferences` answers the placeholders, once each.

## Examples

```
StBaseline exampleDebuggerCLI.
```
"
Class {
	#name : 'StBaseline',
	#superclass : 'StBaselineElement',
	#instVars : [
		'packages',
		'groups',
		'projects'
	],
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaseline class >> exampleDebuggerCLI [

	<sampleInstance>
	^ ProjectBaseliner exampleDebuggerCLI baseline
]

{ #category : 'visiting' }
StBaseline >> acceptVisitor: aVisitor [

	^ aVisitor visitBaseline: self
]

{ #category : 'adding' }
StBaseline >> addGroup: aGroup [

	groups add: aGroup
]

{ #category : 'adding' }
StBaseline >> addPackage: aPackage [

	packages add: aPackage
]

{ #category : 'adding' }
StBaseline >> addProject: aProject [

	projects add: aProject
]

{ #category : 'querying' }
StBaseline >> groupNamed: aString [

	^ groups detect: [ :each | each name = aString ] ifNone: [ nil ]
]

{ #category : 'accessing' }
StBaseline >> groups [

	^ groups
]

{ #category : 'initialization' }
StBaseline >> initialize [

	super initialize.
	packages := OrderedCollection new.
	groups := OrderedCollection new.
	projects := OrderedCollection new
]

{ #category : 'querying' }
StBaseline >> packageNamed: aString [

	^ packages detect: [ :each | each name = aString ] ifNone: [ nil ]
]

{ #category : 'accessing' }
StBaseline >> packages [

	^ packages
]

{ #category : 'querying' }
StBaseline >> projectNamed: aString [

	^ projects detect: [ :each | each name = aString ] ifNone: [ nil ]
]

{ #category : 'accessing' }
StBaseline >> projects [

	^ projects
]

{ #category : 'querying' }
StBaseline >> unresolvedReferences [
	"Answer the placeholders standing for the names that requires: and groups use but that I do not declare, once each."

	^ ((packages flatCollect: [ :each | each requires ]) , (groups flatCollect: [ :each | each members ]) select: [ :each |
		   each isUnresolved ]) removeDuplicates
]
