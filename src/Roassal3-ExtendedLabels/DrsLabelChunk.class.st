"
I store information about label sublabels needed to generate real RSLabels on demand
"
Class {
	#name : #DrsLabelChunk,
	#superclass : #Object,
	#instVars : [
		'baseline',
		'lineIndex',
		'startingIndex',
		'length',
		'ellipsisWidth'
	],
	#category : #'Roassal3-ExtendedLabels-Support'
}

{ #category : #accessing }
DrsLabelChunk >> baseline [

	^ baseline
]

{ #category : #accessing }
DrsLabelChunk >> baseline: anObject [

	baseline := anObject
]

{ #category : #accessing }
DrsLabelChunk >> createShape [

	self subclassResponsibility 
]

{ #category : #accessing }
DrsLabelChunk >> displayedString [

	self subclassResponsibility
]

{ #category : #accessing }
DrsLabelChunk >> ellipsis [

	^ '…'
]

{ #category : #accessing }
DrsLabelChunk >> ellipsisWidth [ 

	^ ellipsisWidth
]

{ #category : #accessing }
DrsLabelChunk >> height [ 

	self subclassResponsibility
]

{ #category : #accessing }
DrsLabelChunk >> initialize [ 

	super initialize.
	lineIndex := 1.
	ellipsisWidth := 8.
]

{ #category : #accessing }
DrsLabelChunk >> isShrinked [ 

	^ false
]

{ #category : #accessing }
DrsLabelChunk >> isVisible [ 

	^ length ~= -1
]

{ #category : #accessing }
DrsLabelChunk >> length [

	^ length
]

{ #category : #accessing }
DrsLabelChunk >> length: anObject [

	length := anObject
]

{ #category : #accessing }
DrsLabelChunk >> lineIndex [

	^ lineIndex
]

{ #category : #accessing }
DrsLabelChunk >> lineIndex: anObject [

	lineIndex := anObject
]

{ #category : #accessing }
DrsLabelChunk >> padding [ 

	^ 0@0
]

{ #category : #accessing }
DrsLabelChunk >> startingIndex [

	^ startingIndex
]

{ #category : #accessing }
DrsLabelChunk >> startingIndex: anObject [

	startingIndex := anObject
]

{ #category : #'as yet unclassified' }
DrsLabelChunk >> subChunkOfMaxLength: maxLength [ 

	"use in tests only"
	^ self subChunkOfMaxLength: maxLength for: nil
]

{ #category : #accessing }
DrsLabelChunk >> subChunkOfMaxLength: maxLength for: labelOrNil [

	self subclassResponsibility
]

{ #category : #accessing }
DrsLabelChunk >> text [

	^ self subclassResponsibility 
]

{ #category : #accessing }
DrsLabelChunk >> width [

	^ self subclassResponsibility 
]
