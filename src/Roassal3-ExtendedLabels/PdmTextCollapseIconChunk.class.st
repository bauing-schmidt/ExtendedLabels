Class {
	#name : #PdmTextCollapseIconChunk,
	#superclass : #PdmTextIconChunk,
	#category : #'Roassal3-ExtendedLabels-Text'
}

{ #category : #converting }
PdmTextCollapseIconChunk >> asLabelChunk: aString [

	^ (super asLabelChunk: aString)
		paddingLeft: self leftOffset;
		yourself
]

{ #category : #converting }
PdmTextCollapseIconChunk >> leftOffset [

	^ 4
]
