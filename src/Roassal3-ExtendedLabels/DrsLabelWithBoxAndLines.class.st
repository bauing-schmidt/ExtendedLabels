"
special label used for separators
"
Class {
	#name : #DrsLabelWithBoxAndLines,
	#superclass : #DrsLabelWithBox,
	#instVars : [
		'leftLineShape',
		'rightLineShape'
	],
	#category : #'Roassal3-ExtendedLabels-Labels'
}

{ #category : #adding }
DrsLabelWithBoxAndLines >> addAdditionalShapesTo: aComposite [

	super addAdditionalShapesTo: aComposite.
	
	aComposite addShape: (leftLineShape := self ensureLeftLineShape copy).
	aComposite addShape: (rightLineShape := self ensureRightLineShape copy).

	
	
]

{ #category : #accessing }
DrsLabelWithBoxAndLines >> ensureLeftLineShape [

	| linesThickness linesColor |
	linesThickness := 1.
	linesColor := Color black.

	^ leftLineShape ifNil: [ 
		leftLineShape := RSBox new extent: 20@linesThickness; color: linesColor. ]
]

{ #category : #accessing }
DrsLabelWithBoxAndLines >> ensureRightLineShape [

	| linesThickness linesColor |
	linesThickness := 1.
	linesColor := Color black.

	^ rightLineShape ifNil: [ 
		rightLineShape := RSBox new extent: 50@linesThickness; color: linesColor. ]
]

{ #category : #adding }
DrsLabelWithBoxAndLines >> extentAddition [ 

	^ super extentAddition + self linesExtentAddition
]

{ #category : #adding }
DrsLabelWithBoxAndLines >> labelOffset [

	^ ((boxShape extent x) half  ) negated @0
]

{ #category : #adding }
DrsLabelWithBoxAndLines >> linesExtentAddition [

	^ 100@0
]

{ #category : #adding }
DrsLabelWithBoxAndLines >> naturalLabelExtent [

	^ super naturalLabelExtent x @ super naturalLabelExtent y
]

{ #category : #adding }
DrsLabelWithBoxAndLines >> placeAdditionalShapes [ 

	boxShape position: 0 @ boxShape extent half y.

	self hasIcon ifTrue: [
		rawIconShape position: ((boxShape extent x half negated) + boxProperties borderWidth half + boxProperties paddingLeft) + (iconShape width - (rawIconShape extent x - iconShape width)) half @ 0. 
	].

	leftLineShape position: (20 half + 10 + boxShape extent x half) negated @  boxShape extent y half. 
	rightLineShape position:  (70 half + boxShape extent x half) @  boxShape extent y half. 

]

{ #category : #adding }
DrsLabelWithBoxAndLines >> privAdaptSublables [

	super privAdaptSublables.
	
"	leftLineShape extent: self visibleExtent + self extentAdditionForBox + self extentAdditionForIcon.	"
"	leftLineShape extent: 500@10."
	
"	leftLineShape extent: self assignedExtent x /10 @ 2."
]
