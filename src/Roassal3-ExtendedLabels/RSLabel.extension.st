Extension { #name : #RSLabel }

{ #category : #'*Roassal3-ExtendedLabels' }
RSLabel >> baseline [ 

	^ 	self font getPreciseAscent
]

{ #category : #'*Roassal3-ExtendedLabels' }
RSLabel >> baseline: aBaseline [ 

	self propertyAt: #baseline put: aBaseline.

]

{ #category : #'*Roassal3-ExtendedLabels' }
RSLabel >> font: aFont color: aColor [

	"utility method to prevent multiple font resets"
	
	font := aFont.
	self color: aColor.	
	fontSize := font pointSize.
	fontName := font familyName.
	emphasis := TextEmphasis fromCode: font emphasis.
	self fontName: self privateFontName.
	self resetCache.
	
]
