Extension { #name : 'StWindowPresenter' }

{ #category : '*myBecher-WindowProfile' }
StWindowPresenter >> openWith: aSpecLayout [

	CavroisWindowManager current currentProfile ifNotNil: [
		((CavroisWindowManager current currentProfile placeHoldersFor:
			  self presenter class) first isKindOf: CavNullWindowPlaceHolder)
			ifFalse: [
				CavroisWindowManager current placePresenter: self presenter.
				self initialPosition: self presenter position ] ].

	self openWithLayout: aSpecLayout
]
