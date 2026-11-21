"
I am the shared model of an element inspector: for one `BlSpace`, I know the element under the pointer (`hoveredElement`) and the inspected element (`selectedElement`), and I announce every change through my `announcer`. The picker in the space and the inspector window only talk to me, so either side can change without the other, and the inspector logic can be checked without any user interface.

## Examples

```
ToInspectorSession exampleWithSelectedButton
```

## Design Rationale

- Hovering and selecting are separate, as in a browser: moving the pointer highlights without losing the inspected element.
- Changes are announced (`ToInspectorHoveredElementChanged`, `ToInspectorSelectedElementChanged`) instead of calling the views, so any number of views (highlight, tree, properties) can follow one session.
- Setting the element I already have announces nothing, so views can echo a change back to me without loops.
- I refuse an element that is not in my space: an inspector must never show or highlight an element of another space.

## Usage

1. `ToInspectorSession on: aSpace` creates a session for the space to inspect.
2. Views subscribe with `aSession announcer when: ToInspectorElementChanged do: aBlock for: aSubscriber` (or one of the two subclasses).
3. The picker sends `hoveredElement:` and `selectedElement:`; nil clears them.

Instances are mutable and keep the current hovered and selected elements. A session belongs to one space and is used from that space's UI process.

## Invariants and Assumptions

- `hoveredElement` and `selectedElement` are nil or elements whose `space` is my space at the time they were set. An element removed from the space afterwards stays until someone replaces it.

## Internal Representation

- `space` the inspected `BlSpace`
- `hoveredElement`, `selectedElement` elements of `space`, or nil
- `announcer` an `Announcer` delivering `ToInspectorElementChanged` announcements
"
Class {
	#name : 'ToInspectorSession',
	#superclass : 'Object',
	#instVars : [
		'space',
		'hoveredElement',
		'selectedElement',
		'announcer'
	],
	#category : 'Toplo-Inspector-Model',
	#package : 'Toplo-Inspector',
	#tag : 'Model'
}

{ #category : 'examples' }
ToInspectorSession class >> exampleWithSelectedButton [

	<sampleInstance>
	| space button |
	space := BlSpace new.
	button := ToButton new labelText: 'Inspect me'.
	space root addChild: button.
	^ (self on: space)
		  selectedElement: button;
		  yourself
]

{ #category : 'instance creation' }
ToInspectorSession class >> on: aSpace [

	^ self new
		  space: aSpace;
		  yourself
]

{ #category : 'private' }
ToInspectorSession >> announce: anAnnouncementClass element: anElementOrNil previous: aPreviousElementOrNil [

	announcer announce: (anAnnouncementClass new
		 session: self;
		 element: anElementOrNil;
		 previousElement: aPreviousElementOrNil;
		 yourself)
]

{ #category : 'accessing' }
ToInspectorSession >> announcer [

	^ announcer
]

{ #category : 'private' }
ToInspectorSession >> ensureInspectable: anElementOrNil [
	"Refuse an element that does not belong to my space."

	anElementOrNil ifNil: [ ^ self ].
	anElementOrNil space == space ifFalse: [ self error: anElementOrNil printString , ' is not in the inspected space' ]
]

{ #category : 'accessing' }
ToInspectorSession >> hoveredElement [

	^ hoveredElement
]

{ #category : 'accessing' }
ToInspectorSession >> hoveredElement: anElementOrNil [
	"Make anElementOrNil the element under the pointer and announce it when it changes."

	| previous |
	anElementOrNil == hoveredElement ifTrue: [ ^ self ].
	self ensureInspectable: anElementOrNil.
	previous := hoveredElement.
	hoveredElement := anElementOrNil.
	self announce: ToInspectorHoveredElementChanged element: anElementOrNil previous: previous
]

{ #category : 'initialization' }
ToInspectorSession >> initialize [

	super initialize.
	announcer := Announcer new
]

{ #category : 'accessing' }
ToInspectorSession >> selectedElement [

	^ selectedElement
]

{ #category : 'accessing' }
ToInspectorSession >> selectedElement: anElementOrNil [
	"Make anElementOrNil the inspected element and announce it when it changes."

	| previous |
	anElementOrNil == selectedElement ifTrue: [ ^ self ].
	self ensureInspectable: anElementOrNil.
	previous := selectedElement.
	selectedElement := anElementOrNil.
	self announce: ToInspectorSelectedElementChanged element: anElementOrNil previous: previous
]

{ #category : 'accessing' }
ToInspectorSession >> space [

	^ space
]

{ #category : 'accessing' }
ToInspectorSession >> space: aSpace [

	space := aSpace
]
