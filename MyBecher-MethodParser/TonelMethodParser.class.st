"
I parse method definitions written in the Tonel format, without the class definition around them. I handle instance-side methods (`Foo >> bar [ ... ]`) and class-side methods (`Foo class >> bar [ ... ]`).

## Responsibility:

- I read the optional STON metadata (`{ #category : 'accessing' }`), the class reference before `>>`, and the selector pattern.
- I find the method body between its brackets. Brackets inside strings, comments, characters and nested blocks don't end it.
- I give the selector pattern and the body to `OCParser`, which parses the method. Any syntax error is signalled as a `TonelParseError`.

## Collaborators:

- `TonelSourceScanner` finds the end of the method body.
- `OCParser` parses the method source into an `OCMethodNode`.
- `STON` reads the metadata.
- `TonelMethodDeclaration` is what I return for each method.

## Public API and Key Messages

- `TonelMethodParser parse: aString` returns one `TonelMethodDeclaration`. The string must contain exactly one method.
- `TonelMethodParser parseAll: aString` returns the collection of `TonelMethodDeclaration` for a string with several methods.
- The same messages exist on the instance side: `TonelMethodParser new parse: aString`.

```
| declaration |
declaration := TonelMethodParser parse: '{ #category : ''arithmetic'' }
Fraction class >> half: aNumber [
	""Answer half of aNumber""
	^ aNumber / 2
]'.
declaration isClassSide. ""true""
declaration selector. ""#half:""
declaration ast body statements size. ""1""
```

Run `TonelMethodParser class >> #scriptParseMethods` to inspect several parsed methods.

## Internal Representation

- `stream`: the `ReadStream` on the Tonel source being parsed.

### Implementation Points

- The source given to `OCParser` is the selector pattern followed by the body, as Tonel stores it.
- Comments are allowed in the selector pattern, and a `[` inside them is not taken as the start of the body.
"
Class {
	#name : 'TonelMethodParser',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'MyBecher-MethodParser-Core',
	#package : 'MyBecher-MethodParser',
	#tag : 'Core'
}

