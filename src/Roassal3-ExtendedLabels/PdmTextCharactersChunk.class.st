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
