Class {
	#name : #DrsAlignmentLeftCenter,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentLeftCenter class >> styleKey [ 

	^ #leftCenter
]

{ #category : #'as yet unclassified' }
DrsAlignmentLeftCenter >> align: aShape in: aRectangle [
	
	aShape topLeftPosition: aRectangle leftCenter - (0 @ aShape extentForAlignment y half ).
]
