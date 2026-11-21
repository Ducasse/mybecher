"
I announce that the inspected element changed in a `ToInspectorSession`. See `ToInspectorElementChanged` for what I carry.

## Examples

```
ToInspectorSelectedElementChanged exampleFirstSelection
```
"
Class {
	#name : 'ToInspectorSelectedElementChanged',
	#superclass : 'ToInspectorElementChanged',
	#category : 'Toplo-Inspector-Model',
	#package : 'Toplo-Inspector',
	#tag : 'Model'
}

{ #category : 'examples' }
ToInspectorSelectedElementChanged class >> exampleFirstSelection [

	<sampleInstance>
	^ self new
		  element: (ToButton new labelText: 'Selected');
		  yourself
]
