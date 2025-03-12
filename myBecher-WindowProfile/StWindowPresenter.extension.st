Extension { #name : 'StWindowPresenter' }

{ #category : '*myBecher-WindowProfile' }
StWindowPresenter >> openWith: aSpecLayout [

	CavroisWindowManager current placePresenter: self.
	self openWithLayout: aSpecLayout
]
