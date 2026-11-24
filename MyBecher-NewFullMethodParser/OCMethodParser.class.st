"
I parse a method written either as a plain method, as edited in a browser (`bar ^ 1`), or as a Tonel method definition, as stored in Tonel files (`{ #category : 'accessing' } Foo >> bar [ ^ 1 ]`). I am a decorator of an `OCParser` (or of one of its subclasses, such as `OCPatternParser`): it does all the parsing of the method, and I only deal with what Tonel adds around it.

For a Tonel definition, I answer the AST of the method, and store the extra information of the definition as properties of the `OCMethodNode`: `#className` (a Symbol), `#isClassSide` (a Boolean, for `Foo class >>` and for `TFoo classSide >>`, the class side of a trait), and `#protocol` (the `#category` of the metadata, as a Symbol, absent when there is none).

## Examples

```
OCMethodParser exampleTonelDefinition parseMethod
```

## Design Rationale

- I am a decorator rather than a change of `OCParser>>parseMethod`, so the parser the compiler depends on is left untouched, and any parser can be decorated (`OCMethodParser on: OCPatternParser new`).
- I give the decorated parser a copy of the definition in which the header (metadata and class reference) and the two brackets of the body are spaces, line ends kept. It is a plain method of the same length, so the nodes, error nodes included, get their positions in the definition, and the definition becomes the `source` of the method node. Editors and the compiler can then report errors at the right place.
- Only an unambiguous start makes a source a Tonel definition: metadata (`{`), `Foo >>`, or, since `Foo class >> bar` alone is a valid plain method, `Foo class >>` followed by a selector pattern and `[`. None of them can start a valid plain method, so a plain method gives exactly the AST of the decorated parser.
- The metadata is STON. I read it myself, by characters, so that I depend only on AST-Core, like the parser I decorate, and not on STON: only the values Tonel writes in method metadata are accepted (strings with their backslash escapes, symbols, numbers, true, false, nil). The rest of the header is read with the scanner of the decorated parser.

## Usage

1. Create me with `OCMethodParser new` (I decorate a new `OCParser`) or `OCMethodParser on: aParser`, or use the class-side `parseMethod:`, `parseMethod:onError:` and `parseFaultyMethod:`.
2. Send me `initializeParserWith:` with the source, then `parseMethod`; `atEnd` tells whether the whole source was read. I answer to the same messages as `OCParser` for parsing methods, so the compiler can use me through its compilation context (`aCompiler compilationContext parserClass: OCMethodParser`), whose `OpalCompiler>>parse` sends them. I don't parse expressions or doits (`parseExpression:`, `parseDoIt`).

An instance is mutable and keeps the state of the last parse; it can be reused by sending `initializeParserWith:` again. It is not meant to be shared between processes.

## Implementation Notes

- A malformed definition never raises an exception while parsing: an invalid header is given unchanged to the decorated parser, for which it is a faulty plain method; a missing bracket of the body becomes an error node added at the end of the body, when the decorated parser found nothing else wrong.
- The closing bracket is the last token of the source. A `]` inside a string, a comment or a character literal (`$]`) is not taken for it.
- `true`, `false` and `nil` are read as literals by the scanner, but are valid unary selectors (`OCParser>>patchLiteralMessage` patches them the same way).

## Invariants and Assumptions

- The source holds one method, and nothing but separators or comments comes after the closing bracket of a Tonel definition.
- The line ends of the definition are kept: they are not converted, as `TonelParser` does.
"
Class {
	#name : 'OCMethodParser',
	#superclass : 'Object',
	#instVars : [
		'parser',
		'source',
		'scanner',
		'token',
		'metadata',
		'className',
		'isClassSide',
		'headerStop',
		'bodyStart',
		'bodyStop',
		'errorPosition'
	],
	#category : 'MyBecher-NewFullMethodParser-Core',
	#package : 'MyBecher-NewFullMethodParser',
	#tag : 'Core'
}

