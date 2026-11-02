"
I parse one Pharo method given either as a Tonel method definition (without the class definition around it) or as a plain Pharo method. In Tonel I handle instance-side methods (`Foo >> bar [ ... ]`) and class-side methods (`Foo class >> bar [ ... ]`). A plain method is a selector pattern followed by its body, as shown in the browser (`bar ^ 42`).

## Responsibility:

- I tell Tonel from plain source: Tonel starts with metadata (`{`) or with `ClassName >>` / `ClassName class >>`. Anything else is a plain method.
- For Tonel, I read the optional STON metadata (`{ #category : 'accessing' }`), the class reference, the selector pattern, and the body between its brackets. Brackets inside strings, comments, characters and nested blocks don't end the body.
- I give the method source to `OCParser`, which builds the AST. Any syntax error is signalled as a `TonelParseError`.

## Collaborators:

- `TonelSourceScanner` finds the end of a Tonel method body.
- `OCParser` parses the method source into an `OCMethodNode`.
- `STON` reads the Tonel metadata.
- `OCMethodDeclaration` is what I return for each method.

## Public API and Key Messages

- `OCMethodParser parse: aString` detects the format and returns one `OCMethodDeclaration`. The string must contain exactly one method.
- `OCMethodParser parseTonel: aString` and `OCMethodParser parsePlain: aString` force one format. Use them when the format is known: for example `bar [ ^ 1 ]` is a plain method whose body is a block, but an error for `parseTonel:`.
- `OCMethodParser parseAll: aString` returns the collection of `OCMethodDeclaration` for a string with several Tonel methods. Plain methods have no delimiters, so they can't be listed this way.
- The same messages exist on the instance side: `OCMethodParser new parse: aString`.

```
| declaration |
declaration := OCMethodParser parse: '{ #category : ''arithmetic'' }
Fraction class >> half: aNumber [
	""Answer half of aNumber""
	^ aNumber / 2
]'.
declaration isClassSide. ""true""
declaration selector. ""#half:""

(OCMethodParser parse: 'double: x
	^ x * 2') selector. ""#double:""
```

Run `OCMethodParser class >> #scriptParseMethods` to inspect several parsed methods.

## Internal Representation

- `stream`: the `ReadStream` on the Tonel source being parsed.

### Implementation Points

- For Tonel, the source given to `OCParser` is the selector pattern followed by the body, as Tonel stores it. For plain methods, it is the whole string without the surrounding separators.
- Comments are allowed in a Tonel selector pattern, and a `[` inside them is not taken as the start of the body.
"
Class {
	#name : 'OCMethodParser',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'MyBecher-MethodParser-Core',
	#package : 'MyBecher-MethodParser',
	#tag : 'Core'
}

