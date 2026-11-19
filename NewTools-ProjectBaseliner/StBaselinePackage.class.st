"
I represent a package declared by `package:` or `package:with:` in a `<baseline>` method. See `StBaselineElement` for the life cycle.

## Responsibility:

- Know the elements I require (`requires:` in my `with:` block): packages, groups, projects, or `StBaselineUnresolvedReference`s for names the baseline does not declare.

## Collaborators: 

- `ProjectBaseliner>>represent`: creates me and adds what I require.

## Public API and Key Messages

- `requires`, in the order written; a package declared twice gets the requirements of both declarations.

## Examples

```
StBaselinePackage exampleDebuggerCLITests.
```
"
Class {
	#name : 'StBaselinePackage',
	#superclass : 'StBaselineElement',
	#instVars : [
		'requires'
	],
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaselinePackage class >> exampleDebuggerCLITests [
	"A package requiring a package and a project."

	<sampleInstance>
	^ StBaseline exampleDebuggerCLI packageNamed: 'Debugger-CLI-Tests'
]

{ #category : 'adding' }
StBaselinePackage >> addRequired: anElement [

	requires add: anElement
]

{ #category : 'initialization' }
StBaselinePackage >> initialize [

	super initialize.
	requires := OrderedCollection new
]

{ #category : 'accessing' }
StBaselinePackage >> requires [
	"Answer the elements I require: packages, groups, projects or unresolved references."

	^ requires
]
