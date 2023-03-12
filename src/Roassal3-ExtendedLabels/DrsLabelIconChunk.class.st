Class {
	#name : #DrsLabelIconChunk,
	#superclass : #DrsLabelChunk,
	#instVars : [
		'icon',
		'iconExtent',
		'descent',
		'paddingLeft',
		'paddingRight'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsLabelIconChunk >> characterPositions [ 

	^ { 0. self width }
]

{ #category : #accessing }
DrsLabelIconChunk >> createShape [

	self isShrinked ifTrue: [ 
		icon := RSBitmap new form: ((Form extent: 8@16 depth: 32) fillColor: (Color gray alpha: 0.1))  ].

	icon propertyAt: #lineIndex put: self lineIndex. 
	icon propertyAt: #paddingOffset put: self paddingOffset.

	^ icon
]

{ #category : #accessing }
DrsLabelIconChunk >> displayedString [

	^ '☐'
]

{ #category : #accessing }
DrsLabelIconChunk >> fontName: aString size: aNumber color: aColor [

	| font |
	
	font := LogicalFont familyName: aString pointSize: aNumber.
	descent := font descent.
]

{ #category : #accessing }
DrsLabelIconChunk >> fullSize [ 

	^ 1
]

{ #category : #accessing }
DrsLabelIconChunk >> height [

	^ iconExtent y + descent
]

{ #category : #accessing }
DrsLabelIconChunk >> icon [

	^ icon
]

{ #category : #accessing }
DrsLabelIconChunk >> icon: anObject [

	icon := anObject.
	
	iconExtent := icon extent.
	baseline := iconExtent y.
	length := 1.
]

{ #category : #accessing }
DrsLabelIconChunk >> initialize [ 

	super initialize.
	descent := 0.
	paddingLeft := paddingRight := 0.
]

{ #category : #accessing }
DrsLabelIconChunk >> isShrinked [ 

	^ self length <= 0
]

{ #category : #accessing }
DrsLabelIconChunk >> length [

	^ length
]

{ #category : #accessing }
DrsLabelIconChunk >> length: anObject [

	length := anObject
]

{ #category : #accessing }
DrsLabelIconChunk >> padding [ 

	^ paddingLeft@0
]

{ #category : #accessing }
DrsLabelIconChunk >> paddingLeft [

	^ paddingLeft
]

{ #category : #accessing }
DrsLabelIconChunk >> paddingLeft: anObject [

	paddingLeft := anObject
]

{ #category : #accessing }
DrsLabelIconChunk >> paddingOffset [

	^ paddingLeft@0
]

{ #category : #accessing }
DrsLabelIconChunk >> paddingRight [

	^ paddingRight
]

{ #category : #accessing }
DrsLabelIconChunk >> paddingRight: anObject [

	^ paddingRight := anObject
]

{ #category : #accessing }
DrsLabelIconChunk >> subChunkOfMaxLength: maxLength for: labelOrNil [

	^ self
]

{ #category : #accessing }
DrsLabelIconChunk >> width [

	^ iconExtent x + paddingLeft + paddingRight
]
