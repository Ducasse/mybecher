"
In the pluging the permuteDate is not a dictionary but an array where the first number should be changed into the second. 

Here are some methods from Squeak. 

```
permuteData
	| i end a b tmp |
	<var: 'tmp' type:  #float>
	i := 0.
	end := permTableSize.
	[i < end] whileTrue:
		[a := (permTable at: i) - 1.
		b := (permTable at: i+1) - 1.

		(a < realDataSize and:[b < realDataSize]) ifFalse:[^interpreterProxy success: false].

		tmp := realData at: a.
		realData at: a put: (realData at: b).
		realData at: b put: tmp.

		tmp := imagData at: a.
		imagData at: a put: (imagData at: b).
		imagData at: b put: tmp.

		i := i + 2]
	

primitiveFFTPermuteData
	<export: true>
	<primitiveMetadata: #(FastCPrimitiveFlag FastCPrimitiveAlignForFloatsFlag)>
	(self loadFFTFrom: (interpreterProxy stackValue: 0)) ifFalse:[^nil].
	self permuteData.
	interpreterProxy failed ifTrue:
		""permuteData went wrong. Do the permutation again -- this will restore the original order""
		[self permuteData]!	
	
```




The code above used permTable (the permutationTable aka. bit reserved)

```
nu: order
	""Initialize variables and tables for transforming 2^nu points""
	|  j perms k |
	nu := order.
	n := 2 bitShift: nu-1.

	""Initialize permutation table (bit-reversed indices)""
	j:=0.
	perms := WriteStream on: (Array new: n).
	0 to: n-2 do:
		[:i |
		i < j ifTrue: [perms nextPut: i+1; nextPut: j+1].
		k := n // 2.
		[k <= j] whileTrue: [j := j-k.  k := k//2].
		j := j + k].
	permTable := perms contents.
```
One problem I have with the above code is that it creates the following table 
```
#(
2 9 
3 5 
4 13 
6 11 
8 15 
12 14
)
``` 
and I'm missing some pairs.

I would like to get 
```
#(
1 1 
2 9 
3 5 
4 13 
5 3 
6 11 
7 7 
8 15 
9 2 
10 10
11 6 
12 14 
13 4 
14 12 
15 8 
16 16)
```


"
Class {
	#name : 'NFFTTest',
	#superclass : 'TestCase',
	#category : 'myBecher-DSPBook',
	#package : 'myBecher-DSPBook'
}

{ #category : 'tests - bit reverse table' }
NFFTTest >> testBitFlipsTableStartingAt1 [


	| in ou  fft res |
	in := { 1.  2 .  3 .  4 .  5 . 6 . 7 .  8}.
	ou := { 1.  5 .  3 .  7 .  2 . 6 . 4 .  8}.
	res := OrderedCollection new. 
	in with: ou do: [ :f :s | res add: f ; add: s ].
	res := res asArray.
	
	fft := NFFT new.
	fft sampleNumber: 8.
	fft computePermTableOfSize.
 	self 
		assert: fft permutationTable 
		equals: res. 
		
	" 
	for the record here is the zero based table 
		inputRe := { 0 . 1 .  2 .  3 .  4 .  5 . 6 . 7 }.
		outputRe := { 0 .  4 .  2 .  6 .  1 . 5 . 3 .  7}.
	"
]

{ #category : 'tests - bit reverse table' }
NFFTTest >> testBitReversed16bitsPrintingOut [
	
	| in ou res |
	in :=  { 0  .  1  .  2  .  3  .  4 .  5  .  6  . 7  . 8 . 9 . 10 . 11 . 12 . 13 . 14 . 15 }.
	ou :=  { 0  .  8  .  4  .  12 .  2 . 10  .  6  . 14 . 1 . 9 . 5  . 13 .  3 . 11 . 7 . 15 }.
	
	res := OrderedCollection new.  
	in with: ou do: [ :fst :scd | 
			res add: fst -> scd ].
	 self assert: 
			res asArray 
		equals: {0->0 . 1->8 . 2->4 . 3->12 . 4->2 . 5->10 . 6->6 . 7->14 . 8->1 . 9->9 . 10->5 . 11->13 . 12->3 . 13->11 . 14->7 . 15->15} 

]

{ #category : 'tests - bit reverse table' }
NFFTTest >> testBitReversed16bitsStartingAtOne [
	
	| in ou fft res |
	in :=  { 1  .  2  .  3  .  4  .  5 .  6  .  7  . 8  . 9 . 10 . 11 . 12 . 13 . 14 . 15 . 16 }.
	ou :=  { 1  .  9  .  5  .  13 .  3 .  11 .  7  . 15 . 2 . 10 . 6  . 14 .  4 . 12 . 8 .  16 }.
	
	res := OrderedCollection new. 
	in with: ou do: [ :f :s | res add: f ; add: s ].
	res := res asArray.
	
	fft := NFFT new.
	fft sampleNumber: 16.
	fft computePermTableOfSize.
 	self 
		assert: fft permutationTable 
		equals: res. 
		
	"for the record here is the zero based equivalent 
	in :=  { 0  .  1  .  2  .  3  .  4 .  5  .  6  . 7  . 8 . 9 . 10 . 11 . 12 . 13 . 14 . 15 }.
	ou :=  { 0  .  8  .  4  .  12 .  2 . 10  .  6  . 14 . 1 . 9 . 5  . 13 .  3 . 11 . 7 . 15 }.
	"

]

{ #category : 'tests - reversebit' }
NFFTTest >> testReverseBitOfSizeFive [
	| fft |
	fft := NFFT new. 
	self 
		assert: (fft reverseBit: 2r00001 ofSize: 5) 
		equals: 2r10000.
	self 
		assert: (fft reverseBit: 2r00011 ofSize: 5) 
		equals: 2r11000.
	self 
		assert: (fft reverseBit: 2r00101 ofSize: 5) 
		equals: 2r10100.
	self 
		assert: (fft reverseBit: 2r00111 ofSize: 5) 
		equals: 2r11100.
	
]

{ #category : 'tests - reversebit' }
NFFTTest >> testReverseBitOfSizeFour [
	| fft |
	fft := NFFT new. 
	self 
		assert: (fft reverseBit: 2r0001 ofSize: 4) 
		equals: 2r1000.
	self 
		assert: (fft reverseBit: 2r0010 ofSize: 4) 
		equals: 2r0100.
	self 
		assert: (fft reverseBit: 2r0011 ofSize: 4) 
		equals: 2r1100.
	self 
		assert: (fft reverseBit: 2r0100 ofSize: 4) 
		equals: 2r0010.
	
]

{ #category : 'tests - reversebit' }
NFFTTest >> testReverseBitOfSizeThree [
	| fft |
	fft := NFFT new. 
	self 
		assert: (fft reverseBit: 2r110 ofSize: 3) 
		equals: 2r011.
	self 
		assert: (fft reverseBit: 2r011 ofSize: 3) 
		equals: 2r110.
	self 
		assert: (fft reverseBit: 2r001 ofSize: 3) 
		equals: 2r100.
	self 
		assert: (fft reverseBit: 2r101 ofSize: 3) 
		equals: 2r101.
	self 
		assert: (fft reverseBit: 2r111 ofSize: 3) 
		equals: 2r111.
	self 
		assert: (fft reverseBit: 2r100 ofSize: 3) 
		equals: 2r001.
]
