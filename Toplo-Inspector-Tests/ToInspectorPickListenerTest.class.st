"
I check that `ToInspectorPickListener` follows and picks the deepest element under the pointer, keeps the mouse buttons from reaching the inspected elements, and reports what it hovers and picks.

## Implementation Notes

- My fixture is an outer element with an inner child whose click handler stands for the inspected application. `testClickReachesApplicationOnceListenerRemoved` shows that this handler does run without the listener, so `testClickDoesNotReachApplication` cannot pass by accident.
"
Class {
	#name : 'ToInspectorPickListenerTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'listener',
		'reports',
		'outer',
		'inner',
		'innerClicked'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'running' }
ToInspectorPickListenerTest >> setUp [

	super setUp.
	outer := BlElement new
		         position: 10 @ 10;
		         extent: 100 @ 100;
		         yourself.
	inner := BlElement new
		         position: 10 @ 10;
		         extent: 20 @ 20;
		         yourself.
	innerClicked := false.
	inner addEventHandlerOn: BlClickEvent do: [ :anEvent | innerClicked := true ].
	outer addChild: inner.
	space root addChild: outer.
	reports := OrderedCollection new.
	listener := ToInspectorPickListener new.
	listener reportBlock: [ :aString | reports add: aString ].
	space root addEventFilter: listener.
	space show
]

{ #category : 'tests - picking' }
ToInspectorPickListenerTest >> testClickDoesNotReachApplication [

	inner eventSimulator click.

	self deny: innerClicked
]

{ #category : 'tests - picking' }
ToInspectorPickListenerTest >> testClickPicksElement [

	inner eventSimulator click.

	self assert: listener pickedElement identicalTo: inner
]

{ #category : 'tests - picking' }
ToInspectorPickListenerTest >> testClickReachesApplicationOnceListenerRemoved [

	space root removeEventFilter: listener.

	inner eventSimulator click.

	self assert: innerClicked
]

{ #category : 'tests - picking' }
ToInspectorPickListenerTest >> testClickReportsPickedElement [

	inner eventSimulator click.

	self assert: reports last equals: 'Picked: ' , (listener describe: inner)
]

{ #category : 'tests - describing' }
ToInspectorPickListenerTest >> testDescriptionShowsElementAndExtent [

	inner id: #inner.
	space settle.

	self assert: (listener describe: inner) equals: inner printString , ' 20 × 20'
]

{ #category : 'tests - hovering' }
ToInspectorPickListenerTest >> testHoverOutsideChildSetsParent [

	inner eventSimulator mouseMoveAt: 80 @ 80.

	self assert: listener hoveredElement identicalTo: outer
]

{ #category : 'tests - hovering' }
ToInspectorPickListenerTest >> testHoverReportsHoveredElement [

	inner eventSimulator mouseMoveInside.

	self assert: reports asArray equals: { ('Hovered: ' , (listener describe: inner)) }
]

{ #category : 'tests - hovering' }
ToInspectorPickListenerTest >> testHoverSetsHoveredElement [

	inner eventSimulator mouseMoveInside.

	self assert: listener hoveredElement identicalTo: inner
]

{ #category : 'tests - hovering' }
ToInspectorPickListenerTest >> testHoverTwiceOnSameElementReportsOnce [

	inner eventSimulator mouseMoveInside.
	inner eventSimulator mouseMoveAt: 25 @ 25.

	self assert: reports size equals: 1
]
