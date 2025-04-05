Class {
	#name : 'AttestationGenerator',
	#superclass : 'Object',
	#instVars : [
		'template',
		'templateString',
		'resultString'
	],
	#category : 'myBecher-Attestation',
	#package : 'myBecher-Attestation'
}

{ #category : 'as yet unclassified' }
AttestationGenerator class >> generate [
	<script>
	| gen |
	gen := self new.
	gen templateStringFromReference: '/Users/ducasse/Madagascar/Attestation/AttestationTemplate.tex'.
	gen applyTemplate.
	gen generateFile.
		
]

{ #category : 'as yet unclassified' }
AttestationGenerator class >> installMustache [
	<script>
	Metacello new
        baseline: 'Mustache';
        repository: 'github://noha/mustache:v1.0/repository';
        load
]

{ #category : 'accessing' }
AttestationGenerator >> applyTemplate [


	resultString := (MustacheTemplate on: template) value: {
       'Nom' -> 'Ducasse'. 'Prénom' -> 'Stéphane' }
]

{ #category : 'accessing' }
AttestationGenerator >> templateStringFromReference: aStringPath [
	"self new templateStringFromReference: '/Users/ducasse/Madagascar/Attestation/AttestationTemplate.tex' "
		
	template := aStringPath asFileReference readStream contents.

	
]
