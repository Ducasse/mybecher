"
I test `TonelMethodParser` and the `TonelMethodDeclaration` instances it returns: instance-side and class-side methods, the metadata, brackets inside the body, comments in the selector pattern, and the errors.
"
Class {
	#name : 'TonelMethodParserTest',
	#superclass : 'TestCase',
	#category : 'MyBecher-MethodParser-Tests',
	#package : 'MyBecher-MethodParser',
	#tag : 'Tests'
}

{ #category : 'tests' }
TonelMethodParserTest >> testBinaryMethod [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo >> <= other [
	^ true
]'.
	self assert: declaration selector equals: #'<='.
	self assert: declaration ast argumentNames asArray equals: #( 'other' )
]

{ #category : 'tests' }
TonelMethodParserTest >> testBracketsInsideBody [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo >> bar [
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
TonelMethodParserTest >> testClassSideKeywordMethod [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo class >> x: aNumber y: anotherNumber [
	^ self new setX: aNumber y: anotherNumber
]'.
	self assert: declaration className equals: 'Foo'.
	self assert: declaration isMeta.
	self assert: declaration isClassSide.
	self assert: declaration selector equals: #x:y:.
	self assert: declaration ast argumentNames asArray equals: #( 'aNumber' 'anotherNumber' )
]

{ #category : 'tests' }
TonelMethodParserTest >> testCommentInSelectorPattern [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo >> bar: x "see [ here" baz: y [
	^ x + y
]'.
	self assert: declaration selector equals: #bar:baz:.
	self assert: declaration ast argumentNames asArray equals: #( 'x' 'y' )
]

{ #category : 'tests' }
TonelMethodParserTest >> testInstanceSideAPI [

	| declaration |
	declaration := TonelMethodParser new parse: 'Foo class >> bar [ ^ 1 ]'.
	self assert: declaration isMeta.
	self assert: declaration selector equals: #bar
]

{ #category : 'tests' }
TonelMethodParserTest >> testInstanceSideUnaryMethod [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo >> bar [
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
TonelMethodParserTest >> testInvalidClassReference [

	self should: [ TonelMethodParser parse: 'Foo bar >> baz [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testMetadata [

	| declaration |
	declaration := TonelMethodParser parse: '{ #category : ''accessing'', #foo : 3 }
Foo >> bar [
	^ 42
]'.
	self assert: declaration category equals: 'accessing'.
	self assert: (declaration metadata at: #foo) equals: 3
]

{ #category : 'tests' }
TonelMethodParserTest >> testMissingBody [

	self should: [ TonelMethodParser parse: 'Foo >> bar' ] raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testMissingClassReference [

	self should: [ TonelMethodParser parse: 'bar [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testNoMetadata [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo >> bar [ ^ 42 ]'.
	self assert: declaration metadata isEmpty.
	self assert: declaration category isNil
]

{ #category : 'tests' }
TonelMethodParserTest >> testParseAll [

	| declarations |
	declarations := TonelMethodParser parseAll: '
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
TonelMethodParserTest >> testParseAllEmpty [

	self assert: (TonelMethodParser parseAll: '  
 ') isEmpty
]

{ #category : 'tests' }
TonelMethodParserTest >> testPragmaAndTemporaries [

	| declaration |
	declaration := TonelMethodParser parse: 'Foo class >> example [
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
TonelMethodParserTest >> testSelectorPatternMismatchIsAnError [
	"The text between >> and [ must be only a selector pattern"

	self should: [ TonelMethodParser parse: 'Foo >> bar baz [ ^ 1 ]' ] raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testSeveralMethodsWithParseIsAnError [

	self
		should: [
				TonelMethodParser parse: 'Foo >> bar [ ^ 1 ]
Foo >> baz [ ^ 2 ]' ]
		raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testSourceCodeIsPatternAndBody [

	| declaration |
	declaration := TonelMethodParser parse: '{ #category : ''accessing'' }
Foo >> bar: x [
	^ x
]
'.
	self assert: declaration sourceCode lines equals: #( 'bar: x' '	^ x' )
]

{ #category : 'tests' }
TonelMethodParserTest >> testSyntaxErrorInBody [

	self
		should: [
				TonelMethodParser parse: 'Foo >> bar [
	^ ( 1
]' ]
		raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testTrailingCharacters [

	self should: [ TonelMethodParser parse: 'Foo >> bar [ ^ 1 ] garbage' ] raise: TonelParseError
]

{ #category : 'tests' }
TonelMethodParserTest >> testUnclosedBody [

	self should: [ TonelMethodParser parse: 'Foo >> bar [ ^ 1' ] raise: TonelParseError
]
