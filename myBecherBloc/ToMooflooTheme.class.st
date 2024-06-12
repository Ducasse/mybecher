Class {
	#name : 'ToMooflooTheme',
	#superclass : 'ToTheme',
	#category : 'myBecherBloc-Input',
	#package : 'myBecherBloc',
	#tag : 'Input'
}

{ #category : 'accessing' }
ToMooflooTheme class >> defaultTokenProperties [
	"define here token properties of the widget theme"

	^ super defaultTokenProperties
	  ,
	  { (ToTokenProperty
		   name: #'background-color'
		   value: Color lightGreen) }
]

{ #category : 'accessing' }
ToMooflooTheme >> newSkinInstanceFor: anElement [

	^ anElement newMooflodSkin
]
