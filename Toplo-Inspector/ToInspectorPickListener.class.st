"
I let you pick an element in a running Bloc space by pointing at it, the way the element picker of a web browser's developer tools does. I am the first piece of the Toplo element inspector: installed as an event filter on the root of a `BlSpace`, I follow the deepest element under the pointer (`hoveredElement`), pick the element on which the mouse button is released (`pickedElement`), and report each change as one line (`describe:`). By default a report is printed to the Transcript; `reportBlock:` sends it elsewhere.

## Examples

```
ToInspectorPickListener scriptPrintHoveredAndPickedElements
```

## Design Rationale

- I am an event filter on the space root, not a handler: filters run before the handlers of the elements under the pointer, so I see every mouse event first and can consume it before the inspected application reacts.
- I pick on mouse up rather than on click. Consuming the mouse up keeps Bloc from generating the `BlClickEvent` at all, so the application never sees a click; a click handler of mine would never run.
- I take the event `target`, which Bloc computes with `BlElement>>#findMouseEventTargetAt:`, instead of hit testing again: what I pick is exactly what would have received the event. That is the deepest element, e.g. the `ToLabel` inside a `ToButton`, as in a browser.
- Reporting goes through a block so that I stay independent of how the inspector shows things; the printing default makes me usable on my own.

## Usage

1. `reportBlock:` optionally sets a one-argument block that receives the reports.
2. I am installed with `aSpace root addEventFilter: aListener`.
3. As the mouse moves, `mouseMoveEvent:` sends `hover:`; when the button is released, `mouseUpEvent:` sends `pick:`. `hoveredElement` and `pickedElement` answer the last ones.
4. `aSpace root removeEventFilter: aListener` ends the inspection and gives the mouse back to the application.

Instances are mutable and keep state between events: the last hovered and picked elements. An instance serves one space at a time; it is used from the space's UI process and is not meant to be shared between processes.

## Implementation Notes

- `hover:` reports only when the hovered element changes, so moving inside one element prints a single line.
- Mouse down is consumed too, so the mouse down handlers of the inspected elements do not run either.

## Invariants and Assumptions

- `hoveredElement` and `pickedElement` are nil until the first mouse move and mouse up; afterwards they are elements of the space I am installed on.
- I assume I am installed on the space root, so that I receive the events of every element of the space.

## Internal Representation

- `hoveredElement` the deepest element under the pointer at the last mouse move
- `pickedElement` the deepest element under the pointer at the last mouse up
- `reportBlock` a one-argument block receiving each report line
"
Class {
	#name : 'ToInspectorPickListener',
	#superclass : 'BlEventListener',
	#instVars : [
		'hoveredElement',
		'pickedElement',
		'reportBlock'
	],
	#category : 'Toplo-Inspector-Picking',
	#package : 'Toplo-Inspector',
	#tag : 'Picking'
}

{ #category : 'examples' }
ToInspectorPickListener class >> exampleDefault [

	<sampleInstance>
	^ self new
]

{ #category : 'script' }
ToInspectorPickListener class >> scriptPrintHoveredAndPickedElements [
	"Open a space with a few Toplo widgets. Moving the mouse prints the element under the pointer to the Transcript, and clicking prints the picked element; the widgets do not react while the listener is installed."

	<example>
	| pane space |
	pane := ToPane vertical.
	pane matchParent.
	pane addChild: (ToButton new
		 labelText: 'A button';
		 id: #button;
		 yourself).
	pane addChild: ((ToLabel text: 'A label')
		 id: #label;
		 yourself).
	pane addChild: (ToCheckbox new
		 labelText: 'A checkbox';
		 id: #checkbox;
		 yourself).
	space := BlSpace new.
	space title: 'Pick an element'.
	space root addChild: pane.
	space root addEventFilter: self new.
	space show.
	^ space
]

{ #category : 'picking' }
ToInspectorPickListener >> describe: anElement [
	"Answer a one-line description of anElement: its class, identity, id and extent."

	^ String streamContents: [ :aStream |
		  aStream
			  print: anElement;
			  space;
			  print: anElement width rounded;
			  nextPutAll: ' × ';
			  print: anElement height rounded ]
]

{ #category : 'picking' }
ToInspectorPickListener >> hover: anElement [
	"Make anElement the element under the pointer and report it when it changes."

	anElement == hoveredElement ifTrue: [ ^ self ].
	hoveredElement := anElement.
	self report: 'Hovered: ' , (self describe: anElement)
]

{ #category : 'accessing' }
ToInspectorPickListener >> hoveredElement [

	^ hoveredElement
]

{ #category : 'initialization' }
ToInspectorPickListener >> initialize [

	super initialize.
	reportBlock := [ :aString | aString traceCr ]
]

{ #category : 'mouse handlers' }
ToInspectorPickListener >> mouseDownEvent: anEvent [
	"Keep the application from reacting while it is being inspected."

	anEvent consume
]

{ #category : 'mouse handlers' }
ToInspectorPickListener >> mouseMoveEvent: anEvent [

	self hover: anEvent target
]

{ #category : 'mouse handlers' }
ToInspectorPickListener >> mouseUpEvent: anEvent [
	"Pick the element under the pointer. Consuming the event also keeps Bloc from generating the click, so the application does not react."

	anEvent consume.
	self pick: anEvent target
]

{ #category : 'picking' }
ToInspectorPickListener >> pick: anElement [
	"Make anElement the picked element and report it."

	pickedElement := anElement.
	self report: 'Picked: ' , (self describe: anElement)
]

{ #category : 'accessing' }
ToInspectorPickListener >> pickedElement [

	^ pickedElement
]

{ #category : 'picking' }
ToInspectorPickListener >> report: aString [

	reportBlock value: aString
]

{ #category : 'accessing' }
ToInspectorPickListener >> reportBlock: aBlock [

	reportBlock := aBlock
]
