Class {
	#name : 'SmiStefParserTest',
	#superclass : 'TestCase',
	#category : 'SmiStefPlayground',
	#package : 'SmiStefPlayground'
}

{ #category : 'tests' }
SmiStefParserTest >> testAssignemnt [

	| ast |
	ast := SmiParser parse: 'function f() {
    a := 1;
    return a;
}'.
	self assert: ast functions first name value equals: 'f'.
	self assert: ast functions first body statements first class equals: SmiAssignmentNode.
	self assert: ast functions first body statements first variable value equals: 'a'.
	
	self assert: ast functions first body statements second expression class equals: SmiVariableReadNode.
	
]

{ #category : 'tests' }
SmiStefParserTest >> testFunction1Plus2 [

	| ast |
	ast := SmiParser parse: 'function answer() {
    return 1 + 2;
}'.
	self assert: ast functions first name value equals: 'answer'.
	self assert: ast functions first body statements first class equals: SmiReturnNode.
	
	self assert: ast functions first body statements first expression class equals: SmiBinaryOperatorNode.
	
	
]

{ #category : 'tests' }
SmiStefParserTest >> testFunction1Plus2Mult [

	| ast |
	ast := SmiParser parse: 'function answer() {
    return 1 + 2 * 6;
}'.
	self assert: ast functions first name value equals: 'answer'.
	self assert: ast functions first body statements first class equals: SmiReturnNode.
	
	self assert: ast functions first body statements first expression class equals: SmiBinaryOperatorNode.
	
	
]

{ #category : 'tests' }
SmiStefParserTest >> testFunction42 [

	| ast |
	ast := SmiParser parse: 'function answer() {
    return 42;
}'.
	self assert: ast functions first name value equals: 'answer'.
	self assert: ast functions first body statements first class equals: SmiReturnNode.
	self assert: ast functions first body statements first expression value value equals: '42'.
	
	
]

{ #category : 'tests' }
SmiStefParserTest >> testFunctionAdd [

	| ast |
	ast := SmiParser parse: 'function add(a, b) {
    return a + b;
}'.
	self assert: ast functions first name value equals: 'add'.
	self assert: ast functions first body statements first class equals: SmiReturnNode 
]

{ #category : 'tests' }
SmiStefParserTest >> testFunctionEmptyFoo [

	SmiParser parse: 'function foo() {
}'
]

{ #category : 'tests' }
SmiStefParserTest >> testFunctionFooReturns1 [

	| ast |
	ast := SmiParser parse: 'function foo() {
    return 1;
}'.

	self assert: ast functions size equals: 1.
]

{ #category : 'tests' }
SmiStefParserTest >> testFunctionWithVariable [

	| ast |
	ast := SmiParser parse: 'function add(a, b) {
    return a + b;
}'.
	self assert: ast functions first name value equals: 'add'.
	self assert: ast functions first body statements first class equals: SmiReturnNode.
	
	self assert: ast functions first body statements first expression class equals: SmiBinaryOperatorNode.
	self assert: ast functions first body statements first expression left class equals: SmiVariableReadNode .	
	
]

{ #category : 'tests' }
SmiStefParserTest >> testFunctions [

	| ast |
	ast := SmiParser parse: 'function add(a, b) {
    return a + b;
}

function main() {
    return add(1, 2);
}'.
	self assert: ast functions size equals: 2 
]

{ #category : 'tests' }
SmiStefParserTest >> testPositive [

	| ast |
	ast := SmiParser parse: 'function positive(a) {
    if a > 0 then {
        Print "positive";
    }
}'.
	self assert: ast functions first name value equals: 'positive'.
	self assert: ast functions first body statements first class equals: SmiConditionalNode .
	
	self assert: ast functions first body statements first condition class equals: SmiBinaryOperatorNode.
	self assert: ast functions first body statements first body statements first class equals: SmiPrintStatementNode .
	
]

{ #category : 'tests' }
SmiStefParserTest >> testf [

	| ast |
	ast := SmiParser parse: 'function f() {
    a := 1;
    return a;
}'.
	self assert: ast functions first name value equals: 'f'.
	self assert: ast functions first body statements first class equals: SmiAssignmentNode.
	
	self assert: ast functions first body statements second expression class equals: SmiVariableReadNode.
	
]

{ #category : 'tests' }
SmiStefParserTest >> testf2 [

	| ast |
	ast := SmiParser parse: 'function f2() {
    a := 1;
    a := a + 2;
    return a;
}'.
	self assert: ast functions first name value equals: 'f2'.
	self assert: ast functions first body statements third class equals: SmiReturnNode.
	
	self assert: ast functions first body statements third expression class equals: SmiVariableReadNode.
	
]
