"
I represent a group declared by `group:with:` in a `<baseline>` method. See `StBaselineElement` for the life cycle.

## Responsibility:

- Know my members: packages, other groups, projects, or `StBaselineUnresolvedReference`s for names the baseline does not declare.

## Collaborators: 

- `ProjectBaseliner>>represent`: creates me and adds my members.

## Public API and Key Messages

- `members`, in the order written; a group declared twice gets the members of both declarations.

## Examples

```
StBaselineGroup exampleDebuggerCLICore.
```
"
Class {
	#name : 'StBaselineGroup',
	#superclass : 'StBaselineElement',
	#instVars : [
		'members'
	],
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaselineGroup class >> exampleDebuggerCLICore [

	<sampleInstance>
	^ StBaseline exampleDebuggerCLI groupNamed: 'Core'
]

{ #category : 'adding' }
StBaselineGroup >> addMember: anElement [

	members add: anElement
]

{ #category : 'initialization' }
StBaselineGroup >> initialize [

	super initialize.
	members := OrderedCollection new
]

{ #category : 'accessing' }
StBaselineGroup >> members [
	"Answer the elements I group: packages, groups, projects or unresolved references."

	^ members
]
