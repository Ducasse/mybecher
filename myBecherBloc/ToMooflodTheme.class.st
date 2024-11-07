Class {
	#name : 'ToMooflodTheme',
	#superclass : 'ToTheme',
	#category : 'myBecherBloc-Input skin',
	#package : 'myBecherBloc',
	#tag : 'Input skin'
}

{ #category : 'accessing' }
ToMooflodTheme class >> defaultTokenProperties [
	"define here token properties of the widget theme"

	^ super defaultTokenProperties
	  ,
	  { (ToTokenProperty
		   name: #'background-color'
		   value: Color lightGreen) }
]

{ #category : 'accessing' }
ToMooflodTheme >> newSkinInstanceFor: anElement [

	^ anElement newMooflodSkin
]
