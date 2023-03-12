Class {
	#name : #DrsAlignmentRightCenter,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentRightCenter class >> styleKey [ 

	^ #rightCenter
]

{ #category : #'as yet unclassified' }
DrsAlignmentRightCenter >> align: aShape in: aRectangle [
	
	aShape topLeftPosition: aRectangle rightCenter - (aShape extentForAlignment x @ aShape extentForAlignment y half ).
]
