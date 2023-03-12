Class {
	#name : #DrsAlignmentTopLeft,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentTopLeft class >> styleKey [ 

	^ #topLeft
]

{ #category : #'as yet unclassified' }
DrsAlignmentTopLeft >> align: aShape in: aRectangle [

	aShape topLeftPosition: aRectangle topLeft
]
