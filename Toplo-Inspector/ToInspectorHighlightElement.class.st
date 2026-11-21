"
I show which element an inspector points at, like the box a web browser's developer tools draw over a DOM node. I cover the highlighted element and its margin with four nested boxes in the colors of the browsers: margin in orange (myself), border in yellow (`borderBox`), padding in green (`paddingBox`) and content in blue (`contentBox`). A label shows the class of the element, its id and its size (`labelText`). I sit on top of everything in the root of its space and follow the element when it moves or changes size.

## Examples

```
ToInspectorHighlightElement exampleOnButton
```

## Design Rationale

- I am a `ToOverlayElement`: its overlay listener already relocates and resizes me from the element's bounds in space. I only redefine `positionFrom:` and `extentFrom:` to grow by the margin, so I cover the space the element takes in its parent's layout.
- I live in the space root rather than in the element's parent: I am never clipped by an ancestor and never change the layout of the inspected elements (overlays are ignored by layout).
- I have the highest global elevation, so I am drawn over every element of the space.
- I let mouse events through (overlays prevent mouse events), so the element under me can still be hovered and picked.
- Each box is the next one's parent, with a frame layout whose padding is the next layer of the element (`updateBoxes`): the layout computes the four rectangles, I do no geometry of my own.
- The boxes are opaque and I am drawn at half opacity as a whole, so each region shows its own color over the inspected element, without the colors of the boxes adding up.
- The overlay listener follows moves and size changes. Margin and padding changes send no event of their own and only show after a layout, so I also refresh (`refresh`) on the element's `BlElementLayoutComputedEvent`, and on its `BlElementBorderChangedEvent`.
- When the element leaves its space (`BlElementRemovedFromSceneGraphEvent`, also sent when an ancestor is removed), I unhighlight: a highlight must never stay over nothing.
- The handlers I add to the element are removed as soon as I highlight another element or unhighlight, so a previous element no longer moves or removes me.
- My label lives in a tooltip window opened by a `ToInspectorLabelWindowManager` installed on me, so it is placed above me (or below) and follows me without code of my own. It holds a single `ToLabel` whose text changes only when it differs: setting a text requests a layout, and each layout of the element refreshes me.
- One instance moves from element to element (`highlight:` again) instead of creating a new highlight for each hover.

## Usage

1. `highlight: anElement` attaches me to an element of a space and adds me to its root; sending it again with another element moves me.
2. `highlightedElement` answers the element I follow, or nil; `labelText` the text of my label, and `labelWindow` its window while it is open.
3. `unhighlight` stops following it and removes me from the space. Removing the element from its space does it too.

Instances are mutable and follow one element at a time.

## Invariants and Assumptions

- `highlight:` refuses an element that is not in a space.
- My geometry ignores the transformations of the element: margins are added as they are, unscaled.
"
Class {
	#name : 'ToInspectorHighlightElement',
	#superclass : 'ToOverlayElement',
	#instVars : [
		'borderBox',
		'paddingBox',
		'contentBox',
		'elementHandlers',
		'label',
		'labelManager'
	],
	#category : 'Toplo-Inspector-Highlight',
	#package : 'Toplo-Inspector',
	#tag : 'Highlight'
}

