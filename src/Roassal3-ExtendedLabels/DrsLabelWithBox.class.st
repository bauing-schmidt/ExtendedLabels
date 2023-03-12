"
a label with a box around it
"
Class {
	#name : #DrsLabelWithBox,
	#superclass : #DrsLabel,
	#instVars : [
		'boxShape',
		'margin',
		'padding',
		'boxProperties',
		'iconShape',
		'rawIconShape'
	],
	#category : #'Roassal3-ExtendedLabels-Labels'
}

{ #category : #accessing }
DrsLabelWithBox >> adaptAdditionalShapesExtents [
	
	| ext  | 
	ext := self boxExtent.
	boxShape extent: ext.
	boxShape position: (ext x negated + boxProperties borderWidth)@0.

	compositeShape adjustToChildrenRelatively 

]

{ #category : #accessing }
DrsLabelWithBox >> addAdditionalShapesTo: aComposite [

	aComposite addShape: self ensureBoxShape.
	boxShape extent: self drawnBoxExtent.
	self installMouseEvents.
	
	self hasIcon ifTrue: [
		aComposite addShape: rawIconShape copy.
	].
	
	

	
]

{ #category : #accessing }
DrsLabelWithBox >> boxExtent [ 

	^ (super visibleExtent + self extentAdditionForBox + self extentAdditionForIcon) 
]

{ #category : #accessing }
DrsLabelWithBox >> boxProperties [ 

	^ boxProperties
]

{ #category : #accessing }
DrsLabelWithBox >> boxShapeExtraAddition [ 

	(self wrappingEnabled and: [ self linesCount > 1]) ifTrue: [
		^ (maxLineWidth - self naturalLabelExtent x) @ 0 ].
	
	^ 0@0
]

{ #category : #accessing }
DrsLabelWithBox >> drawnBoxExtent [ 

	"what is visible from the box + half of the border width"
	
	^ self naturalLabelExtent + self extentAdditionForBox + self extentAdditionForIcon
]

{ #category : #accessing }
DrsLabelWithBox >> ensureBoxShape [

	^ boxShape ifNil: [ 
		boxShape := RSBox new
			cornerRadius: boxProperties cornerRadius;
			color: boxProperties color;
			border: (RSBorder new width: boxProperties borderWidth);
			borderColor: boxProperties borderColor ]
]

{ #category : #accessing }
DrsLabelWithBox >> extentAddition [

	^ self extentAdditionForBox + boxProperties borderWidth + self extentAdditionForIcon
]

{ #category : #accessing }
DrsLabelWithBox >> extentAdditionForBox [

	"we need to add two times the half of the border width"

	^ boxProperties paddingHorizontal @ boxProperties paddingVertical + boxProperties borderWidth + self boxShapeExtraAddition
]

{ #category : #accessing }
DrsLabelWithBox >> extentAdditionForIcon [

	self hasIcon ifFalse: [ ^ 0@0 ].
	
	^ (iconShape width + boxProperties iconOffset) @ 0.
]

{ #category : #accessing }
DrsLabelWithBox >> hasIcon [ 

	^ iconShape notNil
]

{ #category : #accessing }
DrsLabelWithBox >> iconDifference [ 

	^ ((iconShape widthDifference x - self topLeftOffset x) max: 0).
]

{ #category : #accessing }
DrsLabelWithBox >> iconOffset [

	^ boxProperties iconOffset
]

{ #category : #accessing }
DrsLabelWithBox >> iconShape [

	^ iconShape
]

{ #category : #accessing }
DrsLabelWithBox >> iconShape: aShape [

	iconShape := aShape.
	rawIconShape := RSBitmap new form: ((Form extent: 16@16 depth: 32) fillColor: (Color red alpha: 0.2); yourself).	
	rawIconShape := self iconShape roassalShape copy.
	rawIconShape adjustToChildren.

]

{ #category : #accessing }
DrsLabelWithBox >> initialize [

	super initialize.
	padding := margin := 0.
	boxProperties := DrsLabelBoxProperties sharedEmptyInstance.

]

{ #category : #accessing }
DrsLabelWithBox >> installMouseEvents [

	boxProperties isActive ifFalse: [ ^ self ].
	
	boxShape when: RSMouseEnter do: [ :event | 
		boxShape color: boxProperties hoverFillColor.
		boxShape borderColor: boxProperties hoverBorderColor.
		event canvas ifNotNil: [ :aCanvas | aCanvas signalUpdate ]. ]. 
	
	boxShape when: RSMouseLeave do: [ :event | 
		boxShape color: boxProperties color.
		boxShape borderColor: boxProperties borderColor.
		event canvas ifNotNil: [ :aCanvas | aCanvas signalUpdate ]. ]. 	
]

{ #category : #accessing }
DrsLabelWithBox >> labelOffset [

	^ boxProperties topLeftOffset + (self extentAdditionForIcon x @0)
]

{ #category : #accessing }
DrsLabelWithBox >> naturalExtent [

	^ self naturalInnerExtent
]

{ #category : #accessing }
DrsLabelWithBox >> naturalInnerExtent [

	^ self naturalLabelExtent + self extentAddition
]

{ #category : #accessing }
DrsLabelWithBox >> originCorrection [

	self hasIcon ifFalse: [ ^ 0@0 ].

	^ (self iconDifference half@ 0) negated
]

{ #category : #accessing }
DrsLabelWithBox >> overallExtent [ 

	^ labelExtent + self extentAdditionForIcon + self extentAdditionForBox
]

{ #category : #accessing }
DrsLabelWithBox >> placeAdditionalShapes [ 

	boxShape position: boxShape extent half.

	self hasIcon ifTrue: [
		| topLeftX paddingOffsetX paddingOffsetY |		
		topLeftX := boxShape extent x half negated.
		paddingOffsetX := boxProperties borderWidth half + boxProperties paddingLeft.
		paddingOffsetY := boxProperties borderWidth half + boxProperties paddingTop.
		self placeShape: rawIconShape at: (iconShape width - rawIconShape extent x)+paddingOffsetX@paddingOffsetY.
	].
	

]

{ #category : #accessing }
DrsLabelWithBox >> placeShape: aShape at: aPoint [ 

	"place aShape at top left position relative to the top left corner"
	
	aShape position: aPoint + aShape extent half.
	

]

{ #category : #accessing }
DrsLabelWithBox >> privAdaptSublables [

	super privAdaptSublables.
	
	boxShape extent: self boxExtent.
]

{ #category : #accessing }
DrsLabelWithBox >> readPropertiesFromStyleSheet [
		
	| firstStyle |	
		
	super readPropertiesFromStyleSheet.

	firstStyle := (text firstStyleOrNilFrom: styleSheet) ifNil: [ 
		boxProperties := DrsLabelBoxProperties new. 
		^ self ].
	
	boxProperties := firstStyle boxProperties 
	
]

{ #category : #accessing }
DrsLabelWithBox >> resetShapes [

	super resetShapes.
	boxShape := nil.
]

{ #category : #accessing }
DrsLabelWithBox >> topLeftOffset [ 

	^ boxProperties topLeftOffset
]

{ #category : #accessing }
DrsLabelWithBox >> topLeftPadding [

	^ wrappingEnabled 
		ifTrue: [ boxProperties topLeftOffset + self extentAdditionForIcon ]
		ifFalse: [ boxProperties topLeftOffset2 + self extentAdditionForIcon ]

]

{ #category : #accessing }
DrsLabelWithBox >> topLeftPosition: aPoint [

	self hasIcon ifFalse: [ 
		^ super topLeftPosition: aPoint ].
	
	super topLeftPosition: aPoint + self originCorrection.
]

{ #category : #accessing }
DrsLabelWithBox >> visibleExtent [

	^ super visibleExtent + self extentAddition
]
