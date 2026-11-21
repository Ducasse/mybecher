"
I check that `ToInspectorSession` keeps its hovered and selected elements apart, announces each real change with the previous element, announces nothing when the element does not change, and refuses elements that are not in its space.
"
Class {
	#name : 'ToInspectorSessionTest',
	#superclass : 'ToInspectorTestCase',
	#instVars : [
		'session',
		'first',
		'second',
		'announcements'
	],
	#category : 'Toplo-Inspector-Tests',
	#package : 'Toplo-Inspector-Tests'
}

{ #category : 'running' }
ToInspectorSessionTest >> setUp [

	super setUp.
	first := BlElement new.
	second := BlElement new.
	space root addChildren: {
		first.
		second }.
	session := ToInspectorSession on: space.
	announcements := OrderedCollection new.
	session announcer when: ToInspectorElementChanged do: [ :anAnnouncement | announcements add: anAnnouncement ] for: self
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveredElement [

	session hoveredElement: first.

	self assert: session hoveredElement identicalTo: first
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveringAnnouncesHoveredElement [

	session hoveredElement: first.

	self assert: announcements size equals: 1.
	self assert: announcements first class identicalTo: ToInspectorHoveredElementChanged.
	self assert: announcements first element identicalTo: first.
	self assert: announcements first previousElement isNil.
	self assert: announcements first session identicalTo: session
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveringAnotherElementAnnouncesPreviousElement [

	session hoveredElement: first.
	session hoveredElement: second.

	self assert: announcements last element identicalTo: second.
	self assert: announcements last previousElement identicalTo: first
]

{ #category : 'tests - errors' }
ToInspectorSessionTest >> testHoveringDetachedElementRaisesError [

	self should: [ session hoveredElement: BlElement new ] raise: Error
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveringDoesNotSelect [

	session hoveredElement: first.

	self assert: session selectedElement isNil
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveringNothingClearsHoveredElement [

	session hoveredElement: first.
	session hoveredElement: nil.

	self assert: session hoveredElement isNil.
	self assert: announcements last element isNil
]

{ #category : 'tests - hovering' }
ToInspectorSessionTest >> testHoveringSameElementAnnouncesNothing [

	session hoveredElement: first.
	session hoveredElement: first.

	self assert: announcements size equals: 1
]

{ #category : 'tests - accessing' }
ToInspectorSessionTest >> testNewSessionHasNoHoveredElement [

	self assert: session hoveredElement isNil
]

{ #category : 'tests - accessing' }
ToInspectorSessionTest >> testNewSessionHasNoSelectedElement [

	self assert: session selectedElement isNil
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectedElement [

	session selectedElement: first.

	self assert: session selectedElement identicalTo: first
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectingAnnouncesSelectedElement [

	session selectedElement: first.

	self assert: announcements size equals: 1.
	self assert: announcements first class identicalTo: ToInspectorSelectedElementChanged.
	self assert: announcements first element identicalTo: first.
	self assert: announcements first previousElement isNil
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectingAnotherElementAnnouncesPreviousElement [

	session selectedElement: first.
	session selectedElement: second.

	self assert: announcements last element identicalTo: second.
	self assert: announcements last previousElement identicalTo: first
]

{ #category : 'tests - errors' }
ToInspectorSessionTest >> testSelectingDetachedElementRaisesError [

	self should: [ session selectedElement: BlElement new ] raise: Error
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectingDoesNotHover [

	session selectedElement: first.

	self assert: session hoveredElement isNil
]

{ #category : 'tests - errors' }
ToInspectorSessionTest >> testSelectingElementOfAnotherSpaceRaisesError [

	| otherSpace stranger |
	otherSpace := BlSpace new.
	otherSpace host: BlHeadlessHost default.
	stranger := BlElement new.
	otherSpace root addChild: stranger.

	self should: [ session selectedElement: stranger ] raise: Error
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectingNothingClearsSelectedElement [

	session selectedElement: first.
	session selectedElement: nil.

	self assert: session selectedElement isNil.
	self assert: announcements last element isNil
]

{ #category : 'tests - selecting' }
ToInspectorSessionTest >> testSelectingSameElementAnnouncesNothing [

	session selectedElement: first.
	session selectedElement: first.

	self assert: announcements size equals: 1
]

{ #category : 'tests - accessing' }
ToInspectorSessionTest >> testSessionKnowsItsSpace [

	self assert: session space identicalTo: space
]