{ #category : 'colors' }
ToInspectorHighlightElement class >> borderColor [

	^ Color
		  r: 255
		  g: 229
		  b: 153
		  range: 255
]

{ #category : 'colors' }
ToInspectorHighlightElement class >> contentColor [

	^ Color
		  r: 111
		  g: 168
		  b: 220
		  range: 255
]

{ #category : 'examples' }
ToInspectorHighlightElement class >> exampleOnButton [

	| space button highlight |
	button := ToButton new
		          labelText: 'Highlighted button';
		          margin: (BlInsets all: 10);
		          position: 40 @ 40;
		          yourself.
	space := BlSpace new.
	space title: 'Highlight on a button'.
	space root addChild: button.
	highlight := self new.
	highlight highlight: button.
	space show.
	^ highlight
]

{ #category : 'colors' }
ToInspectorHighlightElement class >> marginColor [
	"The colors of the four boxes are the ones of the web browsers' developer tools."

	^ Color
		  r: 246
		  g: 178
		  b: 107
		  range: 255
]

{ #category : 'colors' }
ToInspectorHighlightElement class >> paddingColor [

	^ Color
		  r: 147
		  g: 196
		  b: 125
		  range: 255
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> borderBox [

	^ borderBox
]

{ #category : 'private - label' }
ToInspectorHighlightElement >> closeLabel [

	labelManager currentWindowDo: [ :aWindow | aWindow close ]
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> contentBox [

	^ contentBox
]

{ #category : 't - overlay element - geometry' }
ToInspectorHighlightElement >> extentFrom: anExtent [
	"Grow by the margin of the highlighted element."

	| margin |
	margin := self highlightedElement margin.
	^ anExtent + (margin width @ margin height)
]

{ #category : 'private - following' }
ToInspectorHighlightElement >> followHighlightedElement [
	"Watch what the overlay listener does not: margin and padding changes (they only show after a layout), border changes, and the removal of the element from its space."

	| element |
	element := self highlightedElement.
	elementHandlers := {
		                   (element addEventHandlerOn: BlElementLayoutComputedEvent do: [ :anEvent | self refresh ]).
		                   (element addEventHandlerOn: BlElementBorderChangedEvent do: [ :anEvent | self refresh ]).
		                   (element addEventHandlerOn: BlElementRemovedFromSceneGraphEvent do: [ :anEvent | self unhighlight ]) }
]

{ #category : 'api - highlighting' }
ToInspectorHighlightElement >> highlight: anElement [
	"Show me over anElement and its margin, on top of the root of its space, with my label, and follow it."

	anElement isAttachedToSceneGraph ifFalse: [ self error: anElement printString , ' is not in a space' ].
	self stopFollowingHighlightedElement.
	self attachTo: anElement.
	self followHighlightedElement.
	self updateBoxes.
	self parent == anElement space root ifFalse: [
		self removeFromParent.
		anElement space root addChild: self ].
	self showLabel
]

{ #category : 'api - highlighting' }
ToInspectorHighlightElement >> highlightedElement [

	^ self referenceElement
]

{ #category : 'initialization' }
ToInspectorHighlightElement >> initialize [

	super initialize.
	self elevation: (BlGlobalElevation elevation: SmallInteger maxVal).
	self layout: BlFrameLayout new.
	self opacity: 0.5.
	self background: self class marginColor.
	contentBox := self newBoxColored: self class contentColor.
	paddingBox := self newBoxColored: self class paddingColor.
	paddingBox addChild: contentBox.
	borderBox := self newBoxColored: self class borderColor.
	borderBox addChild: paddingBox.
	self addChild: borderBox.
	self initializeLabel
]

{ #category : 'initialization' }
ToInspectorHighlightElement >> initializeLabel [
	"The label is one ToLabel, moved into each new window of the label manager."

	label := ToLabel new.
	labelManager := ToInspectorLabelWindowManager new.
	labelManager windowBuilder: [ :aWindow :aRequest |
		label removeFromParent.
		aWindow root addChild: label ].
	self addEventHandler: labelManager
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> label [

	^ label
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> labelText [
	"Answer the text of my label: the class of the highlighted element, its id if any, and its size, as in a browser."

	| element |
	element := self highlightedElement.
	^ String streamContents: [ :aStream |
		  aStream nextPutAll: element class name.
		  element id ifNotNil: [ :anId |
			  aStream
				  nextPutAll: ' #';
				  nextPutAll: anId asString ].
		  aStream
			  space;
			  print: element width rounded;
			  nextPutAll: ' × ';
			  print: element height rounded ]
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> labelWindow [

	^ labelManager currentWindow
]

{ #category : 'initialization' }
ToInspectorHighlightElement >> newBoxColored: aColor [
	"Answer a box filling its parent inside the parent's padding."

	^ BlElement new
		  layout: BlFrameLayout new;
		  background: aColor;
		  preventMouseEvents;
		  constraintsDo: [ :c |
			  c horizontal matchParent.
			  c vertical matchParent ];
		  yourself
]

{ #category : 'accessing' }
ToInspectorHighlightElement >> paddingBox [

	^ paddingBox
]

{ #category : 't - overlay element - geometry' }
ToInspectorHighlightElement >> positionFrom: aPosition [
	"Move my origin to the outer edge of the margin of the highlighted element."

	^ aPosition - self highlightedElement margin topLeft
]

{ #category : 'private - following' }
ToInspectorHighlightElement >> refresh [
	"Recompute my boxes, position, extent and label from the highlighted element."

	self updateBoxes.
	self updateLabel.
	overlayListener relocateTo: self highlightedElement.
	overlayListener resizeTo: self highlightedElement
]

{ #category : 'private - label' }
ToInspectorHighlightElement >> showLabel [
	"Open my label window next to me, unless it is already open."

	self updateLabel.
	labelManager currentWindow ifNotNil: [ ^ self ].
	(labelManager createNewWindowOnEvent: nil) popup
]

{ #category : 'private - following' }
ToInspectorHighlightElement >> stopFollowingHighlightedElement [

	elementHandlers ifNil: [ ^ self ].
	elementHandlers do: [ :each | self highlightedElement removeEventHandler: each ].
	elementHandlers := nil
]

{ #category : 'api - highlighting' }
ToInspectorHighlightElement >> unhighlight [
	"Stop following the highlighted element and leave its space with my label."

	self closeLabel.
	self stopFollowingHighlightedElement.
	self detach.
	self removeFromParent
]

{ #category : 'api - highlighting' }
ToInspectorHighlightElement >> updateBoxes [
	"Inset each box by the next layer of the highlighted element: margin, border, then padding."

	| element |
	element := self highlightedElement.
	self padding: element margin.
	borderBox padding: (BlInsets all: element border width).
	paddingBox padding: element padding
]

{ #category : 'private - label' }
ToInspectorHighlightElement >> updateLabel [
	"Change the text only when it differs: setting a text requests a layout, which would refresh me again."

	| text |
	text := self labelText.
	label text asString = text ifTrue: [ ^ self ].
	label text: text
]
