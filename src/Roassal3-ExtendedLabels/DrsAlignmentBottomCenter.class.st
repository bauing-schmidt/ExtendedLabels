Class {
	#name : #DrsAlignmentBottomCenter,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentBottomCenter class >> styleKey [ 

	^ #bottomCenter
]

{ #category : #'as yet unclassified' }
DrsAlignmentBottomCenter >> align: aShape in: aRectangle [
	
	aShape topLeftPosition: aRectangle bottomCenter - (aShape extentForAlignment x half @ aShape extentForAlignment y).
]
