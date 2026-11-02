"
I represent one method read from Tonel source, as returned by `TonelMethodParser`.

## Responsibility:

- I know which class the method belongs to (its name), and whether it is on the instance side or the class side.
- I hold the Tonel metadata (e.g. `#category`) found before the method.
- I hold the `OCMethodNode` built by `OCParser` from the selector pattern and the body.

## Collaborators:

- `TonelMethodParser` creates me.
- `OCMethodNode` is my `ast`. It answers the selector, the arguments and the source code.

## Public API and Key Messages

- `className`, `isMeta` / `isClassSide` / `isInstanceSide`
- `metadata`, `category`
- `ast`, `selector`, `sourceCode`

Create me with `TonelMethodParser parse: aString`. Usually you don't create me yourself. For example:

```
(TonelMethodParser parse: '{ #category : ''accessing'' }
Point class >> origin [
	^ 0 @ 0
]') selector. ""#origin""
```

See `TonelMethodDeclaration class >> #exampleClassSide`.

## Internal Representation

- `className`: a `String`, the class name without ` class`.
- `isMeta`: a `Boolean`, true for a class-side method.
- `metadata`: a `Dictionary` read with STON. It is empty when the method has no metadata.
- `ast`: an `OCMethodNode`.
"
Class {
	#name : 'TonelMethodDeclaration',
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
TonelMethodDeclaration class >> exampleClassSide [

	<sampleInstance>
	^ TonelMethodParser parse: '{ #category : ''instance creation'' }
Point class >> unit [
	"Answer the point at 1@1"
	^ 1 @ 1
]'
]

{ #category : 'examples' }
TonelMethodDeclaration class >> exampleInstanceSide [

	<sampleInstance>
	^ TonelMethodParser parse: '{ #category : ''arithmetic'' }
Point >> double [
	^ self * 2
]'
]

{ #category : 'accessing' }
TonelMethodDeclaration >> ast [

	^ ast
]

{ #category : 'accessing' }
TonelMethodDeclaration >> ast: aMethodNode [

	ast := aMethodNode
]

{ #category : 'accessing' }
TonelMethodDeclaration >> category [
	"Answer the protocol given in the Tonel metadata, or nil when there is none"

	^ metadata at: #category ifAbsent: [ nil ]
]

{ #category : 'accessing' }
TonelMethodDeclaration >> className [

	^ className
]

{ #category : 'accessing' }
TonelMethodDeclaration >> className: aString [

	className := aString
]

{ #category : 'initialization' }
TonelMethodDeclaration >> initialize [

	super initialize.
	isMeta := false.
	metadata := Dictionary new
]

{ #category : 'testing' }
TonelMethodDeclaration >> isClassSide [

	^ isMeta
]

{ #category : 'testing' }
TonelMethodDeclaration >> isInstanceSide [

	^ isMeta not
]

{ #category : 'accessing' }
TonelMethodDeclaration >> isMeta [

	^ isMeta
]

{ #category : 'accessing' }
TonelMethodDeclaration >> isMeta: aBoolean [

	isMeta := aBoolean
]

{ #category : 'accessing' }
TonelMethodDeclaration >> metadata [

	^ metadata
]

{ #category : 'accessing' }
TonelMethodDeclaration >> metadata: aDictionary [

	metadata := aDictionary
]

{ #category : 'printing' }
TonelMethodDeclaration >> printOn: aStream [

	aStream nextPutAll: className asString.
	isMeta ifTrue: [ aStream nextPutAll: ' class' ].
	aStream nextPutAll: ' >> '.
	ast ifNotNil: [ aStream print: ast selector ]
]

{ #category : 'accessing' }
TonelMethodDeclaration >> selector [

	^ ast selector
]

{ #category : 'accessing' }
TonelMethodDeclaration >> sourceCode [
	"Answer the method source as Pharo stores it: the selector pattern followed by the body"

	^ ast source
]
