Class {
	#name : #DrsAlignmentTopRight,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentTopRight class >> styleKey [ 

	^ #topRight
]

{ #category : #'as yet unclassified' }
DrsAlignmentTopRight >> align: aShape in: aRectangle [

	aShape topLeftPosition: aRectangle topRight - (aShape extentForAlignment x @ 0)
]
