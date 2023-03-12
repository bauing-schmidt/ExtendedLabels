"
Describes position, extent and other location properties of a shape 
```text

<----------outer extent (width)--------------------------->
origin            spacingOrigin     
X─────────────────X───────────────────────────────────────┐
                  │             applied spacing           │
                  │   ┌────────────────────────────────┐  │
                  │   │            margin              │  │
  topLeftCornerPosition X────────────────────────────┐ │  │
                  │   │ │<-innerExtent(innerWidth)-->│ │  │
                  │   │ │  ┌─────────────────────┐   │ │  │
<--indentation--->│   │ │  │xxxxxxxxxxxxxxxxxxxxx│   │ │  │
                  │   │ │  │xxxxxxxxxxxxxxxxxxxxx│   │ │  │
                  │   │ │  └─────────────────────┘   │ │  │
                  │   │ │          padding           │ │  │
                  │   │ └────────────────────────────┘ │  │
                  │   │            margin              │  │
                  │   └────────────────────────────────┘  │
                  │            applied spacing            │
                  └───────────────────────────────────────┘



┌───────────────────┐      │      ┌───────────────────┐
│                   │--spacing 1->│                   │
│ bounds 1          │      │      │ bounds 2          │
│                   │<-spacing 2--│                   │
└───────────────────┘      │      └───────────────────┘
   applied spacing 1 <---->│<----> applied spacing 2


```
## Instance variables
### Positions
- origin
  - top left corner position including applied spacing
- transitoryOrigin
  - used for temporary shape position during dragging

### Extents
- innerExtent
  - used shape drawn extent
- naturalInnerExtent
  - optimal extent for a given shape
- minExtent
  - minimal inner extent
- maxExtent
  - maximal inner extent
- innerExtentResolved
  - does the inner extent has final resolved value?

### Margins
- marginLeft
- marginRight
- marginTop
- marginBottom

### Padding
- paddingLeft
- paddingRight
- paddingTop
- paddingBottom

### Spacing

- spacingLeft
- spacingRight
- spacingTop
- spacingBottom
- appliedSpacingLeft
- appliedSpacingRight
- appliedSpacingTop
- appliedSpacingBottom

### Indentation

- indentation

### Table cell identification, nesting
- tableId
- rowId
- columnId
- nestingLevel

### Prediction
- extentPrediction
- predictedInnerExtent

### Other
- groupBounds
  - owning group bounds

