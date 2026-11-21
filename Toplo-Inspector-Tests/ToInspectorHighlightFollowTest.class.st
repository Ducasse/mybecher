"
I check that `ToInspectorHighlightElement` follows the highlighted element when it or an ancestor moves, when it is resized, and when its margin, border or padding change; that it leaves the space with the element; and that once it highlights another element, the previous one no longer moves or removes it.
"
Class {
	#name : 'ToInspectorHighlightFollowTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'container',
		'target',
		'other',
		'highlight'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'running' }
ToInspectorHighlightFollowTest >> setUp [

	super setUp.
	container := BlElement new
		             position: 10 @ 10;
		             extent: 300 @ 200;
		             yourself.
	target := BlElement new
		          position: 30 @ 40;
		          extent: 50 @ 20;
		          margin: (BlInsets all: 5);
		          yourself.
	other := BlElement new
		         position: 150 @ 100;
		         extent: 40 @ 30;
		         yourself.
	container addChildren: {
		target.
		other }.
	space root addChild: container.
	space show.
	highlight := ToInspectorHighlightElement new.
	highlight highlight: target.
	space settle
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testBoxesFollowBorderChange [

	target border: (BlBorder paint: Color black width: 3).

	self assert: (self boundsInSpaceOf: highlight paddingBox) equals: ((self boundsInSpaceOf: target) insetBy: 3)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testBoxesFollowPaddingChange [

	target padding: (BlInsets all: 6).

	self assert: (self boundsInSpaceOf: highlight contentBox) equals: ((self boundsInSpaceOf: target) insetBy: 6)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testHighlightFollowsMarginChange [

	target margin: (BlInsets all: 12).

	self assert: (self boundsInSpaceOf: highlight) equals: (self marginBoxOf: target).
	self assert: (self boundsInSpaceOf: highlight borderBox) equals: (self boundsInSpaceOf: target)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testHighlightFollowsMove [

	target position: 60 @ 70.

	self assert: (self boundsInSpaceOf: highlight) equals: (65 @ 75 corner: 125 @ 105)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testHighlightFollowsParentMove [

	container position: 50 @ 50.

	self assert: (self boundsInSpaceOf: highlight) equals: (self marginBoxOf: target)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testHighlightFollowsResize [

	target extent: 80 @ 30.

	self assert: (self boundsInSpaceOf: highlight) equals: (35 @ 45 corner: 125 @ 85)
]

{ #category : 'tests - removal' }
ToInspectorHighlightFollowTest >> testHighlightLeavesSpaceWhenAncestorIsRemoved [

	container removeFromParent.
	space settle.

	self assert: highlight parent isNil.
	self assert: highlight highlightedElement isNil
]

{ #category : 'tests - removal' }
ToInspectorHighlightFollowTest >> testHighlightLeavesSpaceWhenElementIsRemoved [

	target removeFromParent.
	space settle.

	self assert: highlight parent isNil.
	self assert: highlight highlightedElement isNil
]

{ #category : 'tests - geometry' }
ToInspectorHighlightFollowTest >> testMovedHighlightIgnoresPreviousElement [

	highlight highlight: other.
	target margin: (BlInsets all: 20).
	target position: 0 @ 0.

	self assert: (self boundsInSpaceOf: highlight) equals: (self marginBoxOf: other)
]

{ #category : 'tests - removal' }
ToInspectorHighlightFollowTest >> testMovedHighlightStaysWhenPreviousElementIsRemoved [

	highlight highlight: other.
	target removeFromParent.
	space settle.

	self assert: highlight highlightedElement identicalTo: other.
	self assert: highlight parent identicalTo: space root
]

{ #category : 'tests - removal' }
ToInspectorHighlightFollowTest >> testUnhighlightedElementCanBeRemoved [

	highlight unhighlight.
	target removeFromParent.
	space settle.

	self assert: highlight parent isNil
]
