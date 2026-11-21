"
I open and place the label window of a `ToInspectorHighlightElement`. I am a `ToAnchoredWindowManager` that opens `ToTooltipWindow`s, to get the look of a tooltip, and places them with a `ToInspectorLabelPlacement`.

## Examples

```
ToInspectorLabelWindowManager exampleWithLabel
```

## Design Rationale

- I do not use `ToTooltipManager`: as a popup manager it opens and closes its window on mouse events (mouse up, outside, still hovered) and after an auto-close delay. The label must stay as long as the element is highlighted, and the highlight receives no mouse events.
- As an anchored window manager, I only follow my anchor: when the highlight moves or changes size, the window is placed again, and it closes when the highlight is removed from its parent (`elementToBeRemovedFromParentEvent:`).

## Usage

1. `ToInspectorHighlightElement>>#initializeLabel` creates me, sets the window builder that moves its `ToLabel` into the new window, and installs me on the highlight with `addEventHandler:`.
2. `ToInspectorHighlightElement>>#showLabel` opens the window with `createNewWindowOnEvent: nil` and `popup`; `ToInspectorHighlightElement>>#closeLabel` closes it.
3. `currentWindow` answers the open window, or nil.
"
Class {
	#name : 'ToInspectorLabelWindowManager',
	#superclass : 'ToAnchoredWindowManager',
	#category : 'Toplo-Inspector-Highlight',
	#package : 'Toplo-Inspector',
	#tag : 'Highlight'
}

{ #category : 'examples' }
ToInspectorLabelWindowManager class >> exampleWithLabel [

	<sampleInstance>
	^ self new
		  windowBuilder: [ :aWindow :aRequest | aWindow root addChild: (ToLabel text: 'ToButton 120 × 32') ];
		  yourself
]

{ #category : 'initialization' }
ToInspectorLabelWindowManager >> defaultPlacement [

	^ ToInspectorLabelPlacement new
]

{ #category : 'window handling' }
ToInspectorLabelWindowManager >> windowClass [

	^ ToTooltipWindow
]