{ #category : 'parsing' }
TonelMethodParser class >> parse: aString [
	"Parse aString, which holds exactly one Tonel method definition, and answer a TonelMethodDeclaration"

	^ self new parse: aString
]

{ #category : 'parsing' }
TonelMethodParser class >> parseAll: aString [
	"Parse aString, which holds zero or more Tonel method definitions, and answer a collection of TonelMethodDeclaration"

	^ self new parseAll: aString
]

{ #category : 'script' }
TonelMethodParser class >> scriptParseMethods [
	"Parse an instance-side and a class-side method from one Tonel string and inspect the declarations with their ASTs"

	<script>
	(self parseAll: '{ #category : ''accessing'' }
Counter >> increment [
	count := count + 1.
	^ count
]

{ #category : ''instance creation'' }
Counter class >> startingAt: anInteger [
	^ self new setCount: anInteger
]') inspect
]

{ #category : 'private' }
TonelMethodParser >> atMethodSeparator [
	"Answer whether the stream is positioned on the >> between the class reference and the selector pattern"

	| position |
	position := stream position.
	^ [ stream next = $> and: [ stream next = $> ] ] ensure: [ stream position: position ]
]

{ #category : 'private' }
TonelMethodParser >> error: aString [
	"Signal parse errors as TonelParseError, the error used by the rest of Tonel"

	^ TonelParseError signal: aString
]

{ #category : 'private' }
TonelMethodParser >> isValidClassName: aString [

	^ aString first isLetter and: [ aString allSatisfy: [ :char | char isAlphaNumeric or: [ char = $_ ] ] ]
]

{ #category : 'private' }
TonelMethodParser >> ocParse: aString [

	^ [ OCParser parseMethod: aString ]
		  on: OCCodeError
		  do: [ :error | self error: 'Syntax error: ' , error messageText ]
]

{ #category : 'parsing' }
TonelMethodParser >> parse: aString [
	"Parse aString, which holds exactly one Tonel method definition, and answer a TonelMethodDeclaration"

	| declaration |
	stream := aString readStream.
	declaration := self parseMethod.
	self skipSeparators.
	stream atEnd ifFalse: [ self error: 'Unexpected characters after the method' ].
	^ declaration
]

{ #category : 'parsing' }
TonelMethodParser >> parseAll: aString [
	"Parse aString, which holds zero or more Tonel method definitions, and answer a collection of TonelMethodDeclaration"

	stream := aString readStream.
	^ OrderedCollection streamContents: [ :declarations |
			  [
				  self skipSeparators.
				  stream atEnd ] whileFalse: [ declarations nextPut: self parseMethod ] ]
]

{ #category : 'parsing' }
TonelMethodParser >> parseBody [
	"Answer the text between the brackets of the method body. TonelSourceScanner skips the brackets that are inside strings, comments, characters and blocks"

	^ (TonelSourceScanner on: stream) scan
]

{ #category : 'parsing' }
TonelMethodParser >> parseClassReferenceInto: aDeclaration [
	"Read 'ClassName >>' or 'ClassName class >>' and store the class name and side in aDeclaration"

	| reference parts |
	reference := String streamContents: [ :out |
		             [ stream atEnd or: [ stream peek = $[ or: [ self atMethodSeparator ] ] ] whileFalse: [ out nextPut: stream next ] ].
	self atMethodSeparator ifFalse: [ self error: 'Missing class reference before >>' ].
	stream skip: 2.
	parts := reference substrings.
	(parts isEmpty or: [ parts size > 2 or: [ parts size = 2 and: [ parts second ~= 'class' ] ] ]) ifTrue: [
		self error: 'Invalid class reference: ' , reference trimBoth ].
	(self isValidClassName: parts first) ifFalse: [ self error: 'Invalid class name: ' , parts first ].
	aDeclaration
		className: parts first;
		isMeta: parts size = 2
]

{ #category : 'parsing' }
TonelMethodParser >> parseMetadata [
	"Read the STON dictionary before the method, or answer an empty dictionary when there is none"

	| metadata |
	stream peek = ${ ifFalse: [ ^ Dictionary new ].
	metadata := [ (STON reader on: stream) next ]
		            on: STONReaderError
		            do: [ :error | self error: 'Invalid metadata: ' , error messageText ].
	metadata isDictionary ifFalse: [ self error: 'Metadata must be a dictionary' ].
	^ metadata
]

{ #category : 'parsing' }
TonelMethodParser >> parseMethod [
	"Read one method definition from the stream: optional metadata, class reference, selector pattern and body"

	| declaration pattern body |
	declaration := TonelMethodDeclaration new.
	self skipSeparators.
	declaration metadata: self parseMetadata.
	self skipSeparators.
	self parseClassReferenceInto: declaration.
	pattern := self parseSelectorPattern.
	body := self parseBody.
	declaration ast: (self parseMethodSource: pattern , body pattern: pattern).
	^ declaration
]

{ #category : 'parsing' }
TonelMethodParser >> parseMethodSource: aString pattern: aPattern [
	"Delegate the parsing of the method to OCParser. aPattern must hold only a selector pattern"

	| patternNode |
	patternNode := self ocParse: aPattern.
	(patternNode body statements isEmpty and: [ patternNode temporaries isEmpty and: [ patternNode pragmas isEmpty ] ]) ifFalse: [
		self error: 'Invalid selector pattern: ' , aPattern ].
	^ self ocParse: aString
]

{ #category : 'parsing' }
TonelMethodParser >> parseSelectorPattern [
	"Read the selector pattern up to the opening bracket of the body. Comments may contain brackets"

	| pattern |
	pattern := String streamContents: [ :out |
			           [ stream atEnd or: [ stream peek = $[ ] ] whileFalse: [
					           | char |
					           char := stream next.
					           out nextPut: char.
					           char = $" ifTrue: [
							           out nextPutAll: (stream upTo: $").
							           stream atEnd ifTrue: [ self error: 'Unclosed comment in selector pattern' ].
							           out nextPut: $" ] ] ].
	stream atEnd ifTrue: [ self error: 'Missing method body' ].
	pattern := pattern trimBoth.
	pattern ifEmpty: [ self error: 'Missing selector pattern' ].
	^ pattern
]

{ #category : 'private' }
TonelMethodParser >> skipSeparators [

	[ stream atEnd not and: [ stream peek isSeparator ] ] whileTrue: [ stream next ]
]
