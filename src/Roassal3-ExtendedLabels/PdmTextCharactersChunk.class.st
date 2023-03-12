"
A text chunk holding a string
"
Class {
	#name : #PdmTextCharactersChunk,
	#superclass : #PdmTextChunk,
	#instVars : [
		'string'
	],
	#category : #'Roassal3-ExtendedLabels-Text'
}

{ #category : #accessing }
PdmTextCharactersChunk >> asLabelChunk [ 

	^ self asLabelChunk: self string.
]

{ #category : #accessing }
PdmTextCharactersChunk >> asLabelChunk: aString [

	^ DrsLabelCharacterChunk new text: aString
]

{ #category : #initialization }
PdmTextCharactersChunk >> initializeWith: aString styles: aCollectionOfNames [

	super initializeWith: aString styles: aCollectionOfNames.
	
	string := aString.

]

{ #category : #initialization }
PdmTextCharactersChunk >> initializeWith: aString styles: aCollectionOfNames  variants: variants [

	super initializeWith: aString styles: aCollectionOfNames  variants: variants.

	string := aString.

]

{ #category : #accessing }
PdmTextCharactersChunk >> string [

	^ string
]

{ #category : #accessing }
PdmTextCharactersChunk >> string: anObject [

	string := anObject
]
