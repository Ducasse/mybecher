"
I am the event listener that lets you pick an element in a Bloc space, the first step of the Toplo element inspector. While I am installed as an event filter on the space root, I follow the element under the mouse and pick the element you release the mouse button on, and I report both. For now a report is a line printed to the Transcript.

## Life cycle: who creates me and who uses me

1. `ToInspectorPickListener class>>#scriptPrintHoveredAndPickedElements` and `ToInspectorPickListenerTest>>#setUp` create me with `new`; `reportBlock:` replaces the default report (printing to the Transcript).
2. They install me on the root of a space with `space root addEventFilter: aListener`. As a filter, I receive the mouse events before the handlers of the elements under the pointer.
3. On each mouse move I note the element under the pointer (`hover:`), on mouse up I note the picked element (`pick:`), and I report each change.
4. I consume mouse down and mouse up events, so the application does not react to them; consuming mouse up also keeps Bloc from generating the click. `space root removeEventFilter: aListener` gives the space back to the application.

## Responsibility:

- I know the element under the pointer (`hoveredElement`) and the last picked element (`pickedElement`).
- I keep the inspected application from reacting to the mouse buttons while picking.
- I report what I hover and pick, as one line per change.

## Collaborators: 

- `BlSpace` and its root element: they dispatch the mouse events to me before the inspected elements.
- `BlMouseMoveEvent`, `BlMouseDownEvent`, `BlMouseUpEvent`: their `target` is the deepest element under the pointer.

## Public API and Key Messages

- `hoveredElement`, `pickedElement`
- `reportBlock:` a one-argument block receiving each report line
- `describe: anElement` the one-line description used in the reports (class, identity, id, width × height)

## Examples

```
ToInspectorPickListener scriptPrintHoveredAndPickedElements
```

## Internal Representation

- `hoveredElement` the deepest element under the pointer at the last mouse move
- `pickedElement` the deepest element under the pointer at the last mouse up
- `reportBlock` a one-argument block, by default printing to the Transcript
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
