"
I'm a simple dynamically growing queue implementation with a minimal API.  
As a queue I support FIFO (first in firt out) principle. 
I keep my element in a sequence. Element access and deletion are restricted to my first element
that is called the front of the queue. Element insertion is conceptually restricted to the end of the sequence called the rear of the queue.

### Example

```
| q |
	q := self queueClass new.
	q enqueue: 5.
	q enqueue: 3.
	q dequeue.  
	q enqueue: 7.
	self assert: q size equals: 2.
	self assert: q front equals: 3.
	q dequeue.
	self assert: q front equals: 7.
```
"
Class {
	#name : 'DSQueue',
	#superclass : 'Object',
	#instVars : [
		'contents'
	],
	#category : 'myBecher-DS-Queue',
	#package : 'myBecher-DS',
	#tag : 'Queue'
}

{ #category : 'actions' }
DSQueue >> dequeue [
	contents isEmpty ifTrue: [ DSEmptyError signal ].
	contents removeFirst
]

{ #category : 'actions' }
DSQueue >> enqueue: anObject [ 
		
	contents addLast: anObject
]

{ #category : 'accessing' }
DSQueue >> front [
	self isEmpty ifTrue: [ ^ DSEmptyError signal ].
	^ contents first
]

{ #category : 'initialization' }
DSQueue >> initialize [
	super initialize.
	contents := OrderedCollection new
]

{ #category : 'testing' }
DSQueue >> isEmpty [
	^ contents isEmpty
]

{ #category : 'initialization' }
DSQueue >> size [ 

	^ contents size
]
