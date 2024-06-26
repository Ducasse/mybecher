Class {
	#name : 'BlCleanSliderWithAlain',
	#superclass : 'BlElement',
	#instVars : [
		'minValue',
		'maxValue',
		'stepValue',
		'sliderPixelMargin',
		'currentValue',
		'validatedValue',
		'validatedValueCallback',
		'sliderBar',
		'sliderBackground',
		'disabledRebuilding',
		'widgetSize',
		'maxPixelDistance',
		'enumeratedValues',
		'enumeratedColors',
		'initColor',
		'endColor',
		'barThickness',
		'isHorizontal',
		'eventHandler',
		'sliderHandle',
		'handlePushedPoint'
	],
	#category : 'myBecherBloc-slider',
	#package : 'myBecherBloc',
	#tag : 'slider'
}

{ #category : 'testing' }
BlCleanSliderWithAlain class >> alainVisual1 [

	<script>
	| bl |
	bl := self new.
	bl minValue: 0.
	bl maxValue: 20.
	bl stepValue: 1.
	bl enumeratedValues: #( 0 5 10 15 20 ).
	bl sliderPixelMargin: 20.
	bl size: 500 @ 25.
	bl buildSlider.
	bl validatedValueCallback: [ :e | "self changedTimeValue: e" ].
	bl margin: (BlInsets top: 5).
	bl openInSpace.
	bl inspect
]

{ #category : 'testing' }
BlCleanSliderWithAlain class >> alainVisual2 [

	<script>
	| bl2 |
	bl2 := self new.
	bl2 enumeratedColors: {
			Color lightBlue.
			Color blue.
			Color orange.
			Color red }.
	bl2 position: 0 @ 20.
	bl2 minValue: 50.
	bl2 maxValue: 200.
	bl2 stepValue: 50.
	bl2 size: 550 @ 48.
	bl2 sliderPixelMargin: 35.
	bl2 buildSlider.
	bl2 validatedValueCallback: [ :e | "self changedOperationalActivityValue: e"
		 ].
	bl2 openInSpace.
	bl2 inspect.
]

{ #category : 'building' }
BlCleanSliderWithAlain class >> backgroundDefaultColor [

	^ Color gray
]

{ #category : 'building' }
BlCleanSliderWithAlain class >> barDefaultColor [

	^ Color blue 
]

{ #category : 'building' }
BlCleanSliderWithAlain class >> defaultMaxPixelDistance [

	^ 25
]

{ #category : 'building' }
BlCleanSliderWithAlain class >> interactionDefaultColor [

	^ Color pink alpha: 0.5
]

{ #category : 'building' }
BlCleanSliderWithAlain class >> interactorDefaultColor [

	^ Color red 
]

{ #category : 'testing' }
BlCleanSliderWithAlain class >> visualTest1 [

	<script>
	| bl space val |
	bl := self new.
	bl minValue: 55.
	bl maxValue: 75.
	bl stepValue: 5.
	bl buildSlider.
	space := bl openInNewSpace.
	space windowExtent: 1920 @ 1050.
	space setPosition: 0 @ 30.
	val := space -> bl.
	^ val
]

{ #category : 'testing' }
BlCleanSliderWithAlain class >> visualTest2 [

	<script>
	| bl space val |
	bl := self new.
	bl minValue: 10.
	bl maxValue: 50.
	bl stepValue: 1.
	bl buildSlider.
	space := bl openInNewSpace.
	space windowExtent: 1920 @ 1050.
	space setPosition: 0 @ 30.
	val := space -> bl.
"	bl validatedValueCallback: [ :e | e inspect ]."
	val inspect.
	^ val
]

{ #category : 'testing' }
BlCleanSliderWithAlain class >> visualTest3 [

	<script>
	| bl space val |
	bl := self new.
	bl minValue: 10.
	bl maxValue: 50.
	bl stepValue: 0.1.
	bl buildSlider.
	space := bl openInNewSpace.
	space windowExtent: 1920 @ 1050.
	space setPosition: 0 @ 30.
	val := space -> bl.
	bl validatedValueCallback: [ :e | e inspect ].
	val inspect.
	^ val
]

{ #category : 'testing' }
BlCleanSliderWithAlain class >> visualTestVertical1 [

	<script>
	| bl space val |
	bl := self new.
	bl minValue: 10.
	bl maxValue: 50.
	bl stepValue: 1.
	bl buildSlider.
	space := bl openInNewSpace.
	space windowExtent: 1920 @ 1050.
	space setPosition: 0 @ 30.
	val := space -> bl.
	bl validatedValueCallback: [ :e | e inspect ].
	val inspect.
	^ val
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> barThickness: anObject [

	barThickness := anObject
]

{ #category : 'main configuration' }
BlCleanSliderWithAlain >> beHorizontal [  

	self horizontal: true
]

{ #category : 'main configuration' }
BlCleanSliderWithAlain >> beVertical [ 

	self horizontal: false
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildDefaultHandle [

	| bl pt |
	pt := 20 @ 20.
	bl := BlElement new
		      geometry: BlCircleGeometry new;
		      background: self class interactorDefaultColor;
		      size: pt;
		      transformDo: [ :t | t translateBy: pt negated / 2 ].
	^ bl
]

{ #category : 'build' }
BlCleanSliderWithAlain >> buildForeground [ 

	self id: #sliderInteractionForeground.
	self size: self widgetSize.
	self background: self class interactionDefaultColor.
]

{ #category : 'build' }
BlCleanSliderWithAlain >> buildHorizontalBackground [

	| bgElt |
	bgElt := BlElement new.
	bgElt size:
		self widgetSize x - (2 * self sliderPixelMargin) @ barThickness.
	bgElt id: #sliderBackground.
	bgElt position: self sliderPixelMargin
		@ (self widgetSize y / 2 - (barThickness / 2)).
	bgElt background: self class backgroundDefaultColor.
	bgElt zIndex: 0.
	self addChild: bgElt.
	self sliderBackground: bgElt
]

{ #category : 'build' }
BlCleanSliderWithAlain >> buildHorizontalBar [

	| bar |
	bar := BlElement new.
	bar size:
		(self valueToCoord: currentValue)
		- (self sliderPixelMargin) @ barThickness.
	bar id: #sliderBar.
	bar position: self sliderPixelMargin
		@ (self widgetSize y / 2 - (barThickness / 2)).
	bar background: self class barDefaultColor.
	bar zIndex: 2.
	self addChild: bar.
	self sliderBar: bar
]

{ #category : 'build' }
BlCleanSliderWithAlain >> buildHorizontalHandle [ 

	| handle pt |
	handle := self buildDefaultHandle.
	handle id: #sliderHandle.
	pt := (self valueToCoord: currentValue)
	      @ (self widgetSize y / 2).
	handle position: pt.
	handle zIndex: 3.
	self addChild: handle.
	self sliderHandle: handle
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildHorizontalSlider [

	self buildForeground.
	self buildHorizontalBackground.
	self buildHorizontalBar.
	self buildHorizontalHandle
]

{ #category : 'changing state' }
BlCleanSliderWithAlain >> buildOrientation [

	self removeAllShapes.
	self size: self widgetSize.
	self isHorizontal
		ifTrue: [ self buildHorizontalSlider ]
		ifFalse: [ self buildVerticalSlider ].
	self initializeEventHandlers
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> buildSlider [

	self buildOrientation.

]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildVerticalBackground [

	
	| bgElt pt1 pt2 |
	bgElt := BlElement new.
	pt1 := barThickness
	       @ (self widgetSize y - (2 * self sliderPixelMargin)).
	bgElt size: pt1.
	bgElt id: #sliderBackground.
	pt2 := self widgetSize x / 2 - ( barThickness / 2)
	       @ self sliderPixelMargin.
	bgElt position: pt2.
	bgElt background: self class backgroundDefaultColor.
	bgElt zIndex: 0.
	self addChild: bgElt.
	self sliderBackground: bgElt.

]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildVerticalBar [

	| bar |
	bar := BlElement new.
	bar size: barThickness
		@ (self widgetSize y - (self valueToCoord: currentValue)
			 - self sliderPixelMargin).
	bar id: #sliderBar.
	bar position: self widgetSize x / 2 - (barThickness / 2)
		@ (self valueToCoord: currentValue).
	bar background: self class barDefaultColor.
	bar zIndex: 2.
	self addChild: bar.
	self sliderBar: bar.

	
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildVerticalHandle [

	| handle pt |

	handle := self buildDefaultHandle.
	handle id: #sliderHandle.
	pt := self widgetSize x / 2 @ (self valueToCoord: currentValue).
	handle position: pt.
	handle zIndex: 3.
	self addChild: handle.
	self sliderHandle: handle
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> buildVerticalSlider [

	self buildForeground.
	self buildVerticalBackground.
	self buildVerticalBar.
	self buildVerticalHandle
]

{ #category : 'changing state' }
BlCleanSliderWithAlain >> changedCurrentValue: aValue [

^self changedCurrentValue: aValue withSlider: false
]

{ #category : 'changing state' }
BlCleanSliderWithAlain >> changedCurrentValue: aValue withSlider: aBool [

	| v color |
	v := self valueToCoord: aValue.
	self isHorizontal 
		ifTrue: [
			aBool ifTrue: [
				self sliderHandle ifNotNil: [ :sl |
					sl position: v @ sl constraints position y ] ].
			self sliderBar size:
				v - self sliderPixelMargin @ self sliderBar size y ]
		ifFalse: [
			aBool ifTrue: [
				self sliderHandle ifNotNil: [ :sl |
					sl position: sl constraints position x @ v ] ].
			self sliderBar size:  barThickness
				@ (self widgetSize y - (self valueToCoord: currentValue)
					 - self sliderPixelMargin).
			self sliderBar position:
				self widgetSize x / 2 - (barThickness / 2)
				@ (self valueToCoord: currentValue) ].
	color := self colorForValue: aValue.
	self sliderHandle background: color.
	self sliderBar background: color
]

{ #category : 'changing state' }
BlCleanSliderWithAlain >> changedHandlePosition: v [

	self isHorizontal 
		ifTrue: [
			self sliderHandle ifNotNil: [ :sl |
				sl position: v @ sl constraints position y ] ]
		ifFalse: [
			self sliderHandle ifNotNil: [ :sl |
				sl position: sl constraints position x @ v ] ]
]

{ #category : 'private' }
BlCleanSliderWithAlain >> cleanSliderParts [

	sliderBackground := nil.
	sliderBar := nil.
	sliderHandle := nil
]

{ #category : 'private' }
BlCleanSliderWithAlain >> colorForValue: aValue [

	| i |
	self enumeratedColors
		ifNil: [
			^  endColor
				  mixed: (self proportionOf: aValue)
				  with: self initColor ]
		ifNotNil: [ :list |
			i := self enumeratedValues indexOf: aValue.
			i = 0 ifTrue: [ ^ self initColor ].
			(i > list size) ifTrue: [ ^  endColor ].
			^list at: i ]
]

{ #category : 'private' }
BlCleanSliderWithAlain >> currentValue [

	^ currentValue
]

{ #category : 'private' }
BlCleanSliderWithAlain >> currentValue: aNumber [

	(aNumber <= maxValue and: [ aNumber >= minValue ]) ifFalse: [
		^ self ].
	currentValue := aNumber.
	self changedCurrentValue: aNumber
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> decrementValue [

	self decrementValue: self stepValue.
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> decrementValue: aValue [

	| tmp |
	tmp := validatedValue - aValue.
	tmp < self maxValue ifTrue: [ self validatedValue: tmp ]
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> disabledRebuilding [

	^ disabledRebuilding
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> disabledRebuilding: anObject [

	disabledRebuilding := anObject
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> endColor: anObject [

	endColor := anObject
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> enumeratedColors [

	^ enumeratedColors
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> enumeratedColors: anObject [

	enumeratedColors := anObject
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> enumeratedValues [
	"since the enumerated value are derived from min, max and step, we lazy initialize it."
	
	enumeratedValues ifNil: [
		enumeratedValues := (self minValue to: self maxValue by:
		                     self stepValue) asOrderedCollection ].
	^ enumeratedValues
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> enumeratedValues: anObject [

	enumeratedValues := anObject
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> handlePushedPoint [

	^ handlePushedPoint
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> handlePushedPoint: anObject [

	handlePushedPoint := anObject
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> horizontal: aBoolean [

	isHorizontal := aBoolean 
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> incrementValue [

	self incrementValue: self stepValue
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> incrementValue: aValue [

	| tmp |
	tmp := validatedValue + aValue.
	tmp < self maxValue ifTrue: [ self validatedValue: tmp ]
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> initColor [

	^ initColor
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> initColor: anObject [

	initColor := anObject
]

{ #category : 'initialization' }
BlCleanSliderWithAlain >> initialize [

	super initialize.
	barThickness := 8.
	maxValue := 100.0.
	minValue := 0.0.
	self size: 300 @ 30.
	currentValue := 0.0.
	self beHorizontal.
	sliderPixelMargin := 5.
	disabledRebuilding := false.
	stepValue := 1.
	endColor := self class interactorDefaultColor.
	initColor := self class interactorDefaultColor.
	maxPixelDistance := self class defaultMaxPixelDistance
]

{ #category : 'initialization' }
BlCleanSliderWithAlain >> initializeEventHandlers [

	self isSliderBuilt ifFalse: [
		^ self error: 'The slider must be built first' ].
	eventHandler ifNotNil: [ ^ self ].
	self flag: #toClean. "to be cleaned after"
	
	eventHandler := BlCleanSliderHandler new.
	self  addEventHandler: eventHandler
	

]

{ #category : 'private' }
BlCleanSliderWithAlain >> is: aValue near: aValue2 [

	^(aValue - aValue2) abs < self maxPixelDistance
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> isHorizontal [ 

	^ isHorizontal 
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> isSliderBuilt [
	"if no interactor, no slider"

	^ self sliderHandle isNotNil
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> maxPixelDistance [

	^ maxPixelDistance 
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> maxPixelDistance: anObject [

	maxPixelDistance := anObject
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> maxValue [

	^ maxValue
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> maxValue: anObject [
	"when we change the maxValue, we are rebuilding the enumerated values and slider"

	maxValue := anObject.
	enumeratedValues := nil.
	self isSliderBuilt ifTrue: [ self rebuildSlider ]
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> minValue [

	^ minValue
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> minValue: anObject [

	minValue := anObject.
	enumeratedValues := nil.
	currentValue < minValue ifTrue: [ currentValue := minValue copy ].
	self isSliderBuilt ifTrue: [ self rebuildSlider ]
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> nearestValue: aValue [

	| val minResult tmp tmp2 |
	self enumeratedValues ifNil: [ ^ aValue ].
	self enumeratedValues isEmpty ifTrue: [ ^ aValue ].
	val := self enumeratedValues first.
	minResult := (aValue - val) abs.
	2 to: enumeratedValues size do: [ :e |
		tmp := self enumeratedValues at: e.
		tmp2 := (aValue - tmp) abs.
		tmp2 < minResult ifTrue: [
			minResult := tmp2.
			val := tmp ] ].
	^ val
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> pointToValue: point [

	^ self isHorizontal 
		  ifTrue: [ self pointToXValue: point ]
		  ifFalse: [ self pointToYValue: point ]
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> pointToXValue: point [

	| facteur valeur |
	facteur := point x / self sliderBackground size x.
	valeur := self maxValue - self minValue * facteur.
	valeur := (valeur roundTo: (self stepValue ifNil: [ 1 ]))
	          + self minValue.
	valeur := self nearestValue: valeur.
	^ valeur
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> pointToYValue: point [

	| facteur valeur |
	facteur := 1 - (point y / self sliderBackground size y).
	valeur := self maxValue - self minValue * facteur.
	valeur := (valeur roundTo: (self stepValue ifNil: [ 1 ]))
	          + self minValue.
	valeur := self nearestValue: valeur.
	^ valeur
]

{ #category : 'private' }
BlCleanSliderWithAlain >> proportionOf: aValue [
	| i |
	i := self enumeratedValues indexOf: aValue.
	^ (i/self enumeratedValues size)
]

{ #category : 'private - building' }
BlCleanSliderWithAlain >> rebuildSlider [

	self disabledRebuilding ifTrue: [ ^ self ].
	self buildOrientation
]

{ #category : 'private' }
BlCleanSliderWithAlain >> removeAllShapes [

	| list |
	list := self sliderParts.
	self removeEventHandler.
	self removeChildren: list.
	self cleanSliderParts
]

{ #category : 'private' }
BlCleanSliderWithAlain >> removeAllSliderEventHandlers [
	self removeEventHandler: eventHandler.
	eventHandler := nil.
	
]

{ #category : 'private' }
BlCleanSliderWithAlain >> removeEventHandler [

	eventHandler ifNil: [ ^ self ].
	self flag: #toClean. "we should not test this"
	
	self removeEventHandler: eventHandler.
	eventHandler := nil.
	
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> setMaxValue [

	self setValue: self maxValue.
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> setMinValue [

	self setValue: self minValue
]

{ #category : 'api - slider' }
BlCleanSliderWithAlain >> setValue: aValue [

	(aValue < self maxValue and: [ aValue > self minValue ]) ifTrue: [
		self validatedValue: aValue ].
]

{ #category : 'api - bounds' }
BlCleanSliderWithAlain >> size: aValue [

	super size: aValue.
	self widgetSize: aValue.
	self isSliderBuilt ifTrue: [ self rebuildSlider ]
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderBackground [

	^ sliderBackground
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderBackground: anObject [

	sliderBackground := anObject
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderBar [

	^ sliderBar
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderBar: anObject [

	sliderBar := anObject
]

{ #category : 'events - bar' }
BlCleanSliderWithAlain >> sliderBarClicked: event [

	| tmp val |
	tmp := self sliderBackground globalPointToLocal: event position.
	val := self pointToValue: tmp.
	self validatedValue: val.
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderHandle [

	^ sliderHandle
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderHandle: anObject [

	sliderHandle := anObject
]

{ #category : 'events - interactor' }
BlCleanSliderWithAlain >> sliderHandleMoved: event [

	| val tmp v |
	self handlePushedPoint ifNil: [ ^ self ].
	tmp := self sliderBackground globalPointToLocal: event position.
	val := self pointToValue: tmp.
	tmp := self globalPointToLocal: event position.
	self isHorizontal
		ifTrue: [
			v := tmp x.
			v := v min: (self valueToX: self maxValue).
			v := v max: (self valueToX: self minValue) ]
		ifFalse: [
			v := tmp y.
			v := v min: (self valueToY: self minValue).
			v := v max: (self valueToY: self maxValue) ].

	self changedHandlePosition: v.
	self currentValue: val
]

{ #category : 'events - interactor' }
BlCleanSliderWithAlain >> sliderHandlePushed: event [

	| value pt1 pt2 |
	self sliderBar ifNil: [ ^ self ].
	value := self pointToValue:
		         (self sliderBackground globalPointToLocal: event position).
	pt1 := self valueToX: value.
	pt2 := self valueToX: currentValue.
	(self is: pt1 near: pt2) ifTrue: [
		self handlePushedPoint: event position copy ]
]

{ #category : 'events - interactor' }
BlCleanSliderWithAlain >> sliderHandleReleased: event [

	self handlePushedPoint ifNil: [ ^ self ].
	self handlePushedPoint: nil.
	self validatedValue: currentValue
]

{ #category : 'private' }
BlCleanSliderWithAlain >> sliderParts [

	| oc |
	oc := OrderedCollection new.
	self sliderBackground ifNotNil: [ :e | oc add: e ].
	self sliderBar ifNotNil: [ :e | oc add: e ].
	self sliderHandle ifNotNil: [ :e | oc add: e ].
	^ oc
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderPixelMargin [

	^ sliderPixelMargin 
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> sliderPixelMargin: anObject [

	sliderPixelMargin := anObject.
	self isSliderBuilt ifTrue: [ 
		self rebuildSlider ]
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> stepValue [

	^ stepValue
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> stepValue: anObject [

	stepValue := anObject.
	enumeratedValues := nil.
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> validatedValue [

	^ validatedValue
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> validatedValue: aValue [

	currentValue := aValue.
	self changedCurrentValue: aValue withSlider: true. 
	validatedValue := aValue.
	self validatedValueCallback ifNotNil: [ :e | e value: validatedValue ]
]

{ #category : 'private' }
BlCleanSliderWithAlain >> validatedValueCallback [

	^ validatedValueCallback
]

{ #category : 'api - values' }
BlCleanSliderWithAlain >> validatedValueCallback: anObject [

	validatedValueCallback := anObject
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> valueToCoord: aValue [

	^ self isHorizontal 
		  ifTrue: [ self valueToX: aValue ]
		  ifFalse: [ self valueToY: aValue ]
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> valueToX: aValue [

	| current total coeff |
	current := aValue - self minValue.
	total := self maxValue - self minValue.
	coeff := current / total.
	^ self sliderPixelMargin
	  + (self sliderBackground constraints horizontal resizer size * coeff roundTo: 1)
]

{ #category : 'api - transformations' }
BlCleanSliderWithAlain >> valueToY: aValue [

	| valeurCourante valeurTotale facteur |
	valeurCourante := aValue - self minValue.
	valeurTotale := self maxValue - self minValue.
	facteur := 1 - (valeurCourante / valeurTotale).
	^ self sliderPixelMargin
	  +
		  (self sliderBackground constraints vertical resizer size * facteur
			   roundTo: 1)
]

{ #category : 'accessing' }
BlCleanSliderWithAlain >> widgetSize [

	^ widgetSize
]

{ #category : 'private' }
BlCleanSliderWithAlain >> widgetSize: anObject [

	widgetSize := anObject
]
