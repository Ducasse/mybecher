"
I announce that the element under the pointer changed in a `ToInspectorSession`. See `ToInspectorElementChanged` for what I carry.

## Examples

```
ToInspectorHoveredElementChanged exampleFirstHover
```
"
Class {
	#name : 'ToInspectorHoveredElementChanged',
	#superclass : 'ToInspectorElementChanged',
	#category : 'Toplo-Inspector-Model',
	#package : 'Toplo-Inspector',
	#tag : 'Model'
}

{ #category : 'examples' }
ToInspectorHoveredElementChanged class >> exampleFirstHover [

	<sampleInstance>
	^ self new
		  element: (ToButton new labelText: 'Hovered');
		  yourself
]
