Class {
	#name : #DrsAlignmentTopCenter,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentTopCenter class >> styleKey [ 

	^ #topCenter
]

{ #category : #'as yet unclassified' }
DrsAlignmentTopCenter >> align: aShape in: aRectangle [
	
	aShape topLeftPosition: aRectangle topCenter - (aShape extentForAlignment x half @ 0).
]
