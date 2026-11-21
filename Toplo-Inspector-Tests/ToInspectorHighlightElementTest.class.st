"
I check that `ToInspectorHighlightElement` covers the margin box of the highlighted element in space coordinates, stays on top of the space root without catching the mouse, and moves from one element to another or leaves the space.
"
Class {
	#name : 'ToInspectorHighlightElementTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'target',
		'other',
		'highlight'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'running' }
ToInspectorHighlightElementTest >> setUp [

	| container |
	super setUp.
	container := BlElement new
		             position: 10 @ 10;
		             extent: 300 @ 200;
		             yourself.
	target := BlElement new
		          position: 30 @ 40;
		          extent: 50 @ 20;
		          margin: (BlInsets
			           top: 1
			           right: 2
			           bottom: 3
			           left: 4);
		          yourself.
	other := BlElement new
		         position: 100 @ 120;
		         extent: 40 @ 30;
		         yourself.
	container addChildren: {
		target.
		other }.
	space root addChild: container.
	space show.
	highlight := ToInspectorHighlightElement new
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightCoversMarginBox [

	highlight highlight: target.

	self assert: (self boundsInSpaceOf: highlight) equals: (36 @ 49 corner: 92 @ 73).
	self assert: (self boundsInSpaceOf: highlight) equals: (self marginBoxOf: target)
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightFollowsHighlightedElementOnly [

	highlight highlight: target.
	highlight highlight: other.
	target position: 0 @ 0.

	self assert: (self boundsInSpaceOf: highlight) equals: (self boundsInSpaceOf: other)
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightIsAboveElements [

	highlight highlight: target.
	space settle.

	self assert: space root children sortedByElevation last identicalTo: highlight
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightIsAddedToSpaceRoot [

	highlight highlight: target.

	self assert: highlight parent identicalTo: space root
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightKnowsHighlightedElement [

	highlight highlight: target.

	self assert: highlight highlightedElement identicalTo: target
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightLetsMouseEventsThrough [

	highlight highlight: target.
	space settle.

	self assert: (space root findMouseEventTargetAt: (self boundsInSpaceOf: target) center) identicalTo: target
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightWithoutMarginCoversBounds [

	highlight highlight: other.

	self assert: (self boundsInSpaceOf: highlight) equals: (self boundsInSpaceOf: other)
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testHighlightingAnotherElementMovesHighlight [

	highlight highlight: target.
	highlight highlight: other.

	self assert: highlight highlightedElement identicalTo: other.
	self assert: (self boundsInSpaceOf: highlight) equals: (self boundsInSpaceOf: other).
	self assert: (space root children count: [ :each | each == highlight ]) equals: 1
]

{ #category : 'tests - errors' }
ToInspectorHighlightElementTest >> testHighlightingDetachedElementRaisesError [

	self should: [ highlight highlight: BlElement new ] raise: Error
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testNewHighlightHighlightsNothing [

	self assert: highlight highlightedElement isNil
]

{ #category : 'tests' }
ToInspectorHighlightElementTest >> testUnhighlightRemovesHighlight [

	highlight highlight: target.
	highlight unhighlight.

	self assert: highlight parent isNil.
	self assert: highlight highlightedElement isNil
]
