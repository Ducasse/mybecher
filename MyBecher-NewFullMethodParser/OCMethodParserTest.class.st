"
I check that `OCMethodParser` parses a method written as a Tonel method definition (`Foo >> bar [ ^ 1 ]`), as well as a plain method as edited in a browser, which must give exactly the AST of the decorated `OCParser`.

For a Tonel definition, the AST is the one of the plain method, and the extra information of the definition is stored in properties of the `OCMethodNode`: `#protocol` (the `#category` entry of the metadata), `#className` and `#isClassSide`.

## Design Rationale

- A large part of the tests checks that plain methods are not mistaken for Tonel definitions, in particular the ones starting like a Tonel class reference (`foo class >> bar`).
- Node positions are checked against the Tonel text itself, because editors and the compiler report errors at these positions.
- The metadata is STON, so the tests use its escapes (`\'`, `é`). They build these texts with explicit `$\` characters, so the backslashes reach the image as written.
- The error cases (`should:raise:`) are in the `tests - errors` protocol, one case per test; the faulty ASTs of `parseFaultyMethod:` are checked in `tests - faulty`, and the use of another decorated parser in `tests - decorator`.
"
Class {
	#name : 'OCMethodParserTest',
	#superclass : 'OCParseTreeTest',
	#category : 'MyBecher-NewFullMethodParser-Tests',
	#package : 'MyBecher-NewFullMethodParser',
	#tag : 'Tests'
}

{ #category : 'helpers' }
OCMethodParserTest >> parserClass [

	^ OCMethodParser
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testBinaryMethod [

	| ast |
	ast := self parseMethod: 'Foo >> = other [ ^ true ]'.
	self assert: ast selector equals: #=.
	self assert: ast argumentNames asArray equals: #( #other )
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testBracketsInsideBody [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ ^ #( $] ) collect: [ :each | '']'' , each asString "]" ] ]'.
	self assert: ast body statements size equals: 1.
	self assert: ast body statements first value selector equals: #collect:
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testCharactersAfterClosingBracketRaisesError [

	self should: [ self parseMethod: 'Foo >> bar [ ^ 1 ] 2' ] raise: OCCodeError
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testClassName [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ ^ 1 ]'.
	self assert: (ast propertyAt: #className) equals: #Foo.
	self deny: (ast propertyAt: #isClassSide)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testClassSideMethod [

	| ast |
	ast := self parseMethod: 'Foo class >> bar: x [ ^ x ]'.
	self assert: ast selector equals: #bar:.
	self assert: (ast propertyAt: #className) equals: #Foo.
	self assert: (ast propertyAt: #isClassSide)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testClassSideMethodNamedLikeALiteral [

	| ast |
	ast := self parseMethod: 'Foo class >> nil [ ^ 1 ]'.
	self assert: ast selector equals: #nil.
	self assert: (ast propertyAt: #isClassSide)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testClassSideMethodWithoutSpaces [

	| ast |
	ast := self parseMethod: 'Foo class>>bar [ ^ 1 ]'.
	self assert: ast selector equals: #bar.
	self assert: (ast propertyAt: #isClassSide)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testCommentInPattern [

	| ast |
	ast := self parseMethod: 'Foo >> bar: x "a comment with [" [ ^ x ]'.
	self assert: ast selector equals: #bar:.
	self assert: ast body statements size equals: 1
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testCompileDefinition [

	| compiler method |
	compiler := OpalCompiler new
		            class: Object;
		            source: '{ #category : #a } Object >> fortyTwo [ ^ 40 + 2 ]';
		            yourself.
	compiler compilationContext parserClass: OCMethodParser.
	method := compiler compile.
	self assert: method selector equals: #fortyTwo.
	self assert: (method valueWithReceiver: Object new) equals: 42
]

{ #category : 'tests - decorator' }
OCMethodParserTest >> testDecoratedParserParsesPlainMethod [

	| parser ast |
	parser := OCMethodParser on: OCPatternParser new.
	parser initializeParserWith: 'bar ^ `@value'.
	ast := parser parseMethod.
	self assert: ast body statements first value isPatternNode.
	self deny: (ast hasProperty: #className)
]

