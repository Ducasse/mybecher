"
I represent an external project declared by `baseline:with:` in a `<baseline>` method. See `StBaselineElement` for the life cycle; unlike the other elements, `ProjectBaseliner>>baseline:with:` creates me while the baseline method runs, and `repository:` and `loads:` in my `with:` block fill me.

## Responsibility:

- Know where the project is (`repository`): the description written, or a `StBaselineOwnRepository` when the baseline asked for its own repository with `self packageRepositoryURLForSpec: spec`.
- Know what to load from it (`loads`), as an array of names, empty when the baseline does not say.

## Collaborators: 

- `ProjectBaseliner`: creates and fills me.
- `StBaselineOwnRepository`: the repository marker.

## Public API and Key Messages

- `repository`, `loads`.
- `isInOwnRepository`.

## Examples

```
StBaselineProject exampleDebugging.
```
"
Class {
	#name : 'StBaselineProject',
	#superclass : 'StBaselineElement',
	#instVars : [
		'repository',
		'loads'
	],
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaselineProject class >> exampleDebugging [
	"The project Debugging of BaselineOfDebuggerCLI: in the baseline's own repository, loading Debugger-Model."

	<sampleInstance>
	^ StBaseline exampleDebuggerCLI projectNamed: 'Debugging'
]

{ #category : 'visiting' }
StBaselineProject >> acceptVisitor: aVisitor [

	^ aVisitor visitProject: self
]

{ #category : 'initialization' }
StBaselineProject >> initialize [

	super initialize.
	loads := #(  )
]

{ #category : 'testing' }
StBaselineProject >> isInOwnRepository [
	"Answer whether I live in the same repository as the baseline declaring me."

	^ repository = StBaselineOwnRepository new
]

{ #category : 'accessing' }
StBaselineProject >> loads [
	"Answer the names of the packages or groups of the project to load; empty means the project default."

	^ loads
]

{ #category : 'accessing' }
StBaselineProject >> loads: aCollection [

	loads := aCollection
]

{ #category : 'accessing' }
StBaselineProject >> repository [
	"Answer the repository description as written in the baseline, or a StBaselineOwnRepository when the baseline asked for its own repository."

	^ repository
]

{ #category : 'accessing' }
StBaselineProject >> repository: aStringOrMarker [

	repository := aStringOrMarker
]
