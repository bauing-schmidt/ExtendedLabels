Class {
	#name : #DrsLabelBoxProperties,
	#superclass : #Object,
	#instVars : [
		'extraHorizontalPadding',
		'paddingLeft',
		'paddingRight',
		'paddingTop',
		'paddingBottom',
		'borderWidth',
		'cornerRadius',
		'color',
		'borderColor',
		'hoverFillColor',
		'hoverBorderColor',
		'iconOffset'
	],
	#classInstVars : [
		'sharedEmptyInstance'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsLabelBoxProperties class >> resetSharedEmptyInstance [

	<script>

	sharedEmptyInstance := nil
]

{ #category : #accessing }
DrsLabelBoxProperties class >> sharedEmptyInstance [

	^ sharedEmptyInstance ifNil: [ sharedEmptyInstance := self new ]
]

{ #category : #accessing }
DrsLabelBoxProperties >> borderColor [

	^ borderColor
]

{ #category : #accessing }
DrsLabelBoxProperties >> borderColor: anObject [

	borderColor := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> borderWidth [

	^ borderWidth
]

{ #category : #accessing }
DrsLabelBoxProperties >> borderWidth: anObject [

	borderWidth := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> bottomRightOffset [ 

	^ (paddingRight + borderWidth) @ (paddingBottom + borderWidth)
]

{ #category : #accessing }
DrsLabelBoxProperties >> color [

	^ color
]

{ #category : #accessing }
DrsLabelBoxProperties >> color: anObject [

	color := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> cornerRadius [

	^ cornerRadius
]

{ #category : #accessing }
DrsLabelBoxProperties >> cornerRadius: anObject [

	cornerRadius := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> extraHorizontalPadding [

	^ extraHorizontalPadding
]

{ #category : #accessing }
DrsLabelBoxProperties >> extraHorizontalPadding: anObject [

	extraHorizontalPadding := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> hoverBorderColor [

	^ hoverBorderColor ifNil: [ borderColor ]
]

{ #category : #accessing }
DrsLabelBoxProperties >> hoverBorderColor: anObject [

	hoverBorderColor := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> hoverFillColor [

	^ hoverFillColor ifNil: [ color ]
]

{ #category : #accessing }
DrsLabelBoxProperties >> hoverFillColor: anObject [

	hoverFillColor := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> iconOffset [

	^ iconOffset
]

{ #category : #accessing }
DrsLabelBoxProperties >> iconOffset: anObject [

	iconOffset := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> initialize [ 

	super initialize. 
	
	paddingTop := paddingBottom := paddingLeft := paddingRight := 0.
	extraHorizontalPadding := 0.
	borderWidth := 0.
	cornerRadius := 0.
	color := (Color r: 0.8836754643206256 g: 0.8836754643206256 b: 0.8836754643206256 alpha: 1.0).
	borderColor := Color black.
	hoverFillColor := nil.
	hoverBorderColor := nil.
	iconOffset := 6.
	
	
	
]

{ #category : #accessing }
DrsLabelBoxProperties >> isActive [ 

	^ hoverFillColor notNil or: [ hoverBorderColor notNil ]
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingBottom [

	^ paddingBottom
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingBottom: anObject [

	paddingBottom := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingHorizontal [ 

	^ paddingLeft + paddingRight" + extraHorizontalPadding"
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingLeft [

	^ paddingLeft
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingLeft: anObject [

	paddingLeft := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingRight [

	^ paddingRight
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingRight: anObject [

	paddingRight := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingTop [

	^ paddingTop
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingTop: anObject [

	paddingTop := anObject
]

{ #category : #accessing }
DrsLabelBoxProperties >> paddingVertical [

	^ paddingTop + paddingBottom
]

{ #category : #accessing }
DrsLabelBoxProperties >> topLeftOffset [

	^ (paddingLeft + borderWidth half) @ (paddingTop + borderWidth half)
]

{ #category : #accessing }
DrsLabelBoxProperties >> topLeftOffset2 [

	^ (paddingLeft + borderWidth) @ (paddingTop + borderWidth)
]
