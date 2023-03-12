Class {
	#name : #DrsAlignmentCenter,
	#superclass : #DrsAlignment,
	#category : #'Roassal3-ExtendedLabels-Allignment'
}

{ #category : #API }
DrsAlignmentCenter class >> styleKey [ 

	^ #centerCenter
]

{ #category : #'as yet unclassified' }
DrsAlignmentCenter >> align: aShape in: aRectangle [

	aShape topLeftPosition: aRectangle center - aShape extentForAlignment half
]
