Class {
	#name : 'SmiTreeToStackVisitorTest',
	#superclass : 'TestCase',
	#category : 'SmiStefPlayground',
	#package : 'SmiStefPlayground'
}

{ #category : 'tests' }
SmiTreeToStackVisitorTest >> testFunction1Plus2 [

	| ast vis |
	ast := SmiParser parse: 'function answer() {
    return 1 + 2;
}'.
	vis := SmiTreeToStackVisitor new.
	vis visit: ast.
	self 
		assert: vis instructions asArray
		equals: #( 
			'push 1' 
			'push 2'
			'send +'
			)
]

{ #category : 'tests' }
SmiTreeToStackVisitorTest >> testFunction1Plus2Mult [

	| ast vis |
	ast := SmiParser parse: 'function answer() {
    return 1 + 2 * 6;
}'.
	vis := SmiTreeToStackVisitor new.
	vis visit: ast.
	self 
		assert: vis instructions asArray
		equals: #( 
			'push 1' 
			'push 2'
			'push 6'
			'send *'
			'send +'
			)
]

{ #category : 'tests' }
SmiTreeToStackVisitorTest >> testFunctionStore [

	| ast vis |
	ast := SmiParser parse: 'function store() {
    a := 1;
    b := a + 10;
}'.
	vis := SmiTreeToStackVisitor new.
	vis visit: ast.
	self 
		assert: vis instructions asArray
		equals: #( 
			'push 1' 
			'storeVariable a'
			'pushVariable a'
			'push 10'
			'send +'
			'storeVariable b'
			)
]

{ #category : 'tests' }
SmiTreeToStackVisitorTest >> testPositive [

	| ast vis |
	ast := SmiParser parse: 'function positive(x) {
    if x > 1 then {
        10;
    };
	20
}'.

	vis := SmiTreeToStackVisitor new.
	vis visit: ast.
	self 
		assert: vis instructions asArray
		equals: #( 
			'push 2' 
			'push 1'
			'push >'
			'jump'
			'send *'
			'send +'
			)
]
