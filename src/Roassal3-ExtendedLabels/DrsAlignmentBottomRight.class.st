Class {
	#name : #DrsAlignmentBottomRight,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentBottomRight class >> styleKey [ 

	^ #bottomRight
]

{ #category : #'as yet unclassified' }
DrsAlignmentBottomRight >> align: aShape in: aRectangle [

	aShape topLeftPosition: aRectangle bottomRight - (aShape extentForAlignment)
]