{ #category : 'examples' }
OCMethodParser class >> exampleTonelDefinition [
	"A method parser ready to parse a class-side Tonel method definition: send it parseMethod"

	<sampleInstance>
	^ self new
		  initializeParserWith: '{ #category : ''instance creation'' }
Counter class >> startingAt: anInteger [
	"Answer a counter whose count starts at anInteger"
	^ self new setCount: anInteger
]';
		  yourself
]

{ #category : 'instance creation' }
OCMethodParser class >> on: aParser [
	"Answer a method parser decorating aParser, an OCParser or one of its subclasses"

	^ self new
		  parser: aParser;
		  yourself
]

{ #category : 'parsing' }
OCMethodParser class >> parseFaultyMethod: aString [
	"Parse aString, a plain method or a Tonel method definition, even if it is invalid: the AST then holds error nodes"

	^ self new
		  initializeParserWith: aString;
		  parseMethod
]

{ #category : 'parsing' }
OCMethodParser class >> parseMethod: aString [
	"Parse aString, a plain method or a Tonel method definition, and answer its AST. Signal an OCCodeError when it is invalid"

	^ self parseMethod: aString onError: nil
]

{ #category : 'parsing' }
OCMethodParser class >> parseMethod: aString onError: aBlock [
	"Parse aString, a plain method or a Tonel method definition, and answer its AST. When it is invalid, evaluate aBlock with the error message, position and AST, then signal an OCCodeError"

	^ (self parseFaultyMethod: aString) checkFaulty: aBlock
]

{ #category : 'private - parsing' }
OCMethodParser >> addTonelErrorTo: aMethodNode [
	"Add an error node at the end of the body when a bracket of the body is missing and the decorated parser found nothing wrong"

	| error statements |
	(errorPosition isNil or: [ aMethodNode isFaulty ]) ifTrue: [ ^ self ].
	error := OCParseErrorNode new
		         errorMessage: (bodyStart ifNil: [ '''['' expected' ] ifNotNil: [ ''']'' expected' ]);
		         value: '';
		         start: errorPosition;
		         stop: errorPosition - 1;
		         errorPosition: errorPosition;
		         yourself.
	statements := aMethodNode body statements copy.
	statements add: error.
	error parent: aMethodNode body.
	aMethodNode body statements: statements
]

{ #category : 'private - parsing' }
OCMethodParser >> addTonelPropertiesTo: aMethodNode [

	aMethodNode
		propertyAt: #className put: className;
		propertyAt: #isClassSide put: isClassSide.
	metadata
		at: #category
		ifPresent: [ :protocol | protocol isString ifTrue: [ aMethodNode propertyAt: #protocol put: protocol asSymbol ] ]
]

{ #category : 'testing' }
OCMethodParser >> atEnd [
	"Answer whether the decorated parser has read the whole source"

	^ parser atEnd
]

{ #category : 'private - parsing' }
OCMethodParser >> blankedSource [
	"Answer a copy of the source in which the header of the definition and the brackets of its body are spaces, line ends kept: a plain method whose positions are the ones of the definition"

	| blanked |
	blanked := source asString copy.
	1 to: headerStop do: [ :index | (blanked at: index) isSeparator ifFalse: [ blanked at: index put: Character space ] ].
	bodyStart ifNotNil: [ blanked at: bodyStart put: Character space ].
	bodyStop ifNotNil: [ blanked at: bodyStop put: Character space ].
	^ blanked
]

{ #category : 'initialization' }
OCMethodParser >> initialize [

	super initialize.
	parser := OCParser new
]

{ #category : 'initialization' }
OCMethodParser >> initializeParserWith: aString [
	"Prepare the parsing of aString, as OCParser>>initializeParserWith: does"

	source := aString.
	parser initializeParserWith: aString
]

{ #category : 'private - scanning' }
OCMethodParser >> isUnarySelectorToken [
	"Answer whether the current token can be a unary selector. The scanner reads `true`, `false` and `nil` as literals, but they are valid selectors, as OCParser>>patchLiteralMessage knows"

	^ token isIdentifier or: [ token isLiteralToken and: [ #( true false nil ) includes: token value ] ]
]

{ #category : 'parsing' }
OCMethodParser >> parseMethod [
	"Parse the source with the decorated parser and answer its AST. A Tonel method definition is given to it with its header (metadata and class reference) and the brackets of its body replaced by spaces, so the nodes keep their positions in the definition, which becomes the source of the method node. The extra information of the definition is stored as the properties #className, #isClassSide and #protocol (the #category of the metadata) of the method node"

	| ast |
	self scanTonelHeader ifFalse: [ ^ parser parseMethod ].
	parser initializeParserWith: self blankedSource.
	ast := parser parseMethod.
	ast source: source.
	self addTonelErrorTo: ast.
	self addTonelPropertiesTo: ast.
	^ ast
]

{ #category : 'accessing' }
OCMethodParser >> parser [

	^ parser
]

{ #category : 'accessing' }
OCMethodParser >> parser: aParser [

	parser := aParser
]

{ #category : 'private - metadata' }
OCMethodParser >> readMetadataEntryFrom: aStream into: aDictionary [
	"Read one `key : value` entry of the metadata, and the separators after it, into aDictionary. Answer false when the entry is invalid"

	| key |
	key := self readStonValueFrom: aStream ifInvalid: [ ^ false ].
	key isString ifTrue: [ key := key asSymbol ].
	aStream skipSeparators.
	aStream next = $: ifFalse: [ ^ false ].
	aStream skipSeparators.
	aDictionary at: key put: (self readStonValueFrom: aStream ifInvalid: [ ^ false ]).
	aStream skipSeparators.
	^ true
]

{ #category : 'private - metadata' }
OCMethodParser >> readMetadataFrom: aStream [
	"Read the metadata of a Tonel method definition, a STON dictionary such as `{ #category : 'accessing' }`, aStream being on its opening brace. Answer it, or nil when it is invalid. Only the STON values Tonel writes in method metadata are read: strings, symbols, numbers, true, false and nil"

	| dictionary |
	dictionary := Dictionary new.
	aStream next.
	aStream skipSeparators.
	aStream peek = $} ifTrue: [
		aStream next.
		^ dictionary ].
	[
	(self readMetadataEntryFrom: aStream into: dictionary) ifFalse: [ ^ nil ].
	aStream peek = $, ] whileTrue: [
		aStream next.
		aStream skipSeparators ].
	aStream next = $} ifFalse: [ ^ nil ].
	^ dictionary
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonEscapeFrom: aStream ifInvalid: aBlock [
	"Read the character escaped after a backslash in a STON string"

	| char |
	char := aStream next.
	char ifNil: [ ^ aBlock value ].
	char = $u ifTrue: [ ^ self readStonUnicodeEscapeFrom: aStream ifInvalid: aBlock ].
	^ self stonEscapes at: char ifAbsent: aBlock
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonStringFrom: aStream ifInvalid: aBlock [
	"Read a STON string, aStream being on its opening quote. A backslash escapes the next character, as in `'drag\'n\'drop'`"

	aStream next.
	^ String streamContents: [ :string |
		  [
		  aStream atEnd ifTrue: [ ^ aBlock value ].
		  aStream peek = $' ] whileFalse: [
			  | char |
			  char := aStream next.
			  string nextPut: (char = $\
					   ifTrue: [ self readStonEscapeFrom: aStream ifInvalid: aBlock ]
					   ifFalse: [ char ]) ].
		  aStream next ]
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonSymbolFrom: aStream ifInvalid: aBlock [
	"Read a STON symbol, `#accessing` or `#'instance creation'`, aStream being on its #"

	| name |
	aStream next.
	aStream peek = $' ifTrue: [ ^ (self readStonStringFrom: aStream ifInvalid: aBlock) asSymbol ].
	name := self readStonWordFrom: aStream.
	name ifEmpty: [ ^ aBlock value ].
	^ name asSymbol
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonUnicodeEscapeFrom: aStream ifInvalid: aBlock [
	"Read the four hexadecimal digits of a `\u` escape in a STON string, and answer their character"

	| hex |
	hex := aStream next: 4.
	(hex size = 4 and: [ hex allSatisfy: [ :each | each isDigit or: [ 'ABCDEFabcdef' includes: each ] ] ]) ifFalse: [ ^ aBlock value ].
	^ Character value: (Integer readFrom: hex base: 16)
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonValueFrom: aStream ifInvalid: aBlock [
	"Read a STON string, symbol, number, true, false or nil. Answer the value of aBlock when there is none"

	| char |
	char := aStream peek.
	char ifNil: [ ^ aBlock value ].
	char = $' ifTrue: [ ^ self readStonStringFrom: aStream ifInvalid: aBlock ].
	char = $# ifTrue: [ ^ self readStonSymbolFrom: aStream ifInvalid: aBlock ].
	(char isDigit or: [ char = $- ]) ifTrue: [ ^ Number readFrom: aStream ifFail: aBlock ].
	^ self stonConstants at: (self readStonWordFrom: aStream) ifAbsent: aBlock
]

{ #category : 'private - metadata' }
OCMethodParser >> readStonWordFrom: aStream [
	"Read the characters STON allows in a symbol without quotes"

	^ String streamContents: [ :word |
		  [ aStream atEnd not and: [ aStream peek isAlphaNumeric or: [ '_./' includes: aStream peek ] ] ] whileTrue: [ word nextPut: aStream next ] ]
]

{ #category : 'private - scanning' }
OCMethodParser >> scanBody [
	"Find the brackets of the body: the opening one right after the selector pattern, and the closing one as the last token of the source. Note where the error is when one of them is missing"

	| last |
	self scanSelectorPattern ifFalse: [
		errorPosition := token start.
		^ self ].
	bodyStart := token start.
	last := token.
	[
	self step.
	token isEOF ] whileFalse: [ last := token ].
	(last isSpecial: $])
		ifTrue: [ bodyStop := last start ]
		ifFalse: [ errorPosition := token start ]
]

{ #category : 'private - scanning' }
OCMethodParser >> scanClassReference [
	"Scan `Foo >>`, or `Foo class >>` and `TFoo classSide >>` (the class side of a trait, as Tonel writes it), note the class name and side, and answer whether the reference is valid"

	token isIdentifier ifFalse: [ ^ false ].
	className := token value asSymbol.
	self step.
	isClassSide := token isIdentifier and: [ #( 'class' 'classSide' ) includes: token value ].
	isClassSide ifTrue: [ self step ].
	(token isBinary: #>>) ifFalse: [ ^ false ].
	headerStop := token stop.
	self step.
	^ true
]

{ #category : 'private - scanning' }
OCMethodParser >> scanSelectorPattern [
	"Scan the selector pattern and answer whether it is well formed and followed by the opening bracket of the body"

	self isUnarySelectorToken ifTrue: [
		self step.
		^ token isSpecial: $[ ].
	token isBinary ifTrue: [
		self step.
		token isIdentifier ifFalse: [ ^ false ].
		self step.
		^ token isSpecial: $[ ].
	token isKeyword ifFalse: [ ^ false ].
	[ token isKeyword ] whileTrue: [
		self step.
		token isIdentifier ifFalse: [ ^ false ].
		self step ].
	^ token isSpecial: $[
]

{ #category : 'private - scanning' }
OCMethodParser >> scanTonelHeader [
	"Scan the start of the source and answer whether it is a Tonel method definition with valid metadata and class reference. Without metadata, a class-side reference must also be followed by a selector pattern and the opening bracket of the body, since `Foo class >> bar` alone is a valid plain method. Invalid metadata or class references are left to the decorated parser, for which the source is a faulty plain method. The metadata is STON, read by characters; the rest is read with the scanner of the decorated parser, from the end of the metadata"

	| input hasMetadata |
	headerStop := bodyStart := bodyStop := errorPosition := nil.
	source ifNil: [ ^ false ].
	input := source readStream.
	input skipSeparators.
	hasMetadata := input peek = ${.
	metadata := hasMetadata
		            ifTrue: [ (self readMetadataFrom: input) ifNil: [ ^ false ] ]
		            ifFalse: [ Dictionary new ].
	scanner := parser scannerClass on: input.
	self step.
	self scanClassReference ifFalse: [ ^ false ].
	self scanBody.
	^ hasMetadata or: [ isClassSide not or: [ bodyStart isNotNil ] ]
]

{ #category : 'private - scanning' }
OCMethodParser >> step [

	token := scanner next
]

{ #category : 'private - metadata' }
OCMethodParser >> stonConstants [
	"The STON constants, by their names"

	^ Dictionary newFrom: {
			  ('true' -> true).
			  ('false' -> false).
			  ('nil' -> nil) }
]

{ #category : 'private - metadata' }
OCMethodParser >> stonEscapes [
	"The characters escaped by a backslash in a STON string, by the character following the backslash, except `u`"

	^ Dictionary newFrom: {
			  ($' -> $').
			  ($" -> $").
			  ($\ -> $\).
			  ($/ -> $/).
			  ($b -> Character backspace).
			  ($f -> Character newPage).
			  ($n -> Character lf).
			  ($r -> Character cr).
			  ($t -> Character tab) }
]
