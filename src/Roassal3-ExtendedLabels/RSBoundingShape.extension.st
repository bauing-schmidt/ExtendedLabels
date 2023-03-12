Extension { #name : #RSBoundingShape }

{ #category : #'*Roassal3-ExtendedLabels' }
RSBoundingShape >> topLeftCornerPosition [

	^ self position - (self shape extent/2)
]

{ #category : #'*Roassal3-ExtendedLabels' }
RSBoundingShape >> topLeftCornerPosition: aPosition [

	self position: aPosition + (self shape extent/2)
]
