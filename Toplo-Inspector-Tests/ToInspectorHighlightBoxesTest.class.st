"
I check that `ToInspectorHighlightElement` nests its border, padding and content boxes inside the margin box at the right places, and draws each region in its own color. The pixel tests compare the rendered space with each box color drawn at half opacity over white.
"
Class {
	#name : 'ToInspectorHighlightBoxesTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'highlight'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'helpers' }
ToInspectorHighlightBoxesTest >> boxNameAt: aPoint [
	"Answer the name of the highlight box whose color, drawn at half opacity over the white root, is the closest to the pixel at aPoint."

	| pixel candidates |
	pixel := space root asForm colorAt: aPoint.
	candidates := {
		              (#margin -> ToInspectorHighlightElement marginColor).
		              (#border -> ToInspectorHighlightElement borderColor).
		              (#padding -> ToInspectorHighlightElement paddingColor).
		              (#content -> ToInspectorHighlightElement contentColor).
		              (#none -> Color white) }.
	^ (candidates detectMin: [ :each |
		   self distanceFrom: pixel to: (each key = #none
			    ifTrue: [ each value ]
			    ifFalse: [ each value mixed: 0.5 with: Color white ]) ]) key
]

{ #category : 'helpers' }
ToInspectorHighlightBoxesTest >> distanceFrom: aColor to: anotherColor [

	^ (aColor red - anotherColor red) abs + (aColor green - anotherColor green) abs + (aColor blue - anotherColor blue) abs
]

{ #category : 'running' }
ToInspectorHighlightBoxesTest >> setUp [
	"The target and its border are white like the root, so that each box is drawn at half opacity over white."

	| target |
	super setUp.
	space root background: Color white.
	target := BlElement new
		          position: 40 @ 40;
		          extent: 100 @ 60;
		          margin: (BlInsets all: 10);
		          border: (BlBorder paint: Color white width: 4);
		          padding: (BlInsets all: 8);
		          yourself.
	space root addChild: target.
	space show.
	highlight := ToInspectorHighlightElement new.
	highlight highlight: target.
	space settle
]

{ #category : 'tests - geometry' }
ToInspectorHighlightBoxesTest >> testBorderBoxCoversElement [

	self assert: (self boundsInSpaceOf: highlight borderBox) equals: (40 @ 40 corner: 140 @ 100)
]

{ #category : 'tests - drawing' }
ToInspectorHighlightBoxesTest >> testBorderIsDrawnInBorderColor [

	self assert: (self boxNameAt: 42 @ 70) equals: #border
]

{ #category : 'tests - geometry' }
ToInspectorHighlightBoxesTest >> testBoxesFollowAnotherElement [

	| plain |
	plain := BlElement new
		         position: 200 @ 20;
		         extent: 30 @ 30;
		         yourself.
	space root addChild: plain.
	highlight highlight: plain.
	space settle.

	self assert: (self boundsInSpaceOf: highlight contentBox) equals: (200 @ 20 corner: 230 @ 50)
]

{ #category : 'tests - geometry' }
ToInspectorHighlightBoxesTest >> testContentBoxIsInsidePadding [

	self assert: (self boundsInSpaceOf: highlight contentBox) equals: (52 @ 52 corner: 128 @ 88)
]

{ #category : 'tests - drawing' }
ToInspectorHighlightBoxesTest >> testContentIsDrawnInContentColor [

	self assert: (self boxNameAt: 90 @ 70) equals: #content
]

{ #category : 'tests - geometry' }
ToInspectorHighlightBoxesTest >> testHighlightCoversMarginBox [

	self assert: (self boundsInSpaceOf: highlight) equals: (30 @ 30 corner: 150 @ 110)
]

{ #category : 'tests - drawing' }
ToInspectorHighlightBoxesTest >> testMarginIsDrawnInMarginColor [

	self assert: (self boxNameAt: 34 @ 70) equals: #margin
]

{ #category : 'tests - drawing' }
ToInspectorHighlightBoxesTest >> testOutsideMarginIsNotDrawn [

	self assert: (self boxNameAt: 20 @ 20) equals: #none
]

{ #category : 'tests - geometry' }
ToInspectorHighlightBoxesTest >> testPaddingBoxIsInsideBorder [

	self assert: (self boundsInSpaceOf: highlight paddingBox) equals: (44 @ 44 corner: 136 @ 96)
]

{ #category : 'tests - drawing' }
ToInspectorHighlightBoxesTest >> testPaddingIsDrawnInPaddingColor [

	self assert: (self boxNameAt: 48 @ 70) equals: #padding
]