{ #category : 'parsing' }
OCMethodParser class >> parse: aString [
	"Parse aString, which holds exactly one method, Tonel or plain Pharo, and answer an OCMethodDeclaration"

	^ self new parse: aString
]

{ #category : 'parsing' }
OCMethodParser class >> parseAll: aString [
	"Parse aString, which holds zero or more Tonel method definitions, and answer a collection of OCMethodDeclaration"

	^ self new parseAll: aString
]

{ #category : 'parsing' }
OCMethodParser class >> parsePlain: aString [
	"Parse aString, a plain Pharo method (selector pattern and body), and answer an OCMethodDeclaration"

	^ self new parsePlain: aString
]

{ #category : 'parsing' }
OCMethodParser class >> parseTonel: aString [
	"Parse aString, which holds exactly one Tonel method definition, and answer an OCMethodDeclaration"

	^ self new parseTonel: aString
]

{ #category : 'script' }
OCMethodParser class >> scriptParseMethods [
	"Parse an instance-side and a class-side Tonel method, and a plain Pharo method, then inspect the declarations with their ASTs"

	<script>
	| declarations |
	declarations := self parseAll: '{ #category : ''accessing'' }
Counter >> increment [
	count := count + 1.
	^ count
]

{ #category : ''instance creation'' }
Counter class >> startingAt: anInteger [
	^ self new setCount: anInteger
]'.
	declarations add: (self parse: 'reset
	count := 0').
	declarations inspect
]

{ #category : 'private' }
OCMethodParser >> atMethodSeparator [
	"Answer whether the stream is positioned on the >> between the class reference and the selector pattern"

	| position |
	position := stream position.
	^ [ stream next = $> and: [ stream next = $> ] ] ensure: [ stream position: position ]
]

{ #category : 'private' }
OCMethodParser >> error: aString [
	"Signal parse errors as TonelParseError, the error used by the rest of Tonel"

	^ TonelParseError signal: aString
]

{ #category : 'testing' }
OCMethodParser >> isTonel: aString [
	"Answer whether aString starts like a Tonel method definition: metadata, or 'ClassName >>' or 'ClassName class >>'"

	| input word |
	input := aString readStream.
	input skipSeparators.
	input peek = ${ ifTrue: [ ^ true ].
	word := self nextWordFrom: input.
	(word isEmpty or: [ word first isLetter not ]) ifTrue: [ ^ false ].
	input skipSeparators.
	(input atEnd not and: [ input peek isLetter ]) ifTrue: [
			(self nextWordFrom: input) = 'class' ifFalse: [ ^ false ].
			input skipSeparators ].
	^ (input next: 2) = '>>'
]

{ #category : 'private' }
OCMethodParser >> isValidClassName: aString [

	^ aString first isLetter and: [ aString allSatisfy: [ :char | char isAlphaNumeric or: [ char = $_ ] ] ]
]

{ #category : 'private' }
OCMethodParser >> nextWordFrom: aStream [

	^ String streamContents: [ :out |
		  [ aStream atEnd not and: [ aStream peek isAlphaNumeric or: [ aStream peek = $_ ] ] ] whileTrue: [ out nextPut: aStream next ] ]
]

{ #category : 'private' }
OCMethodParser >> ocParse: aString [

	^ [ OCParser parseMethod: aString ]
		  on: OCCodeError
		  do: [ :error | self error: 'Syntax error: ' , error messageText ]
]

{ #category : 'parsing' }
OCMethodParser >> parse: aString [
	"Parse aString, which holds exactly one method, and answer an OCMethodDeclaration. The method is either a Tonel method definition or a plain Pharo method (selector pattern and body)"

	^ (self isTonel: aString)
		  ifTrue: [ self parseTonel: aString ]
		  ifFalse: [ self parsePlain: aString ]
]

{ #category : 'parsing' }
OCMethodParser >> parseAll: aString [
	"Parse aString, which holds zero or more Tonel method definitions, and answer a collection of OCMethodDeclaration"

	stream := aString readStream.
	^ OrderedCollection streamContents: [ :declarations |
			  [
				  self skipSeparators.
				  stream atEnd ] whileFalse: [ declarations nextPut: self parseMethod ] ]
]

{ #category : 'parsing' }
OCMethodParser >> parseBody [
	"Answer the text between the brackets of the method body. TonelSourceScanner skips the brackets that are inside strings, comments, characters and blocks"

	^ (TonelSourceScanner on: stream) scan
]

{ #category : 'parsing' }
OCMethodParser >> parseClassReferenceInto: aDeclaration [
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
OCMethodParser >> parseMetadata [
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
OCMethodParser >> parseMethod [
	"Read one method definition from the stream: optional metadata, class reference, selector pattern and body"

	| declaration pattern body |
	declaration := OCMethodDeclaration new.
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
OCMethodParser >> parseMethodSource: aString pattern: aPattern [
	"Delegate the parsing of the method to OCParser. aPattern must hold only a selector pattern"

	| patternNode |
	patternNode := self ocParse: aPattern.
	(patternNode body statements isEmpty and: [ patternNode temporaries isEmpty and: [ patternNode pragmas isEmpty ] ]) ifFalse: [
		self error: 'Invalid selector pattern: ' , aPattern ].
	^ self ocParse: aString
]

{ #category : 'parsing' }
OCMethodParser >> parsePlain: aString [
	"Parse aString, a plain Pharo method made of a selector pattern and a body, and answer an OCMethodDeclaration without class name nor metadata"

	| source |
	source := aString trimBoth.
	source ifEmpty: [ self error: 'Missing method' ].
	^ OCMethodDeclaration new
		  ast: (self ocParse: source);
		  yourself
]

{ #category : 'parsing' }
OCMethodParser >> parseSelectorPattern [
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

{ #category : 'parsing' }
OCMethodParser >> parseTonel: aString [
	"Parse aString, which holds exactly one Tonel method definition, and answer an OCMethodDeclaration"

	| declaration |
	stream := aString readStream.
	declaration := self parseMethod.
	self skipSeparators.
	stream atEnd ifFalse: [ self error: 'Unexpected characters after the method' ].
	^ declaration
]

{ #category : 'private' }
OCMethodParser >> skipSeparators [

	[ stream atEnd not and: [ stream peek isSeparator ] ] whileTrue: [ stream next ]
]
