"
A text composed of multiple formatted text chunks that have assigned style classes.
"
Class {
	#name : #PdmText,
	#superclass : #Object,
	#instVars : [
		'chunks',
		'fullLength',
		'linesScaling',
		'styleVariants',
		'wrappingEnabled'
	],
	#category : #'Roassal3-ExtendedLabels-Text'
}

{ #category : #'as yet unclassified' }
PdmText class >> string: aString [

	"a convenience constructor for text with only one chunk"

	^ self new 
		addString: aString styles: #();
		yourself
]

{ #category : #'as yet unclassified' }
PdmText class >> string: aString style: aStyleName [

	"a convenience constructor for text with only one chunk"

	^ self new 
		addString: aString style: aStyleName;
		yourself
]

{ #category : #'as yet unclassified' }
PdmText class >> string: aString styles: styleNames [

	"a convenience constructor for text with only one chunk"

	^ self new 
		addString: aString styles: styleNames;
		yourself
]

{ #category : #'as yet unclassified' }
PdmText class >> string: aString styles: styleNames variants: styleVariants [

	"a convenience constructor for text with only one chunk"

	^ self new 
	   styleVariants: styleVariants;
		addString: aString styles: styleNames;
		yourself
]

{ #category : #'as yet unclassified' }
PdmText class >> style: aStyleName [

	"a convenience constructor for an empty text with only one chunk"

	^ self new 
		addString: '' style: aStyleName;
		yourself
]

{ #category : #'as yet unclassified' }
PdmText class >> styles: styleNames [

	"a convenience constructor for an empty text with only one chunk"

	^ self new 
		addString: '' styles: styleNames;
		yourself
]

{ #category : #'API - adding' }
PdmText >> addChunk: aChunk [ 

	^ chunks add: aChunk
]

{ #category : #'API - adding' }
PdmText >> addIcon: anIcon [  

	| anIconChunk | 
		
	anIconChunk := PdmTextIconChunk new 
		icon:  anIcon;
		yourself.
	fullLength := fullLength + anIconChunk string size.

	self addChunk: anIconChunk.
]

{ #category : #'API - adding' }
PdmText >> addString: aString [

	fullLength := fullLength + aString size.

	^ self addChunk: (PdmTextCharactersChunk with: aString styles: #(  ))
]

{ #category : #'API - adding' }
PdmText >> addString: aString style: aStyle [

	fullLength := fullLength + aString size.
	^ self addChunk: (PdmTextCharactersChunk with: aString style: aStyle)
]

{ #category : #'API - adding' }
PdmText >> addString: aString styles: styleNames [

	fullLength := fullLength + aString size.
	^ self addChunk: (PdmTextCharactersChunk with: aString styles: styleNames variants: styleVariants)
]

{ #category : #accessing }
PdmText >> asString [ 

	^ String streamContents: [ :aStream |
		chunks do: [ :aChunk | 
			aStream nextPutAll: aChunk string ] ]
]

{ #category : #accessing }
PdmText >> chunks [ 

	^ chunks
]

{ #category : #accessing }
PdmText >> fullLength [

	^ fullLength
]

{ #category : #initialization }
PdmText >> initialize [

	super initialize.

	chunks := OrderedCollection new.
	fullLength := 0.
	styleVariants := #(default).

]

{ #category : #accessing }
PdmText >> styleVariants [

	^ styleVariants
]

{ #category : #accessing }
PdmText >> styleVariants: anObject [

	styleVariants := anObject
]
