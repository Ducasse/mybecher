"
While reading Digital Signal Processing from Stevn W. Smith, just converted the BASIC pseudo code into Pharo. 
It helps understanding the points :)
"
Class {
	#name : 'DBBasicTest',
	#superclass : 'TestCase',
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'as yet unclassified' }
DBBasicTest >> arrayValues [

	^ #( 46	69	32	60	52	41 ) 
]

{ #category : 'as yet unclassified' }
DBBasicTest >> page15table21 [

^ 'N% is an integer   N is a float.
100 CALCULATION OF THE MEAN AND STANDARD DEVIATION
120 DIM X[511 ]
130 N% = 512 ''The signal is held in X[O] to X[511] N% is the number of points inthe signal

150 GOSUB XXXX Mythical subroutine that loads the signal into X[ ]

170 MEAN = 0
''Find the mean via Eq. 2-1
180 FOR I% = O TO N%-1
190     MEAN = MEAN + X[I%]
200 NEXT I%
210 MEAN = MEAN/N%
220 ''
230 VARIANCE = 0 ''Find the standard deviation via Eq. 2-2
240 FOR I% = 0 TO N%-1
250 VARIANCE = VARIANCE + ( X[I%] - MEAN )^2
260 NEXT I%
270 VARIANCE = VARIANCE/(N%- 1)
280 SD = SQR(VAR1ANCE)
290 ''
320 END'
]

{ #category : 'as yet unclassified' }
DBBasicTest >> testPage15table21 [

	| b |
	b := DBBasic new.
	self assert: (b meanOf:  self arrayValues) equals: self arrayValues average.
	
	self assert: ((b standardDeviationOf: self arrayValues) roundUpTo: 0.01) equals: 13.32
]

{ #category : 'as yet unclassified' }
DBBasicTest >> testPage16table22 [

	| b |
	b := DBBasicRunning new.
	b data: self arrayValues.
	self assert: b mean equals: self arrayValues average.
	
	self assert: (b standardDeviation roundUpTo: 0.01) equals: 13.32
]

{ #category : 'as yet unclassified' }
DBBasicTest >> testPage21table23 [

	| b |
	b := DBBasicHistogram new.
	b data: self arrayValues.
	self assert: b mean equals: self arrayValues average.
	
	self assert: (b standardDeviation roundUpTo: 0.01) equals: 13.32
]
