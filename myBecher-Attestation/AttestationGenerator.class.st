Class {
	#name : 'AttestationGenerator',
	#superclass : 'Object',
	#instVars : [
		'resultString',
		'templateString',
		'templateFileReference',
		'generatedFolder'
	],
	#category : 'myBecher-Attestation',
	#package : 'myBecher-Attestation'
}

{ #category : 'scripts-some' }
AttestationGenerator class >> generate [
	<script>
	
	| gen |
	gen := self new.
	gen templateStringFromReference: '/Users/ducasse/Desktop/Madagascar/Attestation/Resources/AttestationTemplate.tex'.
	gen installFiles.
	gen generateFiles.
		
]

{ #category : 'scripts-some' }
AttestationGenerator class >> installMustache [
	<script>
	Metacello new
        baseline: 'Mustache';
        repository: 'github://noha/mustache:v1.0/repository';
        load
]

{ #category : 'accessing' }
AttestationGenerator >> applyTemplate: aValue [
	"  Metacello new
        baseline: 'Mustache';
        repository: 'github://noha/mustache:v1.3/repository';
        load"

	resultString := (MustacheTemplate  on: templateString) value: { 'N' -> aValue } asDictionary
]

{ #category : 'accessing' }
AttestationGenerator >> generateFiles [	
	
	| name |
	(self students splitOn: Character cr)
		do: [ :each | 
			name := each copyWithoutAll: { Character space . Character tab}. 
			self applyTemplate: each.
			(generatedFolder / name , 'tex') 
				writeStreamDo: [:s| s nextPutAll: resultString] 	
			]	
	
	
]

{ #category : 'accessing' }
AttestationGenerator >> installFiles [
	"self new templateStringFromReference: '/Users/ducasse/Desktop/Madagascar/Attestation/Resources/AttestationTemplate.tex';
	installFiles"
	
	generatedFolder := templateFileReference parent parent / 'generated'.
	generatedFolder ensureDeleteAllChildren.
	generatedFolder ensureDelete.
	templateFileReference parent parent / 'Resources' copyAllTo: generatedFolder.
	templateFileReference parent parent / 'buildAll.sh' copyTo: generatedFolder / 'buildAll.sh'
	
]

{ #category : 'accessing' }
AttestationGenerator >> students [

	^ 'Tahinjanahary Marie Angela	RAMANDIMBINIRINA
Maho Christine	RASOANAMBININA
Fifaliana Angela	RAFANOMEZANJANAHARY
Sharon Constancia	ASINDRAMINO
Louisa Karoza	ANDRIANDRAINA
Fifaliana Nicole	ANDRIATAHINA
Fenofitia Josia Mahatoky	RAJAOARISON
Zaratiana Fify	NELY
Victorino	 RAMAMINIRINA
Solomanoa Fanantenana	ANDRIANAVALONA
Mbolatiana Harinavalona	RAMIARAMANANA
Rojo Davida Richard	RANDRIANARIVO
Jim Miurah Giana Sadiah	RAZAFINIRINA
Eloïc	HARENARISOA
Miza Tommy	RAKOTONDRAZAKA
Tsiory Raphaël	MANALINJATO
Angelo patrick	ANDRIAMBOLOLONA
Heritiana Mirado	RAKOTONINDRINA
Mialy	RAKOTONIRINA
Nekena Claudia	RAKOTOZAFY
Ranoelisoa Sanya	ANDRIAMALAZA
Andrianatoavina Jean Modeste	RAFANOMEZANTSOA
Tojonirina Fitahiana	MIHANTARISOA
Riana Riccardo Nomenjanahary	RAKOTONDRAVELO
Dimbiniaina Jordany	RAZAKAMANANTSOA
Léa Angelica	MAMIARISOA
Antonio Hery	RAMAMONJISOA
Najoronirainy Erico	ANDRIANANDROSON
i Ilo Mahomby	RANDRIANATOANDRO
Sandra	MADANIRINA
Jean Sébastien	RAFALIMANANA
Santatraniaina Candy Pascaline	MAHARETANIFARANY
Hanitriniala Nicole	RAKOTOSON
Mariot Duhamel	RAMANANA
Fenoarisoa Marcella	SOJANDRIMALALA
Benito Eddy	RANDRIANIRAINY
Ambinintsoa Paula	RAZAFIMANDIMBY
Indrafo Henri	MAMINIAINA
Minoharisoa Tokifanantenana	RAVAKINIAINA
Bruni Avellin Romualdo	RAHERINIRINA
Narovana Patrick	HASIMANJAKA
Herinantenina Clark	ANDRINIRINA
Mandresy Hery Setra	RAZAFIMAMONJY
Rindra Nantenaina	RALAIKOA
Tahiry Fanomezantsoa Noël	RAVELOMAHEFA
Fanomezana Emilie	NIRINASOA
Nomeniony Samuël	ANDRIANANDRASANA
John Aris Georgino	SOLONANTENAINA
Vonaniaina	RAZAFIMAHARAVO
Daniel Yvan	RANIRIHARINOSY
Ny Fahafahana Lanja	RANDRIAMANANTENA
NONDY
Stenny 	RAJAOHARIMANANA
Yam 	RAHARISON
Thierry Bercytino	RAHOLISON
Antsaniaina Josée Rita	RAMANANDRAIBE
Manantsoa Aimé Angelo	RATSARAHARIVOLA
Abelson Nicolas	RAMAHALEFITRA
Victor	 HERY
Maurice Emar	ZAFIMANJAKA
Mahazaka Esprit	ANDRIAMBELOHASINARIVO
Ndrianja Iantsatiana	RAJAONARIVONY
Harilalaina Fifaliana	RAHARSON
Solo Soaniaina	SOALAHANTSOA
Alexis Nirina Albert	JEAN
Toky Niaina	RAZAFFERSON
Jean Brillant	RAMAHATOMMBO
Fenoanjara Louis Philippe	SENGA
Fanirindrainy Emmanüelle	RANDRIAMIHAJARIVO
Eversol Nader-El-Sayed	HASINDRAY ANDRIAHARENTSOA MIARINA
Miharisoa Muguet MAMINIRINA
Werner Lodwige JOSEMS 
Olivier Martial Randriamihaja 
Zafimanarivo SALA ANDRIAMIARO 
Richard ULRICH'
]

{ #category : 'accessing' }
AttestationGenerator >> templateString [

	^ templateString
]

{ #category : 'accessing' }
AttestationGenerator >> templateString: anObject [

	templateString := anObject
]

{ #category : 'accessing' }
AttestationGenerator >> templateStringFromReference: aStringPath [
	"self new templateStringFromReference: '/Users/ducasse/Madagascar/Attestation/AttestationTemplate.tex' "
	
	templateFileReference := aStringPath asFileReference.
	templateString := templateFileReference readStream contents.

	
]
