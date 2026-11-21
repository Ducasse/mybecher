"
I check the label of `ToInspectorHighlightElement`: its text (class, id, size) and how it follows the highlighted element, its window placed above the highlight or below it near the top of the space, and that the window closes with the highlight.
"
Class {
	#name : 'ToInspectorHighlightLabelTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'target',
		'other',
		'highlight'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'helpers' }
ToInspectorHighlightLabelTest >> labelWindowsInSpace [

	^ space root children select: [ :each | each isKindOf: ToTooltipWindow ]
]

{ #category : 'running' }
ToInspectorHighlightLabelTest >> setUp [

	super setUp.
	target := BlElement new
		          id: #target;
		          position: 60 @ 80;
		          extent: 100 @ 30;
		          yourself.
	other := BlElement new
		         position: 200 @ 5;
		         extent: 40 @ 30;
		         yourself.
	space root addChildren: {
		target.
		other }.
	space show.
	highlight := ToInspectorHighlightElement new.
	highlight highlight: target.
	space settle
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testHighlightingAnotherElementKeepsOneLabel [

	highlight highlight: other.
	space settle.

	self assert: self labelWindowsInSpace size equals: 1
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelClosesWhenElementIsRemoved [

	target removeFromParent.
	space settle.

	self assert: highlight labelWindow isNil.
	self assert: self labelWindowsInSpace isEmpty
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelClosesWhenUnhighlighting [

	highlight unhighlight.
	space settle.

	self assert: highlight labelWindow isNil.
	self assert: self labelWindowsInSpace isEmpty
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelFollowsHighlight [

	target position: 20 @ 150.

	self assert: (self boundsInSpaceOf: highlight labelWindow) bottomLeft equals: (self boundsInSpaceOf: highlight) topLeft
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelIsAboveHighlight [

	| labelBounds highlightBounds |
	labelBounds := self boundsInSpaceOf: highlight labelWindow.
	highlightBounds := self boundsInSpaceOf: highlight.

	self assert: labelBounds bottom equals: highlightBounds top.
	self assert: labelBounds left equals: highlightBounds left
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelIsBelowHighlightWithoutRoomAbove [

	| labelBounds highlightBounds |
	highlight highlight: other.
	labelBounds := self boundsInSpaceOf: highlight labelWindow.
	highlightBounds := self boundsInSpaceOf: highlight.

	self assert: labelBounds top equals: highlightBounds bottom.
	self assert: labelBounds left equals: highlightBounds left
]

{ #category : 'tests - window' }
ToInspectorHighlightLabelTest >> testLabelIsShownWhenHighlighting [

	self assert: highlight labelWindow isOpened.
	self assert: self labelWindowsInSpace size equals: 1
]

{ #category : 'tests - text' }
ToInspectorHighlightLabelTest >> testLabelShowsLabelText [

	self assert: highlight label text asString equals: highlight labelText
]

{ #category : 'tests - text' }
ToInspectorHighlightLabelTest >> testLabelTextFollowsAnotherElement [

	highlight highlight: other.
	space settle.

	self assert: highlight label text asString equals: 'BlElement 40 × 30'
]

{ #category : 'tests - text' }
ToInspectorHighlightLabelTest >> testLabelTextFollowsResize [

	target extent: 120 @ 40.
	space settle.

	self assert: highlight label text asString equals: 'BlElement #target 120 × 40'
]

{ #category : 'tests - text' }
ToInspectorHighlightLabelTest >> testLabelTextShowsClassIdAndSize [

	self assert: highlight labelText equals: 'BlElement #target 100 × 30'
]

{ #category : 'tests - text' }
ToInspectorHighlightLabelTest >> testLabelTextWithoutIdShowsClassAndSize [

	highlight highlight: other.
	space settle.

	self assert: highlight labelText equals: 'BlElement 40 × 30'
]
