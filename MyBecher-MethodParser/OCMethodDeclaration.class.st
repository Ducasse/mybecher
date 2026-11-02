"
I represent one method read by `OCMethodParser`, from Tonel source or from a plain Pharo method.

## Responsibility:

- I know which class the method belongs to (its name), and whether it is on the instance side or the class side. A plain method doesn't say, so its `className` is nil.
- I hold the Tonel metadata (e.g. `#category`) found before the method. It is empty for a plain method.
- I hold the `OCMethodNode` built by `OCParser` from the selector pattern and the body.

## Collaborators:

- `OCMethodParser` creates me.
- `OCMethodNode` is my `ast`. It answers the selector, the arguments and the source code.

## Public API and Key Messages

- `className`, `isMeta` / `isClassSide` / `isInstanceSide`
- `metadata`, `category`
- `ast`, `selector`, `sourceCode`

Create me with `OCMethodParser parse: aString`. Usually you don't create me yourself. For example:

```
(OCMethodParser parse: '{ #category : ''accessing'' }
Point class >> origin [
	^ 0 @ 0
]') selector. ""#origin""

(OCMethodParser parse: 'origin ^ 0 @ 0') className. ""nil""
```

See `OCMethodDeclaration class >> #exampleClassSide`, `#exampleInstanceSide` and `#examplePlain`.

## Internal Representation

- `className`: a `String`, the class name without ` class`, or nil for a plain method.
- `isMeta`: a `Boolean`, true for a class-side method.
- `metadata`: a `Dictionary` read with STON. It is empty when the method has no metadata.
- `ast`: an `OCMethodNode`.
"
Class {
	#name : 'OCMethodDeclaration',
	#superclass : 'Object',
	#instVars : [
		'className',
		'isMeta',
		'metadata',
		'ast'
	],
	#category : 'MyBecher-MethodParser-Core',
	#package : 'MyBecher-MethodParser',
	#tag : 'Core'
}

{ #category : 'examples' }
OCMethodDeclaration class >> exampleClassSide [

	<sampleInstance>
	^ OCMethodParser parse: '{ #category : ''instance creation'' }
Point class >> unit [
	"Answer the point at 1@1"
	^ 1 @ 1
]'
]

{ #category : 'examples' }
OCMethodDeclaration class >> exampleInstanceSide [

	<sampleInstance>
	^ OCMethodParser parse: '{ #category : ''arithmetic'' }
Point >> double [
	^ self * 2
]'
]

{ #category : 'examples' }
OCMethodDeclaration class >> examplePlain [

	<sampleInstance>
	^ OCMethodParser parse: 'squared: aNumber
	"Answer aNumber multiplied by itself"
	^ aNumber * aNumber'
]

{ #category : 'accessing' }
OCMethodDeclaration >> ast [

	^ ast
]

{ #category : 'accessing' }
OCMethodDeclaration >> ast: aMethodNode [

	ast := aMethodNode
]

{ #category : 'accessing' }
OCMethodDeclaration >> category [
	"Answer the protocol given in the Tonel metadata, or nil when there is none"

	^ metadata at: #category ifAbsent: [ nil ]
]

{ #category : 'accessing' }
OCMethodDeclaration >> className [

	^ className
]

{ #category : 'accessing' }
OCMethodDeclaration >> className: aString [

	className := aString
]

{ #category : 'initialization' }
OCMethodDeclaration >> initialize [

	super initialize.
	isMeta := false.
	metadata := Dictionary new
]

{ #category : 'testing' }
OCMethodDeclaration >> isClassSide [

	^ isMeta
]

{ #category : 'testing' }
OCMethodDeclaration >> isInstanceSide [

	^ isMeta not
]

{ #category : 'accessing' }
OCMethodDeclaration >> isMeta [

	^ isMeta
]

{ #category : 'accessing' }
OCMethodDeclaration >> isMeta: aBoolean [

	isMeta := aBoolean
]

{ #category : 'accessing' }
OCMethodDeclaration >> metadata [

	^ metadata
]

{ #category : 'accessing' }
OCMethodDeclaration >> metadata: aDictionary [

	metadata := aDictionary
]

{ #category : 'printing' }
OCMethodDeclaration >> printOn: aStream [

	className ifNotNil: [
			aStream nextPutAll: className asString.
			isMeta ifTrue: [ aStream nextPutAll: ' class' ].
			aStream nextPutAll: ' >> ' ].
	ast ifNotNil: [ aStream print: ast selector ]
]

{ #category : 'accessing' }
OCMethodDeclaration >> selector [

	^ ast selector
]

{ #category : 'accessing' }
OCMethodDeclaration >> sourceCode [
	"Answer the method source as Pharo stores it: the selector pattern followed by the body"

	^ ast source
]