"
Class {
	#name : #DrsBounds,
	#superclass : #Object,
	#instVars : [
		'origin',
		'transitoryOrigin',
		'innerExtent',
		'naturalInnerExtent',
		'baseline',
		'marginLeft',
		'marginRight',
		'marginTop',
		'marginBottom',
		'paddingLeft',
		'paddingRight',
		'paddingTop',
		'paddingBottom',
		'minExtent',
		'tableId',
		'rowId',
		'columnId',
		'nestingLevel',
		'groupBounds',
		'maxExtent',
		'extentPrediction',
		'innerExtentResolved',
		'predictedInnerExtent',
		'spacingLeft',
		'spacingRight',
		'spacingTop',
		'spacingBottom',
		'appliedSpacingLeft',
		'appliedSpacingRight',
		'appliedSpacingTop',
		'appliedSpacingBottom',
		'indentation'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #requirements }
DrsBounds class >> empty [ 

	^ self new 
		yourself
]

{ #category : #comparing }
DrsBounds >> = otherBounds [ 

	self class == otherBounds class ifFalse: [ ^ false ].

	origin = otherBounds origin ifFalse: [ ^ false ].
	innerExtent = otherBounds innerExtent ifFalse: [ ^ false ].
	baseline = otherBounds baseline ifFalse: [ ^ false ].

	marginLeft = otherBounds marginLeft ifFalse: [ ^ false ].
	marginRight = otherBounds marginRight ifFalse: [ ^ false ].
	marginTop = otherBounds marginTop ifFalse: [ ^ false ].
	marginBottom = otherBounds marginBottom ifFalse: [ ^ false ].

	paddingLeft = otherBounds paddingLeft ifFalse: [ ^ false ].
	paddingRight = otherBounds paddingRight ifFalse: [ ^ false ].
	paddingTop = otherBounds paddingTop ifFalse: [ ^ false ].
	paddingBottom = otherBounds paddingBottom ifFalse: [ ^ false ].

	indentation = otherBounds indentation ifFalse: [ ^ false ].
	
	^ true		
]

{ #category : #'API - spacing' }
DrsBounds >> appliedHorizontalSpacing [

	^ self appliedSpacingLeft + self appliedSpacingRight 
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingBottom [

	<ignoreForCoverage>

	^ appliedSpacingBottom ifNil: [ 0 ]
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingBottom: anObject [

	<ignoreForCoverage>

	appliedSpacingBottom := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingLeft [

	<ignoreForCoverage>

	^ appliedSpacingLeft ifNil: [ 0 ]
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingLeft: anObject [

	<ignoreForCoverage>

	appliedSpacingLeft := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingRight [

	<ignoreForCoverage>

	^ appliedSpacingRight ifNil: [ 0 ]
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingRight: anObject [

	<ignoreForCoverage>

	appliedSpacingRight := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingTop [

	<ignoreForCoverage>

	^ appliedSpacingTop ifNil: [ 0 ]
]

{ #category : #'API - spacing' }
DrsBounds >> appliedSpacingTop: anObject [

	<ignoreForCoverage>

	appliedSpacingTop := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> appliedVerticalSpacing [

	^ self appliedSpacingTop + self appliedSpacingBottom
]

{ #category : #'target resize' }
DrsBounds >> apply: otherBounds [

	self innerExtent: otherBounds innerExtent.
	self origin: otherBounds origin.
	self baseline: otherBounds baseline.
	
	self appliedSpacingLeft: otherBounds appliedSpacingLeft.
	self appliedSpacingRight: otherBounds appliedSpacingRight.
	self appliedSpacingTop: otherBounds appliedSpacingTop.
	self appliedSpacingBottom: otherBounds appliedSpacingBottom.

	self spacingLeft: otherBounds appliedSpacingLeft.
	self spacingRight: otherBounds appliedSpacingRight.
	self spacingTop: otherBounds appliedSpacingTop.
	self spacingBottom: otherBounds appliedSpacingBottom.

	self marginLeft: otherBounds marginLeft.
	self marginRight: otherBounds marginRight.
	self marginTop: otherBounds marginTop.
	self marginBottom: otherBounds marginBottom.
	
]

{ #category : #'API - position and extent' }
DrsBounds >> asRectangle [ 

	^ self origin extent: self fullExtent
]

{ #category : #'API - baseline' }
DrsBounds >> baseline [

	<ignoreForCoverage>

	^ baseline
]

{ #category : #'API - baseline' }
DrsBounds >> baseline: anObject [

	<ignoreForCoverage>

	baseline := anObject
]

{ #category : #accessing }
DrsBounds >> columnId [

	<ignoreForCoverage>

	^ columnId
]

{ #category : #accessing }
DrsBounds >> columnId: anObject [

	<ignoreForCoverage>

	columnId := anObject
]

{ #category : #comparing }
DrsBounds >> containsPoint: aPosition [ 

	^ (Rectangle origin: self topLeftCornerPosition extent: self innerExtent) containsPoint: aPosition
]

{ #category : #'API - position and extent' }
DrsBounds >> ensureInfiniteMaxExtent [ 

	maxExtent ifNil: [ maxExtent := DrsExtentPrediction maximalDimension @  DrsExtentPrediction maximalDimension  ].

]

{ #category : #'API - predictions' }
DrsBounds >> extentPrediction [

	<ignoreForCoverage>

	^ extentPrediction
]

{ #category : #'API - predictions' }
DrsBounds >> extentPrediction: aPrediction [ 

	extentPrediction := aPrediction
]

{ #category : #'API - predictions' }
DrsBounds >> forceResolvedExtentPrediction [

	| aMinExtent |
	aMinExtent := self minInnerWidth @ self minInnerHeight.

	extentPrediction optimalExtentResolved ifFalse: [ 
		extentPrediction optimalExtent:
			(self width @ self height max: aMinExtent) ].

	extentPrediction maximalExtentResolved ifFalse: [ 
		extentPrediction maximalExtent: (self maxInnerWidthOrNil ifNil: [ 
				 DrsExtentPrediction maximalDimension ])
			@ (self maxInnerHeightOrNil ifNil: [ 
					 DrsExtentPrediction maximalDimension ]) ].

	extentPrediction minimalExtentResolved ifFalse: [ 
		extentPrediction minimalExtent: aMinExtent ].

	extentPrediction
		rowId: self rowId;
		columnId: self columnId.

	^ extentPrediction
]

{ #category : #'API - position and extent' }
DrsBounds >> fullExtent [ 

	^ self width @ self height
]

{ #category : #'API - position and extent' }
DrsBounds >> fullExtentWithSpacing [

	"WARNING: does not take indentation into account"

	^ (self widthWithoutSpacing + self appliedHorizontalSpacing) @ (self heightWithoutSpacing + self appliedVerticalSpacing)

]

{ #category : #'API - position and extent' }
DrsBounds >> fullExtentWithoutSpacing [

	^ self widthWithoutSpacing @ self heightWithoutSpacing
]

{ #category : #accessing }
DrsBounds >> groupBounds [

	<ignoreForCoverage>

	^ groupBounds
]

{ #category : #accessing }
DrsBounds >> groupBounds: anObject [

	<ignoreForCoverage>

	groupBounds := anObject
]

{ #category : #accessing }
DrsBounds >> groupBoundsOrSelf [

	^ self groupBounds ifNil: [ self ]
]

{ #category : #'API - margins' }
DrsBounds >> hasEmptyMargins [

	marginLeft ~= 0 ifTrue: [ ^ false ].
	marginRight ~= 0 ifTrue: [ ^ false ].
	marginTop ~= 0 ifTrue: [ ^ false ].
	marginBottom ~= 0 ifTrue: [ ^ false ].
	
	^ true
]

{ #category : #comparing }
DrsBounds >> hash [ 

	^ ((((((((((((origin hash bitXor: origin hash) 
		bitXor: innerExtent hash)
		bitXor: baseline hash)
		bitXor: marginLeft hash)
		bitXor: marginRight hash)
		bitXor: marginTop hash)
		bitXor: marginBottom hash)
		bitXor: paddingLeft hash)
		bitXor: paddingRight hash)
		bitXor: paddingTop hash)
		bitXor: paddingBottom hash)
		bitXor: indentation hash)

]

{ #category : #'API - position and extent' }
DrsBounds >> height [

	^ self heightWithoutSpacing + self appliedVerticalSpacing
]

{ #category : #'API - position and extent' }
DrsBounds >> heightWithoutSpacing [ 

	^ self verticalMargin + self verticalPadding + self innerExtent y 
]

{ #category : #'API - margins' }
DrsBounds >> horizontalMargin [ 

	^ self marginLeft + self marginRight 
]

{ #category : #'API - margins' }
DrsBounds >> horizontalPadding [

	^ self paddingLeft + self paddingRight 
]

{ #category : #'API - spacing' }
DrsBounds >> horizontalSpacing [

	^ self spacingLeft + self spacingRight 
]

{ #category : #'API  - indentation' }
DrsBounds >> indentation [

	^ indentation
]

{ #category : #'API  - indentation' }
DrsBounds >> indentation: anObject [

	indentation := anObject
]

{ #category : #initialization }
DrsBounds >> initialize [ 

	super initialize.
	
	origin := 0@0.
	innerExtent := 0@0.
	naturalInnerExtent := 0@0.
	self setEmptyMargin.
	self setEmptyPadding.
	self setEmptySpacing.
	baseline := 0.
	minExtent := 0@0.
	maxExtent := nil.
	transitoryOrigin := nil.
	indentation := 0.
	
	extentPrediction := DrsExtentPrediction new.
	innerExtentResolved := false.	
	
]

{ #category : #'API - position and extent' }
DrsBounds >> innerExtent [

	innerExtentResolved ifFalse: [ ^ self predictedInnerExtent ].

	^ innerExtent
]

{ #category : #'API - position and extent' }
DrsBounds >> innerExtent: anObject [

	innerExtent := anObject.
	self makeInnerExtentResolved
]

{ #category : #'API - position and extent' }
DrsBounds >> innerExtentResolved [ 

	<ignoreForCoverage>

	^ innerExtentResolved
]

{ #category : #'API - position and extent' }
DrsBounds >> isZero [

	"for usage in tests only"
	
	<ignoreForCoverage>

	^ origin = (0@0) and: [ innerExtent = (0@0) ]
]

{ #category : #'API - predictions' }
DrsBounds >> limitMaximalExtentPredictionFromParentBy: anExtent [ 

	" When compute minimal extents predictions, we can do it from bottom up so it is fully clear what the minimal extent is for every shape.
	However, for the maximal extent, even the top most element can try to limit it and this information then needs to be propagated to its 
	children during the descent phase."
	
	self extentPrediction maximalExtent: ((self extentPrediction maximalExtent min: anExtent) max: (self extentPrediction minimalExtent)).
]

{ #category : #'API - position and extent' }
DrsBounds >> limitedWidth [

	^ self width min:
		  (self maxInnerWidthOrNil ifNil:
			   DrsExtentPrediction maximalDimension)
]

{ #category : #'API - position and extent' }
DrsBounds >> limitedWidthWithoutAdjustment [ 

	^ self limitedWidth - self extentPrediction optimalExtentAdjustment x 
]

{ #category : #'API - position and extent' }
DrsBounds >> makeInnerExtentResolved [ 

	innerExtentResolved := true
]

{ #category : #'API - margins' }
DrsBounds >> marginBottom [

 	<ignoreForCoverage>

	^ marginBottom
]

{ #category : #accessing }
DrsBounds >> marginBottom: anObject [

	marginBottom := anObject
]

{ #category : #accessing }
DrsBounds >> marginLeft [

	<ignoreForCoverage>

	^ marginLeft
]

{ #category : #'API - margins' }
DrsBounds >> marginLeft: anObject [

	<ignoreForCoverage>

	marginLeft := anObject
]

{ #category : #accessing }
DrsBounds >> marginRight [

	<ignoreForCoverage>

	^ marginRight
]

{ #category : #accessing }
DrsBounds >> marginRight: anObject [

	marginRight := anObject
]

{ #category : #'API - margins' }
DrsBounds >> marginTop [

 	<ignoreForCoverage>

	^ marginTop
]

{ #category : #'API - margins' }
DrsBounds >> marginTop: anObject [

	<ignoreForCoverage>

	marginTop := anObject
]

{ #category : #accessing }
DrsBounds >> maxExtent: anObject [

	<ignoreForCoverage>

	maxExtent := anObject
]

{ #category : #'API - position and extent' }
DrsBounds >> maxHeight: aNumber [

	self ensureInfiniteMaxExtent.
	^ maxExtent y: aNumber
	
]

{ #category : #accessing }
DrsBounds >> maxInnerExtent [

	^ (self privMaxExtent ifNil: [ DrsExtentPrediction maximalDimension @  DrsExtentPrediction maximalDimension])
]

{ #category : #'API - position and extent' }
DrsBounds >> maxInnerHeightOrNil [

	^ maxExtent ifNil: [ nil ] ifNotNil: [ :extent | extent y ]
	
]

{ #category : #'API - position and extent' }
DrsBounds >> maxInnerWidthOrNil [

	^ maxExtent ifNil: [ nil ] ifNotNil: [ :extent | extent x ]
	
]

{ #category : #'API - position and extent' }
DrsBounds >> maxWidth: aNumber [

	self ensureInfiniteMaxExtent.
	^ maxExtent x: aNumber
	
]

{ #category : #'API - spacing' }
DrsBounds >> mergeAndApplySpacingBottom: aNumber if: aBlock [ 

	spacingBottom := aBlock value ifTrue: [ spacingBottom max: aNumber ] ifFalse: [ spacingBottom ].
	appliedSpacingBottom := spacingBottom half.
	
]

{ #category : #'API - spacing' }
DrsBounds >> mergeAndApplySpacingLeft: aNumber if: aBlock [ 

	spacingLeft := aBlock value ifTrue: [ spacingLeft max: aNumber ] ifFalse: [ spacingLeft ].
	appliedSpacingLeft := spacingLeft half.
	
]

{ #category : #'API - spacing' }
DrsBounds >> mergeAndApplySpacingRight: aNumber if: aBlock [ 

	spacingRight := aBlock value ifTrue: [ spacingRight max: aNumber ] ifFalse: [ spacingRight ].
	appliedSpacingRight := spacingRight half.
	
]

{ #category : #'API - spacing' }
DrsBounds >> mergeAndApplySpacingTop: aNumber if: aBlock [ 

	spacingTop := aBlock value ifTrue: [ spacingTop max: aNumber ] ifFalse: [ spacingTop ].
	appliedSpacingTop := spacingTop half.
	
]

{ #category : #accessing }
DrsBounds >> minExtent: anObject [

	<ignoreForCoverage>

	minExtent := anObject
]

{ #category : #'API - position and extent' }
DrsBounds >> minHeight: aNumber [

	^ minExtent y: aNumber
	
]

{ #category : #'API - limits' }
DrsBounds >> minInnerExtent [ 

	<ignoreForCoverage>
	
	^ minExtent 
]

{ #category : #'API - position and extent' }
DrsBounds >> minInnerHeight [

	^ minExtent y
	
]

{ #category : #'API - position and extent' }
DrsBounds >> minInnerWidth [

	^ minExtent x
	
]

{ #category : #accessing }
DrsBounds >> minOverallHeight [

	"includes vertical margin and spacing"

	^ self minInnerHeight + self verticalMargin
	  + self appliedVerticalSpacing
]

{ #category : #accessing }
DrsBounds >> minOverallWidth [

	"includes horizontal margin and spacing"

	^ self minInnerWidth + self horizontalMargin
	  + self appliedHorizontalSpacing
]

{ #category : #'API - position and extent' }
DrsBounds >> minWidth: aNumber [

	^ minExtent x: aNumber
	
]

{ #category : #accessing }
DrsBounds >> naturalInnerExtent [

	<ignoreForCoverage>

	^ naturalInnerExtent
]

{ #category : #accessing }
DrsBounds >> naturalInnerExtent: anObject [

	naturalInnerExtent := anObject.
	innerExtent := anObject.
	^ anObject
]

{ #category : #accessing }
DrsBounds >> nestingLevel [

	<ignoreForCoverage>

	^ nestingLevel
]

{ #category : #accessing }
DrsBounds >> nestingLevel: anObject [

	<ignoreForCoverage>

	nestingLevel := anObject
]

{ #category : #'API - position and extent' }
DrsBounds >> origin [

	<ignoreForCoverage>

	^ origin
]

{ #category : #'API - position and extent' }
DrsBounds >> origin: anObject [

	<ignoreForCoverage>
	
	origin := anObject.

]

{ #category : #'API - position and extent' }
DrsBounds >> outerExtent [ 

	^ self width@self height
]

{ #category : #'API - position and extent' }
DrsBounds >> ownBounds [ 

	<ignoreForCoverage>

	^ self
]

{ #category : #accessing }
DrsBounds >> paddingBottom [

	<ignoreForCoverage>

	^ paddingBottom
]

{ #category : #accessing }
DrsBounds >> paddingBottom: anObject [

	<ignoreForCoverage>

	paddingBottom := anObject
]

{ #category : #accessing }
DrsBounds >> paddingLeft [

	<ignoreForCoverage>

	^ paddingLeft
]

{ #category : #accessing }
DrsBounds >> paddingLeft: anObject [

	<ignoreForCoverage>

	paddingLeft := anObject
]

{ #category : #accessing }
DrsBounds >> paddingRight [

	<ignoreForCoverage>

	^ paddingRight
]

{ #category : #accessing }
DrsBounds >> paddingRight: anObject [

	<ignoreForCoverage>

	paddingRight := anObject
]

{ #category : #accessing }
DrsBounds >> paddingTop [

	<ignoreForCoverage>

	^ paddingTop
]

{ #category : #accessing }
DrsBounds >> paddingTop: anObject [

	<ignoreForCoverage>

	paddingTop := anObject
]

{ #category : #'API - position and extent' }
DrsBounds >> predictedInnerExtent [

	"predictedInnerExtent is a cached value, to reset it, use `resetPredictedInnerExtent`"

	^ predictedInnerExtent ifNil: [ 
		predictedInnerExtent := self privPredictedInnerExtent ].

]

{ #category : #printing }
DrsBounds >> printOn: aStream [ 

	aStream << self className << '('.
	self origin printOn: aStream.
	aStream << ', '.
	predictedInnerExtent printOn: aStream.
	self innerExtentResolved ifFalse: [ 
		aStream << ' [unresolved extent]'. ].
	aStream << ')'.
	
	
]

{ #category : #accessing }
DrsBounds >> privMaxExtent [

	<ignoreForCoverage>
	^ maxExtent
]

{ #category : #'API - position and extent' }
DrsBounds >> privPredictedInnerExtent [

	extentPrediction optimalExtentResolved ifFalse: [ 
		^ (innerExtent min: self maxInnerExtent)
		  + self extentPrediction optimalExtentAdjustment ].

	^ (extentPrediction optimalExtent min:
		   extentPrediction optimalExtentLimited)
	  + extentPrediction optimalExtentAdjustment min: self maxInnerExtent
]

{ #category : #'API - position and extent' }
DrsBounds >> relativeTopLeftCornerPosition [

	"returns a relative position where the actual shape should be painted"

	^ (self indentation@0) + (marginLeft@marginTop) + self topLeftAppliedSpacing
]

{ #category : #'API - position and extent' }
DrsBounds >> resetPredictedInnerExtent [

	predictedInnerExtent := nil
]

{ #category : #'API - transitory origin' }
DrsBounds >> resetTransitoryOrigin [

	transitoryOrigin := nil
]

{ #category : #'API - predictions' }
DrsBounds >> resolveExtentPrediction [

	extentPrediction optimalExtentResolved ifFalse: [ 
		self forceResolvedExtentPrediction ].
	
	^ extentPrediction
]

{ #category : #accessing }
DrsBounds >> rowId [

	<ignoreForCoverage>

	^ rowId
]

{ #category : #accessing }
DrsBounds >> rowId: anObject [

	<ignoreForCoverage>

	rowId := anObject
]

{ #category : #'API - margins' }
DrsBounds >> setEmptyMargin [ 

	<ignoreForCoverage>

	marginLeft := 0.
	marginRight := 0.
	marginTop := 0.
	marginBottom := 0.
]

{ #category : #'API - margins' }
DrsBounds >> setEmptyPadding [ 

	<ignoreForCoverage>

	paddingLeft := 0.
	paddingRight := 0.
	paddingTop := 0.
	paddingBottom := 0.
]

{ #category : #'API - margins' }
DrsBounds >> setEmptySpacing [

	<ignoreForCoverage>

	spacingLeft := 0.
	spacingRight := 0.
	spacingTop := 0.
	spacingBottom := 0.
	
	appliedSpacingLeft := 0.
	appliedSpacingRight := 0.
	appliedSpacingTop := 0.
	appliedSpacingBottom := 0.
]

{ #category : #'API - position and extent' }
DrsBounds >> shiftIfUnder: aPoint by: shiftPoint [

	self origin y >= aPoint y ifTrue: [ 
		origin := origin + shiftPoint.
		^ true ].
	
	^ false
]

{ #category : #accessing }
DrsBounds >> spacingBottom [

	<ignoreForCoverage>

	^ spacingBottom
]

{ #category : #'API - spacing' }
DrsBounds >> spacingBottom: anObject [

	<ignoreForCoverage>

	spacingBottom := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> spacingLeft [

	<ignoreForCoverage>

	^ spacingLeft
]

{ #category : #'API - spacing' }
DrsBounds >> spacingLeft: anObject [

	<ignoreForCoverage>

	spacingLeft := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> spacingOrigin [ 

	^ self origin + (indentation@0)
]

{ #category : #'API - spacing' }
DrsBounds >> spacingRight [

	<ignoreForCoverage>

	^ spacingRight
]

{ #category : #'API - spacing' }
DrsBounds >> spacingRight: anObject [

	<ignoreForCoverage>

	spacingRight := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> spacingTop [

	<ignoreForCoverage>

	^ spacingTop
]

{ #category : #'API - spacing' }
DrsBounds >> spacingTop: anObject [

	<ignoreForCoverage>

	spacingTop := anObject
]

{ #category : #accessing }
DrsBounds >> tableId [

	<ignoreForCoverage>

	^ tableId
]

{ #category : #accessing }
DrsBounds >> tableId: anObject [

	<ignoreForCoverage>

	tableId := anObject
]

{ #category : #'API - spacing' }
DrsBounds >> topLeftAppliedSpacing [

	^ appliedSpacingLeft @ appliedSpacingTop 
]

{ #category : #'API - position and extent' }
DrsBounds >> topLeftCornerPosition [

	"returns a relative position where the actual shape should be painted"

	^ self origin + self relativeTopLeftCornerPosition
]

{ #category : #'API - transitory origin' }
DrsBounds >> transitoryOrRealOrigin [

	"transitory origin is a bounds origin used for drawing but not for arranging. Used for thing like shapes dragging"

	^ transitoryOrigin ifNil: [ origin ]
]

{ #category : #'API - transitory origin' }
DrsBounds >> transitoryOrigin [ 

	<ignoreForCoverage>

	^ transitoryOrigin
]

{ #category : #'API - transitory origin' }
DrsBounds >> transitoryOrigin: aPoint [ 

	<ignoreForCoverage>

	transitoryOrigin := aPoint
]

{ #category : #'API - position and extent' }
DrsBounds >> translateBy: aPoint [

	self origin: origin + aPoint.

]

{ #category : #'API - position and extent' }
DrsBounds >> unresolveInnerExtent [ 

	innerExtentResolved := false.
]

{ #category : #'API - margins' }
DrsBounds >> verticalMargin [ 

	^ self marginTop + self marginBottom
]

{ #category : #'API - margins' }
DrsBounds >> verticalPadding [

	^ self paddingTop + self paddingBottom
]

{ #category : #'API - spacing' }
DrsBounds >> verticalSpacing [

	^ self spacingTop + self spacingBottom
]

{ #category : #'API - position and extent' }
DrsBounds >> width [ 

	^ self indentation + self widthWithoutSpacing + self appliedHorizontalSpacing
]

{ #category : #'API - position and extent' }
DrsBounds >> widthWithoutSpacing [ 

	^ self horizontalMargin + self horizontalPadding + self innerExtent x 	
]

{ #category : #accessing }
DrsBounds >> workingCopy [

	<ignoreForCoverage>

	^ self
]
