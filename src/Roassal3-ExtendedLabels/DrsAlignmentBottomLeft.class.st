Class {
	#name : #DrsAlignmentBottomLeft,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentBottomLeft class >> styleKey [ 

	^ #bottomLeft
]

{ #category : #'as yet unclassified' }
DrsAlignmentBottomLeft >> align: aShape in: aRectangle [

	aShape topLeftPosition: aRectangle bottomLeft - (0 @ aShape extentForAlignment y)
]
