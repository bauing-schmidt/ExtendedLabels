Class {
	#name : #DrsFontMetricsProvider,
	#superclass : #RSCairoCachedMetricsProvider,
	#instVars : [
		'ellipsisWidthPerFont'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> characterPositionsFor: aString font: aFont [ 

	| map position resultArray |

	map := self mapFor: aFont.
	resultArray := Array ofSize: aString size+1.
	position := 0.

	aString withIndexDo: [ :char :index |
		| charWidth |
		charWidth := (self widthOf: char map: map font: aFont) asFloat.
		resultArray at: index put: position.
		position := position + charWidth ].
	resultArray at: aString size + 1 put: position.
	
	^ resultArray
]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> characterWidthsOf: aString font: aFont [ 

	| map |

	map := self mapFor: aFont.

	^ aString 
		collect: [ :char |
			(self widthOf: char map: map font: aFont) asFloat ]
		as: Array.

]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> ellipsis [ 

	^  '…'
]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> ellipsisSizeOf: aFont [ 

	^ ellipsisWidthPerFont at: aFont ifAbsentPut: [ 
		self extentsOf: self ellipsis font: aFont ]
]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> ellipsisWidthOf: aFont [ 

	^ ellipsisWidthPerFont at: aFont ifAbsentPut: [ 
		(self extentsOf: self ellipsis font: aFont) width ]
]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> extentsOf: aRSLabel [
	| map font h w |
	font := aRSLabel font.
	map := self mapFor: font.

	w := (aRSLabel text 
		collect: [ :char | self widthOf: char map: map font: font ] 
		as: Array ) sum asFloat.
		
	h := font getPreciseHeight asFloat.
	
	^ RSTextExtents new
		width: w;
		height: h;
		x_advance: 0;
		y_advance: 0;
		x_bearing: 0.5;
		y_bearing: font getPreciseAscent negated;
		yourself.

]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> extentsOf: aText font: aFont [
	| map h w |

	map := self mapFor: aFont.

	w := (aText 
		collect: [ :char | self widthOf: char map: map font: aFont ] 
		as: Array ) sumNumbers asFloat.
		
	h := aFont getPreciseHeight asFloat.
	
	^ RSTextExtents new
		width: w;
		height: h;
		x_advance: 0;
		y_advance: 0;
		x_bearing: 0.5;
		y_bearing: aFont getPreciseAscent negated;
		yourself.

]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> initialize [ 

	super initialize.
	ellipsisWidthPerFont := IdentityDictionary new.
]

{ #category : #'as yet unclassified' }
DrsFontMetricsProvider >> mapFor: aFont [ 

	^ cache 
		at: aFont 
		ifAbsentPut: [ self dictionaryFor: aFont ].
]
