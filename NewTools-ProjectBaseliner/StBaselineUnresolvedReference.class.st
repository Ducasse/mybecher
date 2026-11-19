"
I am a placeholder for a name that a `requires:` or a group uses but that the baseline declares neither as a package, a group nor a project (a typo, a forgotten declaration). See `StBaselineElement` for the life cycle.

## Responsibility:

- Stand in the `requires` of a package or the `members` of a group where the missing element should be, so that a broken baseline is still represented.
- Answer true to `isUnresolved`.

## Collaborators: 

- `ProjectBaseliner>>represent`: creates one of me per missing name, shared by all the places using it.
- `StBaseline>>unresolvedReferences`: lists us.

## Public API and Key Messages

- `name`, `isUnresolved`.

## Examples

```
StBaselineUnresolvedReference exampleMissing.
```
"
Class {
	#name : 'StBaselineUnresolvedReference',
	#superclass : 'StBaselineElement',
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaselineUnresolvedReference class >> exampleMissing [

	<sampleInstance>
	^ self named: 'Missing'
]

{ #category : 'visiting' }
StBaselineUnresolvedReference >> acceptVisitor: aVisitor [

	^ aVisitor visitUnresolvedReference: self
]

{ #category : 'testing' }
StBaselineUnresolvedReference >> isUnresolved [

	^ true
]
