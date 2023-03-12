Class {
	#name : #DrsExtendedIcon,
	#superclass : #DrsShape,
	#instVars : [
		'bitmapShape',
		'linkShape',
		'markShape',
		'isMarked',
		'isLink',
		'spacing',
		'iconSize'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #'instance creation' }
DrsExtendedIcon class >> exampleIcon [ 

	^ DrsExtendedIcon 
		withForm: ((Form extent: 16@16 depth: 32) fillColor: Color blue) 
		marked:  false
		link: false
		markColor: Color green
		linkColor: Color blue
		spacing: 0.
]

{ #category : #'instance creation' }
DrsExtendedIcon class >> withForm: aForm marked: isMarked link: isLink markColor: markColor linkColor: linkColor spacing: spacing [ 

	^ self new initializeWithForm: aForm marked: isMarked link: isLink markColor: markColor linkColor: linkColor spacing: spacing
]

{ #category : #initialization }
DrsExtendedIcon >> baselineShiftFrom: rowBaseline [ 

	"use the icon size as baseline unless it is bigger than the proposed baseline"

	^ (rowBaseline - self width) max: 0
]

{ #category : #initialization }
DrsExtendedIcon >> extent [

	^ iconSize@ iconSize
]

{ #category : #initialization }
DrsExtendedIcon >> extentForBounds [

	^ self width@self width
]

{ #category : #initialization }
DrsExtendedIcon >> initialize [ 

	super initialize.
	
	isMarked := false.
	isLink := false.
]

{ #category : #initialization }
DrsExtendedIcon >> initializeWithForm: aForm marked: marked link: link markColor: markColor linkColor: linkColor spacing: aSpacing [

	| shapesColl iconX x y alignmentSymbol markScale |

	isMarked := marked.
	isLink := link.
	spacing := aSpacing.
	iconSize := aForm extent x.
	alignmentSymbol := #left.
	markScale := 3.
	
	iconX := ((iconSize/2.0+(iconSize*0.25)))+(iconSize*spacing).
	x := 0.

	y := iconSize*(0.25).

 	bitmapShape := RSBitmap new.
	bitmapShape form: aForm.
	bitmapShape position: iconX@0.

	isMarked ifTrue: [ 
"		markShape := RSCircle new
			color: markColor;
			position: (x@y negated);
		   radius: y;
			yourself."
"		markShape := RSBitmap new 
			form: (PdmIconResourceSubsystem forTests getIconFormFor: 'mark_asteriskGray_9.png' inCategory: 'labels');
			position: (x@y negated);
			yourself.
"
		markShape := (self starShapeOfSize: y*markScale color: markColor)
			position: ((x*markScale) negated@(y*markScale half min: (self width - (y*markScale)) half negated));
			yourself
		 ].
		
	isLink ifTrue: [ 
	linkShape := RSPolygon new
		color: linkColor;
		borderColor: linkColor;
		points: { 0 @ (iconSize*0.15). 0@(iconSize*(-0.15)). (iconSize*0.3)@0  };
		position: (x@((iconSize - (iconSize*0.3)) half));
		yourself. ].
	
	shapesColl := OrderedCollection with: bitmapShape.
	isMarked ifTrue: [ shapesColl add: markShape ].
	isLink ifTrue: [ shapesColl add: linkShape ].
	
	(isMarked not and: [ isLink not ]) ifTrue: [ 
		"create an invisible shape in case no subicon is created"
		markShape := RSCircle new
			color: Color transparent;
			position: (x@y negated);
		   radius: y;
			yourself.
		 shapesColl add: markShape  ].	
			
	roassalShape := (DrsComposite new shapes: shapesColl).	
	roassalShape adjustToChildren.	
	self bounds naturalInnerExtent: iconSize@iconSize.
	self bounds innerExtent: iconSize@iconSize.
	minWidth := iconSize.
]

{ #category : #accessing }
DrsExtendedIcon >> isLink [

	^ isLink
]

{ #category : #accessing }
DrsExtendedIcon >> isLink: anObject [

	isLink := anObject
]

{ #category : #accessing }
DrsExtendedIcon >> isMarked [

	^ isMarked
]

{ #category : #accessing }
DrsExtendedIcon >> isMarked: anObject [

	isMarked := anObject
]

{ #category : #initialization }
DrsExtendedIcon >> naturalInnerExtent [

	^ iconSize@ iconSize
]

{ #category : #initialization }
DrsExtendedIcon >> roassalPositionOffset [

	^ super roassalPositionOffset - ((iconSize half+spacing)@0)
]

{ #category : #initialization }
DrsExtendedIcon >> starShapeOfSize: aSize color: aColor [ 

	^ RSComposite new
		addShape: ( 
			RSEllipse new
					extent: aSize@(aSize/10.0);
					rotateByDegrees: 45;
					color: aColor;
					yourself);
		addShape: ( 
			RSEllipse new
					extent: aSize@(aSize/10.0);
					rotateByDegrees: 90;
					color: aColor;
					yourself);		
		addShape: ( 
			RSEllipse new
					extent: aSize@(aSize/10.0);
					rotateByDegrees: 0;
					color: aColor;
					yourself);	
		addShape: ( 
			RSEllipse new
					extent: aSize@(aSize/10.0);
					rotateByDegrees: 135;
					color: aColor;
					yourself);							
		adjustToChildren;
		yourself					
		

]

{ #category : #initialization }
DrsExtendedIcon >> topLeftPosition: aPosition [ 

	self roassalShape position: aPosition - self widthDifference half + self extent half

]

{ #category : #initialization }
DrsExtendedIcon >> visibleExtent [

	^ iconSize@ iconSize
]

{ #category : #accessing }
DrsExtendedIcon >> width [ 
	
	^ iconSize
]

{ #category : #initialization }
DrsExtendedIcon >> widthDifference [ 

	^ roassalShape extent - self visibleExtent
]
