"
you can create labels as you need them
if you have a jump forward, you create the label there, and ""assign it"" to the target node (can use a dictionary)
when you arrive to the target node you check: do I have a label associated? If so, you emit it.
jump backwards look tricky, but actually are not so, because the AST is structured
backward jumps only happen on loops
"
Class {
	#name : 'SmiTreeToStackVisitor',
	#superclass : 'SmiAbstractNodeVisitor',
	#instVars : [
		'instructions'
	],
	#category : 'SmiStefPlayground',
	#package : 'SmiStefPlayground'
}

{ #category : 'initialization' }
SmiTreeToStackVisitor >> initialize [ 
	super initialize.
	instructions := OrderedCollection new
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> instructions [

	^ instructions
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> push: aValue [

	self pushInstruction: 'push ', aValue asString 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> pushInstruction: anInstruction [

	instructions addLast: anInstruction 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> pushVariable: aValue [

	self pushInstruction: 'pushVariable ', aValue asString 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> send: aValue [

	self pushInstruction: 'send ', aValue asString 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> storeVariable: aValue [

	self pushInstruction: 'storeVariable ', aValue asString 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visit: aNode [

	aNode acceptVisitor: self
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visitAssignment: anAssignemnt [

	"we can get an expression"
	self visit: anAssignemnt value.
	
	self storeVariable: anAssignemnt variable value. 
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visitBinaryOperator: aBin [

	self visit: aBin left.
	self visit: aBin right.
	self send: aBin operator value  
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visitFunction: aFunction [

	aFunction body statements do: [ :each | self visit: each  ]
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visitNumber: aNumber [

	self push: aNumber value value
]

{ #category : 'initialization' }
SmiTreeToStackVisitor >> visitVariableRead: aVariable [

	self pushVariable: aVariable variable value
]
