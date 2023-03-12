Class {
	#name : #DrsTextHighlightBox,
	#superclass : #RSBox,
	#instVars : [
		'next',
		'highlightPosition',
		'highlightExtent',
		'visiblePosition',
		'visibleExtent',
		'range',
		'visible',
		'ellipsisWidth',
		'isCursor'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsTextHighlightBox >> ellipsisWidth [
	
	^ ellipsisWidth
]

{ #category : #accessing }
DrsTextHighlightBox >> ellipsisWidth: aNumber [

	ellipsisWidth := aNumber
]

{ #category : #accessing }
DrsTextHighlightBox >> ellipsisWidthFor: aLabel [ 

	"cache widht of the last highlight on ellipsis"
	
	^ ellipsisWidth ifNil: [
		ellipsisWidth := (aLabel metricsProvider characterPositionsFor: aLabel ellipsis font: aLabel labelShape font) second. ]
]

{ #category : #accessing }
DrsTextHighlightBox >> highlightExtent [

	^ highlightExtent
]

{ #category : #accessing }
DrsTextHighlightBox >> highlightExtent: anObject [

	highlightExtent := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> highlightPosition [

	^ highlightPosition
]

{ #category : #accessing }
DrsTextHighlightBox >> highlightPosition: anObject [

	highlightPosition := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> initialize [ 

	super initialize. 
	
	visible := false.
	isCursor := false.
]

{ #category : #accessing }
DrsTextHighlightBox >> isCursor [

	^ isCursor
]

{ #category : #accessing }
DrsTextHighlightBox >> isCursor: anObject [

	isCursor := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> lastShape [ 

	^ next 
		ifNil: [ self ]
		ifNotNil: [ next lastShape ]
]

{ #category : #accessing }
DrsTextHighlightBox >> next [

	^ next
]

{ #category : #accessing }
DrsTextHighlightBox >> next: anObject [

	next := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> range [

	^ range
]

{ #category : #accessing }
DrsTextHighlightBox >> range: anObject [

	range := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> roassalPositionOffset [

	^ self encompassingRectangle extent half
]

{ #category : #accessing }
DrsTextHighlightBox >> topLeftPosition: aPoint [

	self position: aPoint + self roassalPositionOffset
]

{ #category : #accessing }
DrsTextHighlightBox >> visible [

	^ visible
]

{ #category : #accessing }
DrsTextHighlightBox >> visible: anObject [

	visible := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> visibleExtent [

	^ visibleExtent
]

{ #category : #accessing }
DrsTextHighlightBox >> visibleExtent: anObject [

	visibleExtent := anObject
]

{ #category : #accessing }
DrsTextHighlightBox >> visiblePosition [

	^ visiblePosition
]

{ #category : #accessing }
DrsTextHighlightBox >> visiblePosition: anObject [

	visiblePosition := anObject
]
