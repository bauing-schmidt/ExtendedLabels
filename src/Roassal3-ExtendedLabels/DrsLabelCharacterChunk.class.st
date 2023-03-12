Class {
	#name : #DrsLabelCharacterChunk,
	#superclass : #DrsLabelChunk,
	#instVars : [
		'text',
		'font',
		'color',
		'characterPositions',
		'fullSize'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsLabelCharacterChunk >> baseline [

	^ baseline
]

{ #category : #accessing }
DrsLabelCharacterChunk >> baseline: anObject [

	baseline := anObject
]

{ #category : #accessing }
DrsLabelCharacterChunk >> characterPositions [

	^ characterPositions ifNil: [ self resetCharacterPositions ]
]

{ #category : #accessing }
DrsLabelCharacterChunk >> color [

	^ color
]

{ #category : #accessing }
DrsLabelCharacterChunk >> color: anObject [

	color := anObject
]

{ #category : #accessing }
DrsLabelCharacterChunk >> createShape [ 

	| aLabel |
	
	aLabel := RSLabel new.
	aLabel propertyAt: #lineIndex put: self lineIndex. 
	aLabel font: self font color: self color.
	aLabel text: self displayedString.
	aLabel fontSize: self font pointSize.
	aLabel propertyAt: #paddingOffset put: self paddingOffset.
	
	^ aLabel
]

{ #category : #accessing }
DrsLabelCharacterChunk >> displayedString [

	length = text size ifTrue: [ ^ text ].
	length < 0 ifTrue: [ ^ '' ]. "hidden chunks"
	^ (self text first: length) , self ellipsis
]

{ #category : #accessing }
DrsLabelCharacterChunk >> ellipsis [

	^ '…'
]

{ #category : #accessing }
DrsLabelCharacterChunk >> font [

	^ font
]

{ #category : #accessing }
DrsLabelCharacterChunk >> font: anObject [

	font := anObject
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fontName [ 

	^ font familyName
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fontName: aString size: aNumber color: aColor [

	font := LogicalFont familyName: aString pointSize: aNumber.
   ellipsisWidth := (self metricsProvider
			                    characterPositionsFor: self ellipsis
			                    font: font) second.
	baseline := font ascent half
	            * (font getPreciseAscent / font getPreciseHeight).

	self color: aColor
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fontSize [ 

	^ font pointSize
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fullLength [

	^ self text size
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fullSize [

	^ fullSize
]

{ #category : #accessing }
DrsLabelCharacterChunk >> fullSize: anObject [

	fullSize := anObject
]

{ #category : #accessing }
DrsLabelCharacterChunk >> height [ 

	^ font height "ascent + descent"
]

{ #category : #accessing }
DrsLabelCharacterChunk >> initialize [ 

	super initialize.
	lineIndex := 1.
]

{ #category : #'as yet unclassified' }
DrsLabelCharacterChunk >> isSeparator: aCharacter [ 

	('()., _+-' includes: aCharacter) ifTrue: [ ^ true ].
	
	^ false 
]

{ #category : #testing }
DrsLabelCharacterChunk >> isShrinked [ 

	^ self length ~= self text size
]

{ #category : #accessing }
DrsLabelCharacterChunk >> lineIndex [

	^ lineIndex
]

{ #category : #accessing }
DrsLabelCharacterChunk >> lineIndex: anObject [

	lineIndex := anObject
]

{ #category : #accessing }
DrsLabelCharacterChunk >> metricsProvider [

	^ DrsLabel metricsProvider
]

{ #category : #accessing }
DrsLabelCharacterChunk >> paddingOffset [

	^ 0@0
]

{ #category : #accessing }
DrsLabelCharacterChunk >> resetCharacterPositions [ 

	^ characterPositions := self metricsProvider
		  characterPositionsFor: self text
		  font: font 
]

{ #category : #'as yet unclassified' }
DrsLabelCharacterChunk >> subChunkOfMaxLength: maxLength for: aLabelOrNil [

	| positions index aString lastPart newLength newText | 
	positions := self characterPositions.
	positions last <= maxLength ifTrue: [ ^ self ].
	
	aString := self text.

	index := positions size.
	lastPart := index.
	[ (index > 1) 
		and: [((positions at: index) > maxLength) ] 
	] whileTrue: [ 
		[ 
			(index > 1) and: [ (self isSeparator: (aString at: index-1)) not ] 
		] whileTrue: [ 
				index := index - 1. 
			].
		(index > 1) ifTrue: [
			 (self isSeparator: (aString at: index-1)) ifTrue: [ lastPart := index ].
			 index := index - 1 ]. 
	].

	newLength := lastPart - 1.
	
	newText := self text first: (newLength).
	aLabelOrNil ifNotNil: [ 
		aLabelOrNil horizontalAlignment = #right ifTrue: [ 		
			newText := newText trimRight. ].
		aLabelOrNil horizontalAlignment = #center ifTrue: [ 		
			newText := newText trimBoth. ] ].
	
	^ self copy 
		text: newText;
		fullSize: newText size;
		resetCharacterPositions;
		yourself
		
]

{ #category : #accessing }
DrsLabelCharacterChunk >> text [

	^ text
]

{ #category : #accessing }
DrsLabelCharacterChunk >> text: anObject [

	text := anObject.
	length := anObject size.
	fullSize := anObject size.
]

{ #category : #accessing }
DrsLabelCharacterChunk >> trimmedText [

	^ text trimBoth
]

{ #category : #accessing }
DrsLabelCharacterChunk >> width [

	^ self characterPositions
		  ifEmpty: [ 0 ]
		  ifNotEmpty: [ :positions | positions last ]
]
