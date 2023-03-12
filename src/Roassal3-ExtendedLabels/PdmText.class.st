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
PdmText >> ellipsis [

	^ '…'
]

{ #category : #accessing }
PdmText >> expandIconSpace [ 

	^ 16
]

{ #category : #accessing }
PdmText >> firstChunkOrNil [ 

	chunks ifEmpty: [ ^ nil ].
	
	^ chunks first
]

{ #category : #accessing }
PdmText >> firstStyle: styleName from: aStyleSheet default: aDefaultValue [ 

	| style |
	
	style := self firstStyleOrNilFrom: aStyleSheet.
	style ifNil: [ ^ aDefaultValue ].
	
	^ style get: styleName defaultValue: aDefaultValue
]

{ #category : #accessing }
PdmText >> firstStyle: styleName from: aStyleSheet variants: styleVariants default: aDefaultValue [ 

	| style |
	
	style := self firstStyleOrNilFrom: aStyleSheet variants: styleVariants.
	style ifNil: [ ^ aDefaultValue ].
	
	^ style get: styleName defaultValue: aDefaultValue
]

{ #category : #accessing }
PdmText >> firstStyleOrNilFrom: aStyleSheet [

	| firstChunk | 
	
	firstChunk := self firstChunkOrNil.
	firstChunk ifNil: [ ^ firstChunk ].
	
	^ aStyleSheet
			stylesFrom: firstChunk styleClassNames
			variants: styleVariants 
			key: firstChunk lookUpKey 
			

]

{ #category : #accessing }
PdmText >> firstStyleOrNilFrom: aStyleSheet variants: styleVariants [

	| firstChunk | 
	
	firstChunk := self firstChunkOrNil.
	firstChunk ifNil: [ ^ firstChunk ].
	
	^ aStyleSheet
			stylesFrom: firstChunk styleClassNames
			variants: styleVariants

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
PdmText >> labelChunksWith: aStyleSheet length: aLength [

	"creates label chunks to later use them for creation of real labels"

	| aFontName aFontSize aColor currentColor labelChunks freeLength nextChunksAreHidden |
	aFontName := aStyleSheet defaultFontName.
	aFontSize := aStyleSheet defaultFontSize.
	aColor := aStyleSheet defaultColor.

	freeLength := aLength.
	nextChunksAreHidden := false.

	labelChunks := OrderedCollection new.

	self chunks do: [ :aPdmChunk | 
		| labelChunk styles |
		labelChunk := aPdmChunk asLabelChunk.
		labelChunk startingIndex: (aLength - freeLength + 1).

		nextChunksAreHidden
			ifTrue: [ labelChunk length: -1 ]
			ifFalse: [ 
				freeLength < aPdmChunk string size ifTrue: [ 
					labelChunk length: freeLength ].
				freeLength := freeLength - labelChunk length ].

		((nextChunksAreHidden not and: [ freeLength = 0 ]) and: [ labelChunk isShrinked ]) ifTrue: [ 
			nextChunksAreHidden := true ].

		styles := aStyleSheet
			          stylesFrom: aPdmChunk styleClassNames
						 variants: styleVariants 
			          key: aPdmChunk lookUpKey.

		"running values"
		aFontName := styles get: 'fontName' defaultValue: aFontName.
		aFontSize := styles get: 'fontSize' defaultValue: aFontSize.
		currentColor := styles get: 'textColor' defaultValue: nil.
		aColor := currentColor
			          ifNil: [ aColor ]
			          ifNotNil: [ currentColor ].

		labelChunk fontName: aFontName size: aFontSize color: aColor.

	labelChunk isVisible ifTrue: [ 
		labelChunks add: labelChunk ] ].

	^ labelChunks
]

{ #category : #accessing }
PdmText >> styleVariants [

	^ styleVariants
]

{ #category : #accessing }
PdmText >> styleVariants: anObject [

	styleVariants := anObject
]
