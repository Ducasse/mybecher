"
I am an element of a baseline as represented by `ProjectBaseliner`: something with a name that the `<baseline>` method of a `BaselineOf` declares or refers to. My subclasses are the baseline itself and the packages, groups and projects it declares, plus the placeholders for names it uses without declaring them.

## Life cycle: who creates elements and who uses them

1. `ProjectBaseliner>>represent` creates the `StBaseline`, its `StBaselinePackage`s and `StBaselineGroup`s, and one `StBaselineUnresolvedReference` per missing name. `ProjectBaseliner>>baseline:with:` creates the `StBaselineProject`s while the baseline method runs.
2. `ProjectBaseliner>>represent` links them: the `requires` of each package and the `members` of each group are elements.
3. Clients get the tree with `ProjectBaseliner>>baseline` and walk it. Nothing changes it afterwards; representing again builds a new tree.

## Responsibility:

- Know my name, a string even when the baseline wrote a symbol.
- Tell whether I stand for a name the baseline does not declare (`isUnresolved`).

## Collaborators: 

- `ProjectBaseliner`: creates and links the elements.

## Public API and Key Messages

- `StBaselineElement named: aString` creates an element.
- `name`, `isUnresolved`.

## Examples

```
StBaselineElement scriptDebuggerCLITree.
```
"
Class {
	#name : 'StBaselineElement',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StBaselineElement class >> named: aString [

	^ self new
		  name: aString;
		  yourself
]

{ #category : 'script' }
StBaselineElement class >> scriptDebuggerCLITree [
	"Inspect the tree of BaselineOfDebuggerCLI: the package Debugger-CLI requires the project Debugging, the group Tests holds the package Debugger-CLI-Tests."

	<example>
	^ ProjectBaseliner exampleDebuggerCLI baseline inspect
]

{ #category : 'testing' }
StBaselineElement >> isUnresolved [
	"Answer whether I stand for a name that the baseline does not declare."

	^ false
]

{ #category : 'accessing' }
StBaselineElement >> name [

	^ name
]

{ #category : 'accessing' }
StBaselineElement >> name: aString [

	name := aString
]

{ #category : 'printing' }
StBaselineElement >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: name;
		nextPutAll: ')'
]
