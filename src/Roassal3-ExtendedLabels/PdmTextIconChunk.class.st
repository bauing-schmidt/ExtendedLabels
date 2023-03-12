"
A text chunk holding an icon
"
Class {
	#name : #PdmTextIconChunk,
	#superclass : #PdmTextChunk,
	#instVars : [
		'icon'
	],
	#category : #'Roassal3-ExtendedLabels-Text'
}

{ #category : #accessing }
PdmTextIconChunk >> asLabelChunk [ 

	^ self asLabelChunk: nil
]

{ #category : #accessing }
PdmTextIconChunk >> asLabelChunk: aString [

	^ DrsLabelIconChunk new icon: self icon.
]

{ #category : #accessing }
PdmTextIconChunk >> icon [

	^ icon
]

{ #category : #accessing }
PdmTextIconChunk >> icon: anObject [

	icon := anObject
]

{ #category : #initialization }
PdmTextIconChunk >> initializeWith: anIcon styles: aCollectionOfNames [

	super initializeWith: anIcon styles: aCollectionOfNames.
	
	icon := anIcon

]

{ #category : #initialization }
PdmTextIconChunk >> initializeWith: anIcon styles: aCollectionOfNames  variants: variants [

	super initializeWith: anIcon styles: aCollectionOfNames  variants: variants.

	icon := anIcon.

]

{ #category : #initialization }
PdmTextIconChunk >> string [

	^ '☐'
]
