"
I am the repository of a project that lives in the same repository as the baseline declaring it. Baselines write `self packageRepositoryURLForSpec: spec` for that, and the URL depends on where the baseline is loaded from, so I record the intent instead of a URL.

## Life cycle: who creates me and who uses me

1. `ProjectBaseliner>>repositoryDescriptions` answers a collection holding me when `BaselineOf>>packageRepositoryURLForSpec:` asks it.
2. `BaselineOf>>packageRepositoryURLForSpec:` answers me: I do not begin with `tonel://`, so it falls back on me.
3. The baseline passes me to `ProjectBaseliner>>repository:`, and the `StBaselineProject` keeps me as its repository.
4. `StBaselineProject>>isInOwnRepository` compares its repository with me.

## Responsibility:

- Stand for the baseline's own repository.
- Answer the string messages baselines send to the description (`beginsWith:`, `includesSubstring:`, `isEmpty`, `ifEmpty:`) as a non-empty URL matching no concrete one.

## Collaborators: 

- `ProjectBaseliner`, `BaselineOf`, `StBaselineProject`.

## Public API and Key Messages

- `=`: all of us are equal.

## Examples

```
StBaselineOwnRepository exampleDefault.
```
"
Class {
	#name : 'StBaselineOwnRepository',
	#superclass : 'Object',
	#category : 'NewTools-ProjectBaseliner-Model',
	#package : 'NewTools-ProjectBaseliner',
	#tag : 'Model'
}

{ #category : 'examples' }
StBaselineOwnRepository class >> exampleDefault [

	<sampleInstance>
	^ self new
]

{ #category : 'comparing' }
StBaselineOwnRepository >> = anObject [
	"All markers mean the same thing: the repository of the baseline."

	^ self class == anObject class
]

{ #category : 'string protocol' }
StBaselineOwnRepository >> beginsWith: aString [
	"BaselineOf>>packageRepositoryURLForSpec: looks for a tonel:// description first. Answering false makes it fall back on me."

	^ false
]

{ #category : 'comparing' }
StBaselineOwnRepository >> hash [

	^ self class hash
]

{ #category : 'string protocol' }
StBaselineOwnRepository >> ifEmpty: aBlock [
	"Baselines write (self packageRepositoryURLForSpec: spec) ifEmpty: [ aFallbackURL ]. I am never empty: the baseline gets its own repository."

	^ self
]

{ #category : 'string protocol' }
StBaselineOwnRepository >> includesSubstring: aString [
	"Overrides of BaselineOf>>packageRepositoryURLForSpec: inspect the description (see BaselineOfNewTools). I match no concrete URL."

	^ false
]

{ #category : 'string protocol' }
StBaselineOwnRepository >> isEmpty [

	^ false
]

{ #category : 'printing' }
StBaselineOwnRepository >> printOn: aStream [

	aStream nextPutAll: 'own repository'
]
