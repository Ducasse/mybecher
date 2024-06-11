Class {
	#name : #ToMooflooTheme,
	#superclass : #ToTheme,
	#category : #'myBecherBloc-Input'
}

{ #category : #accessing }
ToMooflooTheme class >> defaultTokenProperties [
	"define here token properties of the widget theme"

	^ super defaultTokenProperties
	  ,
	  { (ToTokenProperty
		   name: #'background-color'
		   value: Color lightGreen) }
]

{ #category : #accessing }
ToMooflooTheme >> newSkinInstanceFor: anElement [

	^ anElement newMooflooSkin
]
