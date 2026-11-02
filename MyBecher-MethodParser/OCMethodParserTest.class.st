"
I test `OCMethodParser` and the `OCMethodDeclaration` instances it returns: instance-side and class-side methods, the metadata, brackets inside the body, comments in the selector pattern, and the errors.
"
Class {
	#name : 'OCMethodParserTest',
	#superclass : 'TestCase',
	#category : 'MyBecher-MethodParser-Tests',
	#package : 'MyBecher-MethodParser',
	#tag : 'Tests'
}

{ #category : 'tests' }
OCMethodParserTest >> testBinaryMethod [

	| declaration |
	declaration := OCMethodParser parse: 'Foo >> <= other [
	^ true
]'.
	self assert: declaration selector equals: #'<='.
	self assert: declaration ast argumentNames asArray equals: #( 'other' )
]

{ #category : 'tests' }
OCMethodParserTest >> testBracketsInsideBody [

	| declaration |
	declaration := OCMethodParser parse: 'Foo >> bar [
	"a ] comment"
	| b |
	b := [ :x | x ].
	^ { '']''. $]. b value: #( $[ ) }
]'.
	self assert: declaration selector equals: #bar.
	self assert: declaration ast body statements size equals: 2.
	self assert: declaration ast temporaryNames asArray equals: #( 'b' )
]

{ #category : 'tests' }
OCMethodParserTest >> testClassSideKeywordMethod [

	| declaration |
	declaration := OCMethodParser parse: 'Foo class >> x: aNumber y: anotherNumber [
	^ self new setX: aNumber y: anotherNumber
]'.
	self assert: declaration className equals: 'Foo'.
	self assert: declaration isMeta.
	self assert: declaration isClassSide.
	self assert: declaration selector equals: #x:y:.
	self assert: declaration ast argumentNames asArray equals: #( 'aNumber' 'anotherNumber' )
]

{ #category : 'tests' }
OCMethodParserTest >> testCommentInSelectorPattern [

	| declaration |
	declaration := OCMethodParser parse: 'Foo >> bar: x "see [ here" baz: y [
	^ x + y
]'.
	self assert: declaration selector equals: #bar:baz:.
	self assert: declaration ast argumentNames asArray equals: #( 'x' 'y' )
]