{ #category : 'tests - decorator' }
OCMethodParserTest >> testDecoratedParserParsesTonelBody [

	| parser ast |
	parser := OCMethodParser on: OCPatternParser new.
	parser initializeParserWith: 'Foo >> bar [ ^ `@value ]'.
	ast := parser parseMethod.
	self assert: ast body statements first value isPatternNode.
	self assert: (ast propertyAt: #className) equals: #Foo
]

{ #category : 'tests - decorator' }
OCMethodParserTest >> testDefaultDecoratedParser [

	self assert: OCMethodParser new parser class equals: OCParser
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testEmptyBody [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ ]'.
	self assert: ast selector equals: #bar.
	self assert: ast body statements isEmpty
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testEmptyMetadataHasNoProtocol [

	| ast |
	ast := self parseMethod: '{ } Foo >> bar [ ^ 1 ]'.
	self assert: ast selector equals: #bar.
	self deny: (ast hasProperty: #protocol)
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testErrorInBodyRaisesError [

	self should: [ self parseMethod: 'Foo >> bar [ ^ 1 + ]' ] raise: OCCodeError
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyBracketInCommentIsNotTheClosingBracket [

	self assert: (self parseFaultyMethod: 'Foo >> bar [ ^ 1 "]"') isFaulty
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyCharacterLiteralIsNotTheClosingBracket [

	self assert: (self parseFaultyMethod: 'Foo >> bar [ ^ $]') isFaulty
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyConsumesEntireStream [

	| parser |
	parser := self parserClass new.
	parser initializeParserWith: 'Foo >> bar [ ^ 1 ] ^ 2 ]'.
	parser parseMethod.
	self assert: parser atEnd
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyErrorPositionIsInTheDefinition [

	| source ast error |
	source := 'Foo >> bar [ ^ 1 + ]'.
	ast := self parseFaultyMethod: source.
	error := ast allErrorNotices first.
	self assert: ast isFaulty.
	self assert: error position > (source indexOf: $[)
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyInvalidMetadata [

	| ast |
	ast := self parseFaultyMethod: '{ #category ''a'' } Foo >> bar [ ^ 1 ]'.
	self assert: ast isFaulty
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyMetadataConsumesEntireStream [

	| parser |
	parser := self parserClass new.
	parser initializeParserWith: '{ #category : } Foo >> bar [ ^ 1 ]'.
	parser parseMethod.
	self assert: parser atEnd
]

{ #category : 'tests - faulty' }
OCMethodParserTest >> testFaultyMissingClosingBracket [

	| ast |
	ast := self parseFaultyMethod: 'Foo >> bar [ ^ 1'.
	self assert: ast isFaulty.
	self assert: ast selector equals: #bar.
	self assert: (ast propertyAt: #className) equals: #Foo
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testInvalidEscapeInMetadataRaisesError [

	self
		should: [
		self parseMethod: (String streamContents: [ :stream | stream << '{ #category : ''a' << $\ << 'q'' } Foo >> bar [ ^ 1 ]' ]) ]
		raise: OCCodeError
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testKeywordMethod [

	| ast |
	ast := self parseMethod: 'Foo >> at: index put: anObject [ ^ anObject ]'.
	self assert: ast selector equals: #at:put:.
	self assert: ast argumentNames asArray equals: #( #index #anObject )
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testMetadataKeysAndValues [

	| ast |
	ast := self parseMethod: '{ ''category'' : #accessing, #count : -12, #flag : true, #none : nil } Foo >> q [ ]'.
	self assert: (ast propertyAt: #protocol) equals: #accessing
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMetadataWithoutClassReferenceRaisesError [

	self should: [ self parseMethod: '{ #category : #a } bar [ ^ 1 ]' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMissingBodyRaisesError [

	self should: [ self parseMethod: 'Foo >> bar ^ 1' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMissingClosingBracketRaisesError [

	self should: [ self parseMethod: 'Foo >> bar [ ^ 1' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMissingColonInMetadataRaisesError [

	self should: [ self parseMethod: '{ #category ''a'' } Foo >> bar [ ^ 1 ]' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMissingSelectorPatternRaisesError [

	self should: [ self parseMethod: 'Foo >> [ ^ 1 ]' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testMissingValueInMetadataRaisesError [

	self should: [ self parseMethod: '{ #category : } Foo >> bar [ ^ 1 ]' ] raise: OCCodeError
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testMultilineDefinition [

	| ast |
	ast := self parseMethod: (String cr join: #( '{ #category : ''accessing'' }' 'Foo >> bar: x [' '' '	"Answer x"' '	^ x' ']' '' )).
	self assert: ast selector equals: #bar:.
	self assert: (ast propertyAt: #protocol) equals: #accessing.
	self assert: ast comments first contents equals: 'Answer x'
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testNoMetadataHasNoProtocol [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ ^ 1 ]'.
	self deny: (ast hasProperty: #protocol)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testNodePositionsAfterEscapedMetadata [

	| ast |
	ast := self parseMethod: '{ #category : ''a\''b'' } Foo >> bar: x [ ^ x + 2 ]'.
	self assert: ast body statements first sourceCode equals: '^ x + 2'
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testNodePositionsAreInTheDefinition [

	| ast |
	ast := self parseMethod: '{ #category : #a } Foo >> bar: x [ ^ x + 2 ]'.
	self assert: ast body statements first sourceCode equals: '^ x + 2'.
	self assert: ast arguments first sourceCode equals: 'x'
]

{ #category : 'tests - decorator' }
OCMethodParserTest >> testPlainMethodGivesTheSameTreeAsTheDecoratedParser [

	| source |
	source := 'at: index put: anObject
	"Store anObject"
	<foo>
	| old |
	old := index.
	^ [ :x | x + old ] value: anObject'.
	self assert: (self parseMethod: source) equals: (OCParser parseMethod: source)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodHasNoTonelProperties [

	| ast |
	ast := self parseMethod: 'bar ^ 1'.
	self assert: ast selector equals: #bar.
	self deny: (ast hasProperty: #className).
	self deny: (ast hasProperty: #isClassSide).
	self deny: (ast hasProperty: #protocol)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodSourcesOfThisClassAreNotTonel [

	self class methods do: [ :method | self deny: ((self parseMethod: method sourceCode) hasProperty: #className) ]
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodWhoseBodyIsABlock [

	| ast |
	ast := self parseMethod: 'bar [ ^ 1 ]'.
	self assert: ast selector equals: #bar.
	self assert: ast body statements first isBlock.
	self deny: (ast hasProperty: #className)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodWhoseBodySendsToClass [

	| ast |
	ast := self parseMethod: 'foo class >> bar'.
	self assert: ast selector equals: #foo.
	self assert: ast body statements first selector equals: #'>>'.
	self deny: (ast hasProperty: #className)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodWhoseBodySendsToClassSide [

	| ast |
	ast := self parseMethod: 'foo classSide >> bar'.
	self assert: ast selector equals: #foo.
	self assert: ast body statements first selector equals: #'>>'.
	self deny: (ast hasProperty: #className)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodWhoseBodySendsToClassWithKeyword [

	| ast |
	ast := self parseMethod: 'Foo class >> bar max: 1'.
	self assert: ast selector equals: #Foo.
	self assert: ast body statements first selector equals: #max:.
	self deny: (ast hasProperty: #className)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testProtocolFromMetadata [

	| ast |
	ast := self parseMethod: '{ #category : ''accessing'' } Foo >> bar [ ^ 1 ]'.
	self assert: (ast propertyAt: #protocol) equals: #accessing
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testProtocolFromMetadataWithSeveralEntries [

	| ast |
	ast := self parseMethod: '{ #other : 42, #category : #''instance creation'' } Foo class >> new [ ^ 1 ]'.
	self assert: (ast propertyAt: #protocol) equals: #'instance creation'
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testProtocolWithEscapedCharacters [

	| definition expected ast |
	definition := String streamContents: [ :stream |
		              stream << '{ #category : ''caf' << $\ << 'u00E9 ' << $\ << $\ << ' ' << $\ << '/'' } Foo >> q [ ]' ].
	expected := String streamContents: [ :stream | stream << 'caf' << (Character value: 16rE9) << ' ' << $\ << ' /' ].
	ast := self parseMethod: definition.
	self assert: (ast propertyAt: #protocol) equals: expected asSymbol
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testProtocolWithEscapedQuotes [

	| ast |
	ast := self parseMethod: '{ #category : ''drag\''n\''drop'' } Foo >> q [ ]'.
	self assert: (ast propertyAt: #protocol) equals: #'drag''n''drop'
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testSourceIsTheDefinition [

	| source ast |
	source := '{ #category : #a } Foo >> bar [ ^ 1 + 2 ]'.
	ast := self parseMethod: source.
	self assert: ast source equals: source
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testTemporariesAndPragmas [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ <foo: 1> | a | a := 1. ^ a ]'.
	self assert: ast pragmas size equals: 1.
	self assert: ast pragmas first selector equals: #foo:.
	self assert: ast temporaryNames asArray equals: #( #a ).
	self assert: ast body statements size equals: 2
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testTraitClassSideMethod [

	| ast |
	ast := self parseMethod: '{ #category : #a } TFoo classSide >> bar [ ^ 1 ]'.
	self assert: ast selector equals: #bar.
	self assert: (ast propertyAt: #className) equals: #TFoo.
	self assert: (ast propertyAt: #isClassSide)
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testUnaryMethod [

	| ast |
	ast := self parseMethod: 'Foo >> bar [ ^ 1 ]'.
	self assert: ast selector equals: #bar.
	self assert: ast body statements size equals: 1.
	self assert: ast body statements first isReturn
]

{ #category : 'tests - tonel' }
OCMethodParserTest >> testUnaryMethodNamedLikeALiteral [

	| ast |
	ast := self parseMethod: 'Foo >> true [ ^ 1 ]'.
	self assert: ast selector equals: #true.
	self assert: (ast propertyAt: #className) equals: #Foo
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testUnclosedMetadataRaisesError [

	self should: [ self parseMethod: '{ #category : #a Foo >> bar [ ^ 1 ]' ] raise: OCCodeError
]

{ #category : 'tests - errors' }
OCMethodParserTest >> testUnclosedStringInMetadataRaisesError [

	self should: [ self parseMethod: '{ #category : ''unclosed } Foo >> bar [ ^ 1 ]' ] raise: OCCodeError
]
