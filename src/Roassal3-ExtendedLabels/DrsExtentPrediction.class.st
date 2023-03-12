Class {
	#name : #DrsExtentPrediction,
	#superclass : #Object,
	#instVars : [
		'optimalExtent',
		'minimalExtent',
		'maximalExtent',
		'unlimitedMaxX',
		'unlimitedMaxY',
		'rowId',
		'columnId',
		'cumulativeLeftMargin',
		'optimalExtentAdjustment',
		'limitMode'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #'as yet unclassified' }
DrsExtentPrediction class >> maxExtent: aPointOrNil [ 

	"for testing purposes"

	| result |
	
	result := self new.
	aPointOrNil ifNotNil: [ result maximalExtent: aPointOrNil ].
	^ result

]

{ #category : #'as yet unclassified' }
DrsExtentPrediction class >> maximalDimension [

	^ SmallInteger maxVal
]

{ #category : #accessing }
DrsExtentPrediction >> columnId [

	<ignoreForCoverage>

	^ columnId
]

{ #category : #accessing }
DrsExtentPrediction >> columnId: anObject [

	<ignoreForCoverage>

	columnId := anObject
]

{ #category : #accessing }
DrsExtentPrediction >> cumulativeLeftMargin [

	<ignoreForCoverage>
	
	^ cumulativeLeftMargin
]

{ #category : #accessing }
DrsExtentPrediction >> cumulativeLeftMargin: anObject [

	<ignoreForCoverage>

	cumulativeLeftMargin := anObject
]

{ #category : #accessing }
DrsExtentPrediction >> hasUnlimitedMaximalExtent [ 

	^ self maximalExtent x = self class maximalDimension and: [ self maximalExtent y = self class maximalDimension  ]
]

{ #category : #initialization }
DrsExtentPrediction >> initialize [ 

	super initialize.
	
	optimalExtent := nil.
	minimalExtent := nil.
	maximalExtent := nil.
	unlimitedMaxX := true.
	unlimitedMaxY := true.
	
	cumulativeLeftMargin := 0.
	
	optimalExtentAdjustment := 0@0.
	
	limitMode := #innerExtent.
	
	
]

{ #category : #accessing }
DrsExtentPrediction >> limitByExtentPrediction [

	limitMode := #extentPrediction.
]

{ #category : #accessing }
DrsExtentPrediction >> limitMode [

	^ limitMode
]

{ #category : #accessing }
DrsExtentPrediction >> limitPrediction: otherPrediction bounds: theBounds [

	"in some cases like changing of an expanding status of a folder, we cannot limit the new bounds at the same
	position by the known inner extent because it is too small or zero."

	limitMode = #innerExtent
		ifTrue: [ 
			otherPrediction maximalExtent: theBounds innerExtent x@otherPrediction maximalExtent y ].

	limitMode = #extentPrediction
		ifTrue: [ 
			otherPrediction maximalExtent: self maximalExtent ].
		 
]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtent [

	"we do not need to test if maximalExtent is nil because there is no way how to set limitedMaxX/Y 
	and still have empty maximal extent"

	^ (unlimitedMaxX ifFalse: [ maximalExtent x ] ifTrue: [ self class maximalDimension ]) 
			@ 
	  (unlimitedMaxY ifFalse: [ maximalExtent y ] ifTrue: [ self class maximalDimension ]).	

]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtent: anObject [

"anObject y = 21 ifTrue: [ self halt. ].
"

	maximalExtent := anObject min: (maximalExtent ifNil: [self class maximalDimension @ self class maximalDimension ]) .
	
	unlimitedMaxX := (anObject x >= self class maximalDimension).
		
	unlimitedMaxY := (anObject y >= self class maximalDimension)
]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtentOrNil [

	(unlimitedMaxX and: [ unlimitedMaxY ]) ifTrue: [ ^ nil ].

	^ self maximalExtent
]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtentResolved [

	^ maximalExtent notNil
]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtentXForAddition [ 

	"if the maximal extent is unresolved, we should ignore it. We need to detect if the value is reasonably set "

	unlimitedMaxX ifTrue: [ ^ 0 ].
	^ maximalExtent x
]

{ #category : #accessing }
DrsExtentPrediction >> maximalExtentYForAddition [ 

	"if the maximal extent is unresolved, we should ignore it. We need to detect if the value is reasonably set "

	unlimitedMaxY ifTrue: [ ^ 0 ].
	^ maximalExtent y
]

{ #category : #accessing }
DrsExtentPrediction >> minimalExtent [

	^ minimalExtent ifNil: [ 0@0 ]
]

{ #category : #accessing }
DrsExtentPrediction >> minimalExtent: anObject [

	minimalExtent := anObject max: self minimalExtent
]

{ #category : #accessing }
DrsExtentPrediction >> minimalExtentResolved [

	^ minimalExtent notNil
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtent [

	^ optimalExtent ifNil: [ 0@0 ]
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtent: anObject [

	optimalExtent := anObject max: (optimalExtent ifNil: [ 0@0 ])
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtentAdjustment [

	<ignoreForCoverage>

	^ optimalExtentAdjustment
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtentAdjustment: anObject [

	optimalExtentAdjustment := anObject
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtentLimited [

	"an optimal extent limited by the maximal and minimal extents"

	^ (self optimalExtent min: self maximalExtent) max: self minimalExtent
]

{ #category : #accessing }
DrsExtentPrediction >> optimalExtentResolved [

	^ optimalExtent notNil
]

{ #category : #printing }
DrsExtentPrediction >> printOn: aStream [ 

	aStream << self className << '('.
	self optimalExtent printOn: aStream.
	aStream << ', margin: '.
	self cumulativeLeftMargin printOn: aStream.
	aStream << ', max: '.
	self maximalExtent printOn: aStream.
	aStream << ', adj: '.
	self optimalExtentAdjustment printOn: aStream.
	aStream << ')'.
	
]

{ #category : #initialization }
DrsExtentPrediction >> resolved [ 

	^ (optimalExtent isNil or: [( minimalExtent isNil ) or: [ maximalExtent isNil ]]) not
]

{ #category : #accessing }
DrsExtentPrediction >> rowId [

	<ignoreForCoverage>

	^ rowId
]

{ #category : #accessing }
DrsExtentPrediction >> rowId: anObject [

	<ignoreForCoverage>

	rowId := anObject
]

{ #category : #accessing }
DrsExtentPrediction >> unlimitedMaxX [

	unlimitedMaxX := true
]

{ #category : #accessing }
DrsExtentPrediction >> unlimitedMaxY [

	unlimitedMaxY := true
]
