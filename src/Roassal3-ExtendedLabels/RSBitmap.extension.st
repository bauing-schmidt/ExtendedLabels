Extension { #name : #RSBitmap }

{ #category : #'*Roassal3-ExtendedLabels' }
RSBitmap >> baseline [ 

	^ self propertyAt: #baseline ifAbsent: [ 16 ]
]

{ #category : #'*Roassal3-ExtendedLabels' }
RSBitmap >> baseline: aBaseline [ 

	self propertyAt: #baseline put: aBaseline.

]
