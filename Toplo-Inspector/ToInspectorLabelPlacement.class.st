"
I place the label of a `ToInspectorHighlightElement` the way browsers do: just above the top left corner of the highlight, or just below its bottom left corner when there is no room above in the space.

## Examples

```
ToInspectorLabelPlacement exampleDefault
```

## Design Rationale

- Toplo's anchored placements put a window to the left of the anchor (`ToAnchoredTopLeftPlacement`), centered above it (`ToAnchoredTopCenterPlacement`) or inside it (`ToAnchoredTopLeftDownPlacement`); none aligns it on the left edge above, so I am a `ToElementCustomPlacement`.
- I ignore the event: the label is not opened by a mouse event, and `ToTooltipPlacement`, which needs one, fails with a nil event.

## Usage

`ToInspectorLabelWindowManager>>#defaultPlacement` creates me. The manager's window sends me `positionElement:onEvent:context:` each time it is laid out. I keep no state.
"
Class {
	#name : 'ToInspectorLabelPlacement',
	#superclass : 'ToElementCustomPlacement',
	#category : 'Toplo-Inspector-Highlight',
	#package : 'Toplo-Inspector',
	#tag : 'Highlight'
}

{ #category : 'examples' }
ToInspectorLabelPlacement class >> exampleDefault [

	<sampleInstance>
	^ self new
]

{ #category : 'api - displaying' }
ToInspectorLabelPlacement >> positionElement: anElement onEvent: anEvent context: aBlElementBoundsUpdateContext [
	"Put anElement just above the top left corner of its anchor, or just below its bottom left corner when there is no room above."

	| anchorBounds above |
	anchorBounds := (anElement anchorElement bounds inParent: anElement anchorRoot) bounds.
	above := anchorBounds left @ (anchorBounds top - anElement measuredHeight).
	anElement position: (above y >= 0
		 ifTrue: [ above ]
		 ifFalse: [ anchorBounds bottomLeft ])
]