{ #category : 'tests' }
OCMethodParserTest >> testInstanceSideAPI [

	| declaration |
	declaration := OCMethodParser new parse: 'Foo class >> bar [ ^ 1 ]'.
	self assert: declaration isMeta.
	self assert: declaration selector equals: #bar
]

{ #category : 'tests' }
OCMethodParserTest >> testInstanceSideUnaryMethod [

	| declaration |
	declaration := OCMethodParser parse: 'Foo >> bar [
	^ 42
]'.
	self assert: declaration className equals: 'Foo'.
	self deny: declaration isMeta.
	self assert: declaration isInstanceSide.
	self assert: declaration selector equals: #bar.
	self assert: declaration ast isMethod.
	self assert: declaration ast body statements first isReturn
]

{ #category : 'tests' }
OCMethodParserTest >> testInvalidClassReference [

	self should: [ OCMethodParser parseTonel: 'Foo bar >> baz [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testMetadata [

	| declaration |
	declaration := OCMethodParser parse: '{ #category : ''accessing'', #foo : 3 }
Foo >> bar [
	^ 42
]'.
	self assert: declaration category equals: 'accessing'.
	self assert: (declaration metadata at: #foo) equals: 3
]

{ #category : 'tests' }
OCMethodParserTest >> testMissingBody [

	self should: [ OCMethodParser parse: 'Foo >> bar' ] raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testMissingClassReference [

	self should: [ OCMethodParser parseTonel: 'bar [ ^ 1 ]' ] raise: TonelParseError.
	self should: [ OCMethodParser parseTonel: '>> bar [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testNoMetadata [

	| declaration |
	declaration := OCMethodParser parse: 'Foo >> bar [ ^ 42 ]'.
	self assert: declaration metadata isEmpty.
	self assert: declaration category isNil
]

{ #category : 'tests' }
OCMethodParserTest >> testParseAll [

	| declarations |
	declarations := OCMethodParser parseAll: '
{ #category : ''accessing'' }
Foo >> bar [
	^ 1
]

{ #category : ''instance creation'' }
Foo class >> new: x [
	^ self new
]

Foo >> baz [ ^ 2 ]
'.
	self assert: declarations size equals: 3.
	self assert: (declarations collect: [ :each | each selector ]) asArray equals: #( #bar #new: #baz ).
	self assert: (declarations collect: [ :each | each isMeta ]) asArray equals: #( false true false ).
	self assert: (declarations collect: [ :each | each category ]) asArray equals: #( 'accessing' 'instance creation'
	   nil )
]

{ #category : 'tests' }
OCMethodParserTest >> testParseAllEmpty [

	self assert: (OCMethodParser parseAll: '  
 ') isEmpty
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testParsePlain [

	| declaration |
	declaration := OCMethodParser parsePlain: 'bar ^ 1'.
	self assert: declaration selector equals: #bar.
	self assert: (OCMethodParser new parsePlain: 'baz ^ 2') selector equals: #baz
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testParsePlainRejectsTonel [

	self
		should: [
				OCMethodParser parsePlain: 'Foo >> bar [
	^ 1
]' ]
		raise: TonelParseError
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testParseTonel [

	| declaration |
	declaration := OCMethodParser parseTonel: 'Foo class >> bar [ ^ 1 ]'.
	self assert: declaration className equals: 'Foo'.
	self assert: declaration isMeta
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testParseTonelRejectsPlain [

	self should: [ OCMethodParser parseTonel: 'bar ^ 1' ] raise: TonelParseError.
	self should: [ OCMethodParser new parseTonel: 'bar ^ 1' ] raise: TonelParseError
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainBinaryMethodNamedGreaterGreater [
	"Without a class name before it, >> is the selector of a plain method"

	| declaration |
	declaration := OCMethodParser parse: '>> other
	^ self'.
	self assert: declaration selector equals: #'>>'.
	self assert: declaration className isNil
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainEmptyStringIsAnError [

	self should: [ OCMethodParser parse: '  ' ] raise: TonelParseError
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainKeywordMethodWithPragmaAndTemporaries [

	| declaration |
	declaration := OCMethodParser parse: 'x: aNumber y: anotherNumber
	<sampleInstance>
	| sum |
	sum := aNumber + anotherNumber.
	^ sum'.
	self assert: declaration selector equals: #x:y:.
	self assert: declaration ast argumentNames asArray equals: #( 'aNumber' 'anotherNumber' ).
	self assert: declaration ast temporaryNames asArray equals: #( 'sum' ).
	self assert: (declaration ast hasPragmaNamed: #sampleInstance)
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodSurroundedBySeparators [

	| declaration |
	declaration := OCMethodParser parse: '
  bar ^ 1
'.
	self assert: declaration selector equals: #bar.
	self assert: declaration sourceCode equals: 'bar ^ 1'
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainMethodWhoseBodyIsABlock [
	"Without a class reference, the brackets are a block in a plain method"

	| declaration |
	declaration := OCMethodParser parse: 'bar [ ^ 1 ]'.
	self assert: declaration selector equals: #bar.
	self assert: declaration className isNil.
	self assert: declaration ast body statements first isBlock
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainPrintString [

	self assert: (OCMethodParser parse: 'bar ^ 1') printString equals: '#bar'.
	self assert: (OCMethodParser parse: 'Foo class >> bar [ ^ 1 ]') printString equals: 'Foo class >> #bar'
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainSyntaxError [

	self
		should: [
				OCMethodParser parse: 'bar
	^ ( 1' ]
		raise: TonelParseError
]

{ #category : 'tests - plain' }
OCMethodParserTest >> testPlainUnaryMethod [

	| source declaration |
	source := 'bar
	"Answer the answer"
	^ 42'.
	declaration := OCMethodParser parse: source.
	self assert: declaration selector equals: #bar.
	self assert: declaration className isNil.
	self deny: declaration isMeta.
	self assert: declaration metadata isEmpty.
	self assert: declaration sourceCode equals: source.
	self assert: declaration ast body statements first isReturn
]

{ #category : 'tests' }
OCMethodParserTest >> testPragmaAndTemporaries [

	| declaration |
	declaration := OCMethodParser parse: 'Foo class >> example [
	<sampleInstance>
	| a |
	a := 3.
	^ a
]'.
	self assert: declaration isMeta.
	self assert: (declaration ast hasPragmaNamed: #sampleInstance).
	self assert: declaration ast temporaryNames asArray equals: #( 'a' )
]

{ #category : 'tests' }
OCMethodParserTest >> testSelectorPatternMismatchIsAnError [
	"The text between >> and [ must be only a selector pattern"

	self should: [ OCMethodParser parse: 'Foo >> bar baz [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testSeveralMethodsWithParseIsAnError [

	self
		should: [
				OCMethodParser parse: 'Foo >> bar [ ^ 1 ]
Foo >> baz [ ^ 2 ]' ]
		raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testSourceCodeIsPatternAndBody [

	| declaration |
	declaration := OCMethodParser parse: '{ #category : ''accessing'' }
Foo >> bar: x [
	^ x
]
'.
	self assert: declaration sourceCode lines equals: #( 'bar: x' '	^ x' )
]

{ #category : 'tests' }
OCMethodParserTest >> testSyntaxErrorInBody [

	self
		should: [
				OCMethodParser parse: 'Foo >> bar [
	^ ( 1
]' ]
		raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testTrailingCharacters [

	self should: [ OCMethodParser parse: 'Foo >> bar [ ^ 1 ] garbage' ] raise: TonelParseError
]

{ #category : 'tests' }
OCMethodParserTest >> testUnclosedBody [

	self should: [ OCMethodParser parse: 'Foo >> bar [ ^ 1' ] raise: TonelParseError
]
