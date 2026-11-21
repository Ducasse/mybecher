"
I am the common superclass of the Toplo inspector tests. I give each test a `BlSpace` on a `BlHeadlessHost`, so events can be simulated with `eventSimulator` and elements laid out with `space settle` without opening an OS window. `tearDown` closes the space.
"
Class {
	#name : 'ToInspectorTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'space'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'testing' }
ToInspectorTestCase class >> isAbstract [

	^ self == ToInspectorTestCase
]

{ #category : 'helpers' }
ToInspectorTestCase >> boundsInSpaceOf: anElement [

	space settle.
	^ anElement bounds inSpace asRectangle
]

{ #category : 'helpers' }
ToInspectorTestCase >> marginBoxOf: anElement [
	"Answer the rectangle covered by anElement and its margin, in space coordinates."

	| bounds margin |
	bounds := self boundsInSpaceOf: anElement.
	margin := anElement margin.
	^ Rectangle origin: bounds origin - margin topLeft corner: bounds corner + (margin right @ margin bottom)
]

{ #category : 'running' }
ToInspectorTestCase >> setUp [

	super setUp.
	space := BlSpace new.
	space host: BlHeadlessHost default
]

{ #category : 'running' }
ToInspectorTestCase >> tearDown [

	space close.
	super tearDown
]
