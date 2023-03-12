Class {
	#name : #DrsShape,
	#superclass : #Object,
	#instVars : [
		'roassalShape',
		'bounds',
		'alignment',
		'shapeDependencies',
		'nestingLevel',
		'minWidth',
		'minHeight',
		'maxWidth',
		'maxHeight',
		'aspect',
		'shrink',
		'colSpan',
		'horizontalLevel',
		'rowId',
		'columnId',
		'tableId',
		'shapeGroup',
		'assignedExtent',
		'shifted',
		'installed'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #'instance creation' }
DrsShape class >> with: anRSShape [ 

	^ self new 
		roassalShape: anRSShape;
		yourself
]

{ #category : #'as yet unclassified' }
DrsShape >> adaptBoundsToChildren [
]

{ #category : #'as yet unclassified' }
DrsShape >> adaptBoundsToChildrenAt: aPoint [

	self bounds makeInnerExtentResolved 
]

{ #category : #API }
DrsShape >> adaptShapeExtents [

	"no change, general shapes do not adapt"
]

{ #category : #actions }
DrsShape >> adaptShapePositions [

	self alignment align: self in: self assignedRectangle.
	
	self isDebugging ifTrue: [
		self addAssignedRectangleVisualization ].
	
]

{ #category : #adding }
DrsShape >> addAllWithHorizontalLevel: aNumber to: aCollection [

	self horizontalLevel = aNumber 
		ifTrue: [ aCollection add: self ]
]

{ #category : #'debugging support' }
DrsShape >> addAssignedRectangleVisualization [

	| r box gradient |
	r := self assignedRectangle.
	box :=  RSBox new
		extent: r extent;
		yourself.
		
	gradient := LinearGradientPaint fromArray:
				{0 -> #lightGray.
				1 -> #darkGray}.
		
	gradient
		start: -50 asPoint;
		stop: 50 asPoint.	
	box color: gradient.
		
	box position: r topLeft + r extent half.
	
	self roassalShape canvas addShape: box.
	box pushBack.

	
]

{ #category : #dependencies }
DrsShape >> addDependency: aDrsDependency [

	| aDependency |
	
	shapeDependencies ifNil: [ 
		shapeDependencies := aDrsDependency.
		^ self ].

	aDependency := shapeDependencies.
	[ aDependency next isNil ] whileFalse: [ aDependency := aDependency next ].

	aDependency next: aDrsDependency
]

{ #category : #accessing }
DrsShape >> addShapeGroupsChainFor: aPoint to: anOrderedCollection [

	(self containsPoint:  aPoint) ifTrue: [ 
		anOrderedCollection add: self.
		self shapes do: [ :each | 
			each addShapeGroupsChainFor: aPoint to: anOrderedCollection ] ]
]

{ #category : #'API - arranging' }
DrsShape >> adjustBoundsToChildren [


]

{ #category : #accessing }
DrsShape >> affectsTable: aTableId [ 

	^ aTableId = tableId
]

{ #category : #accessing }
DrsShape >> alignment [
	^ alignment ifNil: [ DrsAlignment default ]
]

{ #category : #accessing }
DrsShape >> alignment: anObject [
	alignment := anObject
]

{ #category : #enumerating }
DrsShape >> allShapeGroupsAndShapesDo: aBlock [

	^ self shapes do: [ :each | 
		aBlock value: each.
		each allShapeGroupsAndShapesDo: aBlock ]
]

{ #category : #actions }
DrsShape >> applicationItem [ 

	"only the shape groups have an assigned application item "

	^ nil
]

{ #category : #actions }
DrsShape >> applicationItemAt: aPoint [

	"only the shape groups have an assigned application item "

	^ nil
]

{ #category : #actions }
DrsShape >> arrangeAt: aPosition [

	self translatePivotTo: aPosition.
]

{ #category : #accessing }
DrsShape >> aspect [
	^ aspect
]

{ #category : #accessing }
DrsShape >> aspect: anObject [
	aspect := anObject
]

{ #category : #accessing }
DrsShape >> assignedExtent [
	
	^ self bounds innerExtent ifNil: [ 
		self naturalExtent ].

]

{ #category : #actions }
DrsShape >> assignedRectangle [

	^ Rectangle origin: self pivotPosition extent: self assignedExtent
]

{ #category : #accessing }
DrsShape >> baseline [ 
	
	^ nil
]

{ #category : #accessing }
DrsShape >> baseline: aNumber [

	"ignore, valid only for labels"
]

{ #category : #accessing }
DrsShape >> baselineShiftFrom: rowBaseline [ 

	^ self baseline 
			ifNotNil: [ :b | rowBaseline - (self baseline ifNil: [0]) ]
			ifNil: [ 0 ].
]

{ #category : #actions }
DrsShape >> bounds [ 

	^ bounds ifNil: [ 
		bounds := self boundsClass new 
			origin: 0@0;
			naturalInnerExtent: self extentForBounds;
			tableId: tableId;
			rowId: rowId;
			columnId: columnId;
			yourself ]
]

{ #category : #actions }
DrsShape >> boundsClass [

	^ DrsBounds
]

{ #category : #accessing }
DrsShape >> changeAssignedExtent: aPoint updateDependencies: aBoolean [

	aBoolean ifTrue: [ 
		(self dependantsOf: #assignedExtent) do: [ :aDependency |
			self deferredDependencies add: aDependency ] ].

	self bounds innerExtent: aPoint.
]

{ #category : #actions }
DrsShape >> cleanAssignedExtents [

"	bounds innerExtent: nil.
"	self shapes do: [ :each | each cleanAssignedExtents ]
]

{ #category : #'API - rebuilding' }
DrsShape >> cleanPlaceholders [
]

{ #category : #accessing }
DrsShape >> colSpan [

	^ colSpan ifNil: [ colSpan := 1 ]
]

{ #category : #accessing }
DrsShape >> colSpan: anObject [

	colSpan := anObject
]

{ #category : #accessing }
DrsShape >> columnId [

	^ columnId
]

{ #category : #accessing }
DrsShape >> columnId: anObject [

	columnId := anObject
]

{ #category : #actions }
DrsShape >> computeAssignedExtent [

	self bounds innerExtent: self roassalShape naturalExtent.
]

{ #category : #private }
DrsShape >> computeBoundsAt: anOrigin [

	"only for groups"

]

{ #category : #accessing }
DrsShape >> computeCumulativeMarginsStarting: leftMargin [
	
	self bounds extentPrediction cumulativeLeftMargin: leftMargin.
]

{ #category : #'as yet unclassified' }
DrsShape >> computeExtentPredictions [
]

{ #category : #testing }
DrsShape >> containsPoint: aPosition [ 

	^ self ownBounds containsPoint: aPosition
]

{ #category : #accessing }
DrsShape >> cumulativeLeftMargin [

	^ self nestingLevel * 30
]

{ #category : #actions }
DrsShape >> defaultExtent [ 

	^ self naturalExtent
]

{ #category : #accessing }
DrsShape >> deferredDependencies [

	| aShape |
	aShape := self someShapeOrNil.
	^ aShape 
		ifNotNil: [ 
			aShape roassalShape parent ifNil: [ ^OrderedCollection new ].
			aShape roassalShape parent partInterface part canvasPart deferredDependencies ]
		ifNil: [ OrderedCollection new ]
	
]

{ #category : #dependencies }
DrsShape >> dependantsOf: anAspect [

	| result current |
	
	result := OrderedCollection new.
	
	shapeDependencies ifNil: [ ^ result ].
	
	current := shapeDependencies.
	[ 
		current aspect = anAspect ifTrue: [ 
			result add: current ].
		current := current next.
		current notNil
	] whileTrue.

	^ result	
	

]

{ #category : #accessing }
DrsShape >> editable [ 

	^ false
]

{ #category : #accessing }
DrsShape >> editable: aBoolean [

	"ignore for shapes that are not labels"
]

{ #category : #accessing }
DrsShape >> encompassingRectangle [

	^ self pivotPosition extent: self extent
]

{ #category : #'as yet unclassified' }
DrsShape >> ensureAllBounds [

	^ self bounds
]

{ #category : #accessing }
DrsShape >> ensureAssignedExtent [

	self bounds innerExtent
		ifNil: [ self computeAssignedExtent ].
	^ self bounds innerExtent
]

{ #category : #accessing }
DrsShape >> ensureBoundsHierarchy [
	
	bounds := self boundsClass new 
		origin: 0@0;
		naturalInnerExtent: self naturalInnerExtent;
		tableId: tableId;
		rowId: rowId;
		columnId: columnId;
		yourself.	 
			
	self maxWidth ifNotNil: [ :anExtent | 
		bounds maxWidth: anExtent ].
	self maxHeight ifNotNil: [ :anExtent | 
		bounds maxHeight: anExtent ].
		
	self minWidth ifNotNil: [ :anExtent | 
		bounds minWidth: anExtent ].
	self minHeight ifNotNil: [ :anExtent | 
		bounds minHeight: anExtent ].
	
	^ bounds 
]

{ #category : #actions }
DrsShape >> ensureDefaultBounds [

	^ bounds ifNil: [ 
		bounds := self boundsClass new 
			origin: 0@0;
			naturalInnerExtent:  0@0" self defaultExtent";
			tableId: tableId;
			rowId: rowId;
			columnId: columnId;
			yourself ]
]

{ #category : #accessing }
DrsShape >> ensureNaturalExtent [ 

	^ self roassalShape naturalExtent
]

{ #category : #accessing }
DrsShape >> extent [ 

	^ roassalShape extent
]

{ #category : #accessing }
DrsShape >> extent: aPoint [ 

	roassalShape extent: aPoint
]

{ #category : #accessing }
DrsShape >> extentForAlignment [

	^ self extent
]

{ #category : #accessing }
DrsShape >> extentForBounds [

	^ self naturalInnerExtent
]

{ #category : #actions }
DrsShape >> extentPrediction [ 

	^ self bounds extentPrediction
]

{ #category : #accessing }
DrsShape >> hasAssignedExtent [ 
	
	^ self bounds innerExtentResolved
	
]

{ #category : #testing }
DrsShape >> hasPlaceholder [ 

	^ false
]

{ #category : #'selection highlights' }
DrsShape >> highlightText: aString emphasized: aBoolean [

	"do nothing for a general shape" 
]

{ #category : #accessing }
DrsShape >> horizontalLevel [

	^ self bounds nestingLevel
]

{ #category : #accessing }
DrsShape >> horizontalLevel: anObject [

	self bounds nestingLevel: anObject
]

{ #category : #testing }
DrsShape >> initialize [ 

	super initialize.
	
	installed := false.
	self markAsNotShifted.

]

{ #category : #'API - position and extent' }
DrsShape >> innerExtent: anExtent [ 

	self bounds innerExtent: anExtent
]

{ #category : #testing }
DrsShape >> installTo: aPage [ 

	installed ifTrue: [ ^ self ].
	installed := true.
	aPage canvasPart canvas addShape: self roassalShape
]

{ #category : #'debugging support' }
DrsShape >> isDebugging [ 

	^ false
]

{ #category : #testing }
DrsShape >> isEventsTarget [

	^ true
]

{ #category : #testing }
DrsShape >> isPermanent [

	^ true
]

{ #category : #testing }
DrsShape >> isPlaceholder [

	^ false
]

{ #category : #testing }
DrsShape >> isSelection [

	^ false
]

{ #category : #testing }
DrsShape >> isShapeGroup [

	^ false
]

{ #category : #testing }
DrsShape >> isTemporary [

	^ self isPermanent not
]

{ #category : #accessing }
DrsShape >> limitMaxExtentBy: aGroup [

	self setMaxWidth: aGroup maxWidthOrNil.
	self setMaxHeight: aGroup maxHeightOrNil.
]

{ #category : #accessing }
DrsShape >> limitMaxExtentBy: aGroup reducedBy: aPoint [

	self setMaxWidth: (aGroup maxWidthOrNil ifNotNil: [ :maxw | maxw - aPoint x ] ifNil: []).
	self setMaxHeight: (aGroup maxHeightOrNil ifNotNil: [ :maxh | maxh - aPoint y] ifNil: []).
]

{ #category : #'API - position and extent' }
DrsShape >> markAsNotShifted [ 

	shifted := false
]

{ #category : #'API - position and extent' }
DrsShape >> markAsNotShiftedRecursively [ 

	shifted := false
]

{ #category : #'API - position and extent' }
DrsShape >> markAsShifted [ 

	shifted := true
]

{ #category : #'API - position and extent' }
DrsShape >> markAsShiftedRecursively [ 

	shifted := true
]

{ #category : #testing }
DrsShape >> markAsUninstalled [ 

	installed := false.
]

{ #category : #accessing }
DrsShape >> maxHeight [
	^ maxHeight
]

{ #category : #accessing }
DrsShape >> maxHeight: anObject [
	maxHeight := anObject.
	self bounds maxHeight: anObject.
]

{ #category : #accessing }
DrsShape >> maxWidth [
	^ maxWidth
]

{ #category : #accessing }
DrsShape >> maxWidth: anObject [

	maxWidth := anObject.
	self bounds maxWidth: anObject.
]

{ #category : #accessing }
DrsShape >> minHeight [
	^ minHeight
]

{ #category : #accessing }
DrsShape >> minHeight: anObject [
	minHeight := anObject.
	self bounds minHeight: anObject.
]

{ #category : #accessing }
DrsShape >> minWidth [
	^ minWidth
]

{ #category : #accessing }
DrsShape >> minWidth: anObject [

	minWidth := anObject.
	self bounds minWidth: anObject.
]

{ #category : #'API - position and extent' }
DrsShape >> moveTransitoryTo: aPoint [

	| basePoint |
	basePoint := aPoint - self bounds transitoryOrRealOrigin.

	self ownBounds transitoryOrigin: aPoint.

	self shapes do: [ :each | 
		each moveTransitoryTo:
			basePoint + each bounds transitoryOrRealOrigin ]
]

{ #category : #accessing }
DrsShape >> nameOrNil [

	"for compatibility with groups"

	^ nil
]

{ #category : #actions }
DrsShape >> naturalExtent [

	^ self roassalShape naturalExtent
]

{ #category : #accessing }
DrsShape >> naturalInnerExtent [

	^ self roassalShape naturalExtent
]

{ #category : #accessing }
DrsShape >> nestingLevel [
	^ self bounds nestingLevel
]

{ #category : #accessing }
DrsShape >> nestingLevel: anObject [
	self bounds nestingLevel: anObject
]

{ #category : #testing }
DrsShape >> notEmpty [

	^ true
]

{ #category : #accessing }
DrsShape >> ownBounds [ 

	^ self bounds
]

{ #category : #accessing }
DrsShape >> permanent [ 

	^ true
]

{ #category : #accessing }
DrsShape >> pivotPosition [

"	^ self ownBounds transitoryOrRealOrigin "
	^ self ownBounds topLeftCornerPosition
]

{ #category : #accessing }
DrsShape >> pivotPosition: anObject [

	self bounds origin: anObject
]

{ #category : #printing }
DrsShape >> printBoundsOn: aStream depth: depth [ 

	depth timesRepeat: [ aStream tab ].
	self bounds printOn: aStream.
	aStream cr.

]

{ #category : #printing }
DrsShape >> printPredictionsOn: aStream depth: depth [ 

	depth timesRepeat: [ aStream tab ].
	self bounds extentPrediction printOn: aStream.
	aStream cr.

]

{ #category : #accessing }
DrsShape >> rawAssignedExtent [

	^ self bounds innerExtent
]

{ #category : #accessing }
DrsShape >> redirectionOrSelf [

	^ self
]

{ #category : #accessing }
DrsShape >> redirectionOrigin [ 

	^ nil
]

{ #category : #adding }
DrsShape >> registerToTable: aTableShapesInfo ifRoot: defRoot [ 

	| aLevel aRowId |
	
	aLevel := self horizontalLevel.
	aLevel ifNil: [ ^ self ].
	aRowId := self rowId.
	aRowId ifNil: [ ^ self ].

	aTableShapesInfo add: self atRow: aRowId column: aLevel
]

{ #category : #testing }
DrsShape >> removeFromPage: aPage [ 

	self roassalShape ifNotNil: [ :sh |
		installed := false.
		aPage canvas removeShape: sh ]
]

{ #category : #'selection highlights' }
DrsShape >> removeHighlights [

	"do nothing for a general shape" 
]

{ #category : #'API - position and extent' }
DrsShape >> resetTransitoryOrigin [

	self ownBounds resetTransitoryOrigin.
	self shapes do: [ :each  | each resetTransitoryOrigin  ]
]

{ #category : #actions }
DrsShape >> resolveExtentPrediction [

	^ self bounds resolveExtentPrediction

]

{ #category : #accessing }
DrsShape >> roassalPositionOffset [

	^ self roassalShape encompassingRectangle extent half
]

{ #category : #accessing }
DrsShape >> roassalShape [
	^ roassalShape
]

{ #category : #accessing }
DrsShape >> roassalShape: anObject [
	roassalShape := anObject.
	roassalShape model: self.
]

{ #category : #accessing }
DrsShape >> rowId [

	"the row ID can be any general object"

	^ rowId
]

{ #category : #accessing }
DrsShape >> rowId: anObject [

	"the row ID can be any general object"

	rowId := anObject
]

{ #category : #actions }
DrsShape >> setBounds: inputBounds [ 

	self bounds apply: inputBounds
]

{ #category : #accessing }
DrsShape >> setMaxHeight: aNumber [
	"do not overwrite existing max heigth with nil"
	aNumber ifNil: [ ^ self ].
	
	self maxHeight: aNumber
]

{ #category : #accessing }
DrsShape >> setMaxWidth: aNumber [
	"do not overwrite existing max width with nil"
	aNumber ifNil: [ ^ self ].
	
	self maxWidth: aNumber
]

{ #category : #actions }
DrsShape >> setOwnBounds: inputBounds [ 

	self bounds apply: inputBounds
]

{ #category : #accessing }
DrsShape >> shapeGroup [

	^ shapeGroup
]

{ #category : #accessing }
DrsShape >> shapeGroup: anObject [

	shapeGroup := anObject
]

{ #category : #accessing }
DrsShape >> shapeGroupOrSelf [

	^ shapeGroup
]

{ #category : #accessing }
DrsShape >> shapes [

	^ #()
]

{ #category : #'API - position and extent' }
DrsShape >> shiftIfUnder: aPoint by: shiftPoint [

	shifted ifTrue: [ ^ self ].
	self markAsShifted.
	self bounds shiftIfUnder: aPoint by: shiftPoint
]

{ #category : #accessing }
DrsShape >> shrink [

	^ shrink ifNil: [ 0@0 ]
]

{ #category : #accessing }
DrsShape >> shrink: anObject [

	shrink := anObject
]

{ #category : #accessing }
DrsShape >> someShape [ 

	^ self
]

{ #category : #accessing }
DrsShape >> someShapeOrNil [

	^ self
]

{ #category : #accessing }
DrsShape >> tableId [

	^ tableId
]

{ #category : #accessing }
DrsShape >> tableId: anObject [

	tableId := anObject
]

{ #category : #accessing }
DrsShape >> textRepresentation [

	^ ''
]

{ #category : #accessing }
DrsShape >> topLeftPosition: aPoint [

	self roassalShape position: aPoint + self roassalPositionOffset
]

{ #category : #'API - position and extent' }
DrsShape >> translateBy: aPoint [ 

	self bounds translateBy: aPoint 
]

{ #category : #actions }
DrsShape >> translatePivotBy: aPoint [

	self translatePivotTo: self pivotPosition + aPoint
]

{ #category : #actions }
DrsShape >> translatePivotTo: aPoint [

	self pivotPosition: aPoint
]
