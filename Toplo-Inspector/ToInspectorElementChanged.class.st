"
I announce that an element of a `ToInspectorSession` changed, with the new element (`element`), the one it replaces (`previousElement`) and the session. My subclasses say which element changed: `ToInspectorHoveredElementChanged` and `ToInspectorSelectedElementChanged`. Subscribing to me receives both.

## Examples

```
ToInspectorElementChanged scriptTraceSessionAnnouncements
```

## Usage

`ToInspectorSession>>#hoveredElement:` and `ToInspectorSession>>#selectedElement:` create and announce my instances, only when the element really changes. Subscribers read `element`, `previousElement` and `session`. Either element may be nil: nil as `previousElement` for the first change, nil as `element` when the session clears it.

Instances are not changed after they are announced.
"
Class {
	#name : 'ToInspectorElementChanged',
	#superclass : 'Announcement',
	#instVars : [
		'session',
		'element',
		'previousElement'
	],
	#category : 'Toplo-Inspector-Model',
	#package : 'Toplo-Inspector',
	#tag : 'Model'
}

{ #category : 'script' }
ToInspectorElementChanged class >> scriptTraceSessionAnnouncements [
	"Hover and select two elements of a space through an inspector session and print each announcement to the Transcript, with its new and previous element."

	<example>
	| space first second session |
	space := BlSpace new.
	first := ToButton new labelText: 'First'.
	second := ToButton new labelText: 'Second'.
	space root addChildren: {
		first.
		second }.
	session := ToInspectorSession on: space.
	session announcer when: self do: [ :anAnnouncement | anAnnouncement traceCr ] for: self.
	session hoveredElement: first.
	session hoveredElement: second.
	session selectedElement: second.
	session hoveredElement: nil.
	^ session
]

{ #category : 'accessing' }
ToInspectorElementChanged >> element [

	^ element
]

{ #category : 'accessing' }
ToInspectorElementChanged >> element: anElement [

	element := anElement
]

{ #category : 'accessing' }
ToInspectorElementChanged >> previousElement [

	^ previousElement
]

{ #category : 'accessing' }
ToInspectorElementChanged >> previousElement: anElement [

	previousElement := anElement
]

{ #category : 'printing' }
ToInspectorElementChanged >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: ': ';
		print: previousElement;
		nextPutAll: ' -> ';
		print: element
]

{ #category : 'accessing' }
ToInspectorElementChanged >> session [

	^ session
]

{ #category : 'accessing' }
ToInspectorElementChanged >> session: aSession [

	session := aSession
]
