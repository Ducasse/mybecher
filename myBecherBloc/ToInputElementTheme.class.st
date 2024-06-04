Class {
	#name : #ToInputElementTheme,
	#superclass : #ToRawTheme,
	#category : #'myBecherBloc-Input'
}

{ #category : #accessing }
ToInputElementTheme class >> defaultTokenProperties [
	"define here token properties of the widget theme"

	^ super defaultTokenProperties
	  ,
	  { (ToTokenProperty
		   name: #'background-color'
		   value: Color lightGreen) }
]
